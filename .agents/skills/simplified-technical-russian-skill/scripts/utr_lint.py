#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""Линтер упрощённого технического русского языка (УТР).

Проверяет русский текст по машинно-проверяемой части правил
ГОСТ Р 58049-2017, раздел 8.2.

Зависимостей нет. Нужен Python 3.7 и новее.

Примеры:
    python3 utr_lint.py README.md
    python3 utr_lint.py --mode code src/service.py
    python3 utr_lint.py --format json --fail-on error docs/
    python3 utr_lint.py --lexicon glossary.json docs/
    echo "Текст для проверки" | python3 utr_lint.py -

Линтер работает на эвристиках без морфологического анализатора.
Он даёт ложные срабатывания. Вывод — подсказка, а не приговор.
"""

from __future__ import annotations

import argparse
import json
import os
import re
import sys
from dataclasses import dataclass, field
from typing import Dict, Iterable, List, Optional, Sequence, Tuple

VERSION = "1.1.0"

SEVERITY_ORDER = {"info": 0, "warning": 1, "error": 2}
SEVERITY_RU = {"info": "подсказка", "warning": "предупреждение", "error": "ошибка"}


# --------------------------------------------------------------------------
# Модель находки
# --------------------------------------------------------------------------


@dataclass
class Finding:
    path: str
    line: int
    rule: str
    severity: str
    clause: str
    message: str
    fragment: str = ""
    suggestion: str = ""

    def as_dict(self) -> dict:
        return {
            "path": self.path,
            "line": self.line,
            "rule": self.rule,
            "severity": self.severity,
            "clause": self.clause,
            "message": self.message,
            "fragment": self.fragment,
            "suggestion": self.suggestion,
        }


RULES = [
    ("STR001", "error", "8.2.5.1", "Предложение длиннее допустимой длины"),
    ("STR002", "warning", "8.2.6.2", "Абзац длиннее шести предложений"),
    ("STR003", "info", "8.2.6.2", "Абзацы из одного предложения встречаются слишком часто"),
    ("STR010", "warning", "8.2.3.11", "Причастие"),
    ("STR011", "warning", "8.2.3.11", "Деепричастие"),
    ("STR012", "warning", "8.2.3.13", "Страдательный залог"),
    ("STR013", "warning", "8.2.3.11", "Составное сказуемое или связка"),
    ("STR020", "info", "8.2.3.10", "Цепочка из трёх и более существительных"),
    ("STR030", "error", "8.2.3.9", "Повелительное наклонение единственного числа"),
    ("STR031", "warning", "8.2.5.2", "Более одной команды в предложении"),
    ("STR040", "warning", "8.2.3.5", "Метафора, сравнение, сленг или жаргон"),
    ("STR041", "warning", "8.2.3.6", "Иностранное слово при наличии русского эквивалента"),
    ("STR042", "warning", "8.2.3.10", "Канцелярит или номинативная конструкция"),
    ("STR043", "info", "8.2.3.2", "Неопределённое или оценочное слово"),
    ("STR050", "info", "8.2.3.16", "Перечисление внутри предложения вместо списка"),
    ("STR051", "info", "8.2.3.18", "Слово-указатель элемента интерфейса"),
    ("STR060", "warning", "8.2.3.7", "Синоним вместо канонического термина глоссария"),
    ("STR061", "info", "8.2.3.8", "Сокращение без расшифровки при первом употреблении"),
]


# --------------------------------------------------------------------------
# Разбор текста на предложения и абзацы
# --------------------------------------------------------------------------

CYRILLIC = re.compile(r"[а-яёА-ЯЁ]")
PUNCT = " \t\r\n.,;:!?()[]{}«»\"'`—–-…*_|"

PROTECTED = [
    r"т\.\s*д\.",
    r"т\.\s*п\.",
    r"т\.\s*е\.",
    r"т\.\s*ч\.",
    r"\bдр\.",
    r"\bпр\.",
    r"\bсм\.",
    r"\bрис\.",
    r"\bтабл\.",
    r"\bстр\.",
    r"\bразд\.",
    r"\bприл\.",
    r"\bпп?\.",
    r"\bгл\.",
    r"\bгг?\.",
    r"\bвв?\.",
    r"\bим\.",
    r"\bизд\.",
    r"\bмлн\.",
    r"\bмлрд\.",
    r"\bтыс\.",
    r"\bруб\.",
    r"\bсек\.",
    r"\bмин\.",
    r"\d\.\d",
    r"\.[A-Za-z]{1,5}\b",
]
PROTECTED_RE = re.compile("|".join(PROTECTED))
DOT_MARK = "\x00"

SENTENCE_SPLIT = re.compile(r"(?<=[.!?…])[ \t]+(?=[«\"“(\[A-ZА-ЯЁ0-9])")
BRACKET_RE = re.compile(r"\(([^()]*)\)")
QUOTED_RE = re.compile(r"«[^»]*»|“[^”]*”|\"[^\"]{0,80}\"")
THOUSANDS_RE = re.compile(r"(?<=\d)[   ](?=\d{3}\b)")


def protect_dots(text: str) -> str:
    return PROTECTED_RE.sub(lambda m: m.group(0).replace(".", DOT_MARK), text)


def restore_dots(text: str) -> str:
    return text.replace(DOT_MARK, ".")


def split_sentences(text: str) -> List[Tuple[int, str]]:
    """Возвращает список пар (смещение, предложение)."""
    guarded = protect_dots(text)
    result = []
    start = 0
    for match in SENTENCE_SPLIT.finditer(guarded):
        chunk = guarded[start : match.start()]
        if chunk.strip():
            result.append((start, restore_dots(chunk).strip()))
        start = match.end()
    tail = guarded[start:]
    if tail.strip():
        result.append((start, restore_dots(tail).strip()))
    return result


def count_words(sentence: str) -> int:
    """Считает слова по допущениям примечания к пункту 8.2.5.1."""
    text = QUOTED_RE.sub(" ЦИТАТА ", sentence)
    text = BRACKET_RE.sub(" ", text)  # текст в скобках — отдельное предложение
    text = THOUSANDS_RE.sub("", text)
    tokens = [t.strip(PUNCT) for t in text.split()]
    return len([t for t in tokens if t])


def bracket_parts(sentence: str) -> List[str]:
    return [m.group(1).strip() for m in BRACKET_RE.finditer(sentence) if m.group(1).strip()]


def words_of(text: str) -> List[str]:
    return [w for w in re.findall(r"[а-яёА-ЯЁ]+(?:-[а-яёА-ЯЁ]+)?", text)]


# --------------------------------------------------------------------------
# Словари правил
# --------------------------------------------------------------------------


def stem(word: str, extra: int = 3) -> str:
    return r"\b" + word + r"[а-яё]{0,%d}\b" % extra


def exact(*forms: str) -> str:
    return r"\b(?:" + "|".join(forms) + r")\b"


# Канцелярит и номинативные конструкции (8.2.3.10, 8.2.3.11)
CLERICAL = [
    (stem("осуществля"), "выполнять, делать или прямой глагол"),
    (stem("осуществл", 5), "выполнить, сделать"),
    (exact("производится", "производятся", "производился"), "выполняют"),
    (stem("являет", 2), "быть или убрать связку"),
    (exact("являются", "являлся", "являлись", "являться"), "быть или убрать связку"),
    (exact("представляет собой", "представляют собой"), "это, быть"),
    (exact("данный", "данного", "данному", "данным", "данном", "данная", "данной", "данную", "данное"), "этот"),
    (exact("вышеуказанн\\w*", "нижеследующ\\w*", "вышеописанн\\w*"), "этот, следующий"),
    (exact("в случае если", "в том случае если", "в том случае когда"), "если"),
    (exact("с целью", "в целях"), "чтобы, для"),
    (exact("в качестве"), "как"),
    (exact("при помощи", "посредством"), "через, с помощью"),
    (exact("в связи с тем что", "ввиду того что", "по причине того что"), "потому что, так как"),
    (exact("на предмет"), "для, чтобы"),
    (exact("в настоящее время", "на текущий момент", "на данный момент"), "сейчас или убрать"),
    (exact("имеет место"), "есть, происходит"),
    (exact("необходимо отметить", "стоит отметить", "важно понимать", "следует учитывать"), "убрать, дать факт"),
    (exact("в рамках данной задачи", "в рамках данного проекта"), "в этой задаче"),
    (exact("по сути", "фактически", "собственно говоря"), "убрать"),
    (r"\bдля\s+(?:получения|создания|выполнения|обновления|удаления|проверки)\b", "чтобы получить, чтобы создать"),
    (r"\b(?:производить|выполнять|осуществлять)\s+[а-яё]+(?:ние|ку|цию)\b", "заменить парой один глагол"),
]

# Иностранные слова при наличии русских эквивалентов (8.2.3.6)
FOREIGN = [
    (stem("функционал"), "функции, возможности"),
    (stem("перформанс"), "быстродействие"),
    (stem("юзер"), "пользователь"),
    (stem("девайс"), "устройство"),
    (stem("ивент"), "событие"),
    (stem("экшен"), "действие"),
    (stem("апдейт"), "обновление"),
    (stem("дедлайн"), "срок"),
    (stem("эстимейт"), "оценка"),
    (stem("скоуп"), "объём, границы"),
    (stem("воркфлоу", 0), "процесс, порядок работ"),
    (stem("челлендж"), "сложность, задача"),
    (stem("секьюрити", 0), "безопасность"),
    (stem("ворнинг"), "предупреждение"),
    (stem("имплементац"), "реализация"),
    (stem("депрекейт"), "устаревший, нерекомендуемый"),
    (exact("фича", "фичи", "фичу", "фичей", "фичах", "фичами"), "функция, возможность"),
    (exact("таска", "таски", "таску", "таской", "тасок", "тасках"), "задача"),
    (exact("кейс", "кейса", "кейсу", "кейсы", "кейсов", "кейсе"), "случай, пример"),
    (exact("митинг", "митинга", "митинге", "митинги", "колл", "колла", "колле"), "встреча, созвон"),
    (stem("консистентност", 0), "согласованность"),
]

# Сленг и жаргон (8.2.3.5)
SLANG = [
    (stem("задеплой"), "развернуть"),
    (stem("деплой"), "развёртывание"),
    (stem("пофикс"), "исправить"),
    (stem("зафикс"), "исправить"),
    (stem("фикс", 2), "исправление"),
    (stem("апрув"), "согласовать"),
    (stem("заапрув"), "согласовать"),
    (stem("отревью"), "проверить, просмотреть"),
    (stem("смёрдж"), "слить, объединить"),
    (stem("смердж"), "слить, объединить"),
    (stem("закоммит"), "зафиксировать изменения"),
    (stem("зафейл"), "завершиться с ошибкой"),
    (stem("выкат"), "опубликовать, развернуть"),
    (stem("раскат"), "развернуть"),
    (stem("затюн"), "настроить"),
    (stem("костыл"), "временное решение"),
    (exact("велосипед", "велосипеды", "велосипеда"), "собственная реализация"),
    (exact("грабли", "граблях", "граблей"), "известная ошибка"),
    (exact("баг", "бага", "багу", "баги", "багов", "багах"), "ошибка, дефект"),
    (exact("прод", "прода", "проде", "проду", "продакшен", "продакшене"), "промышленная среда"),
    (exact("стейдж", "стейджа", "стейдже"), "тестовая среда"),
    (r"\bподнять\s+(?:сервис|под|инстанс|базу)\b", "запустить"),
    (r"\b(?:упал|упала|отвалил\w*|лежит)\b", "стал недоступен, завершился с ошибкой"),
]

# Метафоры и сравнения (8.2.3.5)
METAPHOR = [
    (exact("узкое место", "узким местом", "узкого места"), "ограничение быстродействия. Назовите ресурс"),
    (exact("под капотом"), "внутри реализации"),
    (exact("из коробки"), "без дополнительной настройки"),
    (exact("на лету"), "во время работы, без остановки"),
    (exact("боевой сервер", "боевом сервере", "боевая среда"), "промышленная среда"),
    (exact("бесшовно", "бесшовный", "бесшовное"), "без прерывания работы"),
    (exact("прозрачно для пользователя"), "без действий пользователя"),
    (r"\bчёрн\w+\s+магия\b|\bмагия\b|\bмагическ\w+\b", "неявное поведение"),
    (r"\bумн\w+\s+(?:кэш|алгоритм|логик\w+)\b", "назовите правило работы"),
    (r"\bкак\s+спагетти\b", "высокая связность модулей"),
]

# Неопределённость и оценочность (8.2.3.2, 8.2.5.4)
VAGUE = [
    (exact("быстро", "медленно", "долго"), "назовите время"),
    (exact("много", "мало", "немного", "некоторое количество"), "назовите число"),
    (exact("скоро", "позже", "через некоторое время"), "назовите срок"),
    (exact("как правило", "обычно", "зачастую"), "назовите условие"),
    (exact("вроде бы", "похоже", "кажется", "по идее"), "утверждайте факт или назовите проверку"),
    (exact("просто", "легко", "очевидно", "элементарно"), "уберите оценку сложности"),
    (exact("практически всегда", "почти всегда"), "назовите долю случаев"),
    (exact("и так далее", "и тому подобное"), "дайте полный список или правило отбора"),
    (exact("что-то пошло не так"), "назовите отказавший компонент и код ошибки"),
    (exact("довольно", "достаточно неплохо", "весьма"), "уберите или назовите величину"),
]

UI_WORDS = [
    (exact("кнопка", "кнопку", "кнопки", "кнопке", "кнопкой"), "назовите цель действия"),
    (exact("ссылка", "ссылку", "ссылки", "ссылке", "ссылкой"), "назовите цель действия"),
]


def compile_lexicon(pairs: Sequence[Tuple[str, str]], rule: str, clause: str, severity: str):
    out = []
    for pattern, replacement in pairs:
        out.append((re.compile(pattern, re.IGNORECASE), replacement, rule, clause, severity))
    return out


LEXICON = []
LEXICON += compile_lexicon(CLERICAL, "STR042", "8.2.3.10", "warning")
LEXICON += compile_lexicon(FOREIGN, "STR041", "8.2.3.6", "warning")
LEXICON += compile_lexicon(SLANG, "STR040", "8.2.3.5", "warning")
LEXICON += compile_lexicon(METAPHOR, "STR040", "8.2.3.5", "warning")
LEXICON += compile_lexicon(VAGUE, "STR043", "8.2.3.2", "info")
UI_LEXICON = compile_lexicon(UI_WORDS, "STR051", "8.2.3.18", "info")


# --------------------------------------------------------------------------
# Морфологические эвристики
# --------------------------------------------------------------------------

PARTICIPLE_ACTIVE = re.compile(
    r"\b[а-яё]{3,}(?:ущ|ющ|ащ|ящ|вш)(?:ий|ая|ее|ие|его|ему|им|ими|их|ую|юю|ей|ем|ом|ого|ых|ым)\b",
    re.IGNORECASE,
)
PARTICIPLE_PASSIVE = re.compile(
    r"\b[а-яё]{3,}(?:нн|енн|анн|янн|ённ)(?:ый|ая|ое|ые|ого|ому|ым|ых|ыми|ую|ом|ей)\b",
    re.IGNORECASE,
)
PARTICIPLE_STOP = {
    "длинный", "странный", "современный", "временный", "постоянный", "обыкновенный",
    "ценный", "истинный", "военный", "деревянный", "оловянный", "стеклянный",
    "единственный", "естественный", "ответственный", "существенный", "общественный",
    "государственный", "качественный", "количественный", "искусственный",
    "внутренний", "торжественный", "мгновенный", "законный", "равный", "главный",
    "нижний", "лучший", "хороший", "больший", "меньший", "старший", "младший",
    "будущий", "настоящий", "общий", "текущий", "следующий", "соответствующий",
}
# Прилагательные и существительные с -нн-, которые не являются причастиями.
PARTICIPLE_STOP_STEMS = (
    "переменн", "современн", "длинн", "странн", "ценн", "оконн", "временн",
    "постоянн", "единственн", "естественн", "ответственн", "существенн",
    "общественн", "государственн", "качественн", "количественн", "искусственн",
    "военн", "деревянн", "стеклянн", "оловянн", "истинн", "законн", "мгновенн",
    "торжественн", "внутренн", "письменн", "численн", "обыкновенн", "священн",
    "множественн", "неопределённ", "неопределенн", "маркированн", "подлежащ",
    "настоящ", "текущ", "следующ", "соответствующ", "будущ", "общ",
    "лучш", "хорош", "больш", "меньш", "старш", "младш", "нижн", "внешн",
    "иностранн", "государственн", "естественн", "машинн", "художественн",
    "одновременн", "распространённ", "распространенн", "упрощённ", "упрощенн",
)


def is_participle_stop(word: str) -> bool:
    low = word.lower()
    return low in PARTICIPLE_STOP or low.startswith(PARTICIPLE_STOP_STEMS)

GERUND_RE = re.compile(r"\b[а-яё]{3,}(?:ывая|ивая|уя|вши|вшись)\b|\b[а-яё]{2,}(?<!л)(?:ясь|ась)\b", re.IGNORECASE)
GERUND_WORDS = {
    "имея", "зная", "делая", "являясь", "исходя", "начиная", "включая",
    "считая", "получая", "создавая", "обрабатывая", "обеспечивая", "позволяя",
    "проверяя", "выполняя", "применяя", "используя", "учитывая", "основываясь",
}
GERUND_STOP = {"статуя", "струя", "сбруя", "аллилуя", "туя"}

REFLEXIVE_PASSIVE = re.compile(r"\b[а-яё]{4,}(?:ется|ются|ится|атся|ятся)\b", re.IGNORECASE)
REFLEXIVE_STOP = {
    "нравится", "боится", "смеётся", "смеется", "остаётся", "остается",
    "относится", "стремится", "случается", "оказывается", "получается",
    "является", "являются",  # обрабатывает STR013
}

SHORT_PASSIVE = re.compile(
    r"\b[а-яё]{4,}(?:ен|ена|ено|ены|ён|ан|ана|ано|аны|ята|ято|яты|ыт|ыта|ыто|ыты)\b",
    re.IGNORECASE,
)
# Краткие прилагательные и существительные с теми же окончаниями.
SHORT_PASSIVE_STOP = {
    "обязателен", "доступен", "важен", "нужен", "полезен", "возможен",
    "способен", "уверен", "силен", "силён", "свободен", "ясен", "сложен",
    "должен", "значителен", "эффективен", "опасен", "правилен", "виден",
    "стакан", "карман", "вулкан", "капитан", "барабан", "ветеран", "чемодан",
    "страна", "страны", "цена", "цены", "сцена", "сцены", "смена", "смены",
    "стена", "стены", "пена", "арена", "антенна", "замена", "замены", "измена",
    "сирена", "вена", "колена", "племена", "времена", "имена", "семена",
    "знамена", "планы", "органы", "экраны", "карманы", "романы", "туманы",
    "океаны", "вулканы", "капитаны", "раны", "охрана", "охраны", "поляна",
    "мембрана", "обмана", "корыто", "долото", "болото", "полено", "колено",
    "звено", "письмена", "заняты", "война", "весна", "десна",
}
BE_PASSIVE = re.compile(
    r"\b(?:был|была|было|были|будет|будут|быть)\s+[а-яё]{4,}(?:ен|ена|ено|ены|ан|ана|ано|аны|т|та|то|ты)\b",
    re.IGNORECASE,
)

COMPOUND_PREDICATE = re.compile(
    r"\b(?:является|являются|являлся|являлась|являлись|представляет собой|представляют собой)\b",
    re.IGNORECASE,
)

IMPERATIVE_SG = {
    "нажми", "открой", "закрой", "введи", "выбери", "проверь", "установи",
    "запусти", "добавь", "удали", "сохрани", "посмотри", "сделай", "укажи",
    "замени", "настрой", "перейди", "скопируй", "вставь", "включи", "выключи",
    "отправь", "создай", "напиши", "прочитай", "читай", "смотри", "жми",
    "кликни", "обнови", "измени", "задай", "возьми", "поставь", "убери",
    "останови", "перезапусти", "подожди", "попробуй", "убедись", "учти",
    "заполни", "отключи", "подключи", "собери", "разверни", "откати", "жди",
}
IMPERATIVE_PL = re.compile(r"\b[а-яё]{3,}(?:йте|ите|ьте)\b", re.IGNORECASE)
IMPERATIVE_PL_STOP = {"лимите", "магните", "аппетите", "паразите", "граните"}

ADJ_END = re.compile(
    r"(?:ый|ий|ой|ая|яя|ое|ее|ые|ие|ого|его|ому|ему|ым|им|ыми|ими|ых|их|ую|юю)$",
    re.IGNORECASE,
)
VERB_END = re.compile(
    r"(?:ть|ться|ет|ёт|ут|ют|ит|ат|ят|ем|ешь|ишь|ал|ял|ил|ел|ла|ло|ли|лась|лись)$",
    re.IGNORECASE,
)
FUNCTION_WORDS = {
    "в", "во", "на", "с", "со", "к", "ко", "по", "из", "от", "до", "за", "над",
    "под", "при", "про", "для", "без", "через", "между", "перед", "около",
    "и", "или", "а", "но", "да", "если", "что", "чтобы", "как", "когда", "то",
    "не", "ни", "же", "ли", "бы", "уже", "ещё", "еще", "только", "также",
    "этот", "эта", "это", "эти", "тот", "та", "те", "он", "она", "они", "оно",
    "его", "её", "их", "все", "всё", "весь", "вся", "там", "тут", "здесь",
    "после", "перед", "вместо", "кроме", "вдоль", "против", "более", "менее",
}
ADVERB_STOP = {
    "быстро", "медленно", "точно", "далеко", "близко", "рано", "поздно",
    "хорошо", "плохо", "нужно", "можно", "надо", "должно", "равно", "давно",
    "просто", "сложно", "верно", "неверно", "часто", "редко", "сразу", "затем",
}

SEMICOLON_LIST = re.compile(r";")


# --------------------------------------------------------------------------
# Подготовка исходных файлов
# --------------------------------------------------------------------------

LINE_COMMENT = {
    ".py": ["#"], ".sh": ["#"], ".bash": ["#"], ".zsh": ["#"], ".rb": ["#"],
    ".pl": ["#"], ".tf": ["#"], ".toml": ["#"], ".ini": ["#", ";"], ".conf": ["#"],
    ".yml": ["#"], ".yaml": ["#"], ".r": ["#"], ".jl": ["#"],
    ".js": ["//"], ".ts": ["//"], ".tsx": ["//"], ".jsx": ["//"], ".mjs": ["//"],
    ".go": ["//"], ".java": ["//"], ".c": ["//"], ".h": ["//"], ".cpp": ["//"],
    ".hpp": ["//"], ".cs": ["//"], ".rs": ["//"], ".kt": ["//"], ".swift": ["//"],
    ".scala": ["//"], ".php": ["//", "#"], ".css": [], ".scss": ["//"],
    ".sql": ["--"], ".lua": ["--"], ".hs": ["--"],
}
BLOCK_COMMENT = {
    ".js": ("/*", "*/"), ".ts": ("/*", "*/"), ".tsx": ("/*", "*/"),
    ".jsx": ("/*", "*/"), ".mjs": ("/*", "*/"), ".go": ("/*", "*/"),
    ".java": ("/*", "*/"), ".c": ("/*", "*/"), ".h": ("/*", "*/"),
    ".cpp": ("/*", "*/"), ".hpp": ("/*", "*/"), ".cs": ("/*", "*/"),
    ".rs": ("/*", "*/"), ".kt": ("/*", "*/"), ".swift": ("/*", "*/"),
    ".scala": ("/*", "*/"), ".php": ("/*", "*/"), ".css": ("/*", "*/"),
    ".scss": ("/*", "*/"), ".sql": ("/*", "*/"), ".html": ("<!--", "-->"),
    ".xml": ("<!--", "-->"), ".vue": ("<!--", "-->"),
}
SOURCE_EXT = set(LINE_COMMENT) | set(BLOCK_COMMENT)
TEXT_EXT = {".md", ".markdown", ".txt", ".rst", ".adoc", ""}


def extract_comments(lines: List[str], ext: str) -> List[Tuple[int, str]]:
    """Достаёт текст комментариев. Разбор упрощённый: строки в кавычках не отслеживает."""
    out: List[Tuple[int, str]] = []
    markers = LINE_COMMENT.get(ext, ["#"])
    block = BLOCK_COMMENT.get(ext)
    in_block = False
    in_doc = None  # тройные кавычки Python
    for number, raw in enumerate(lines, start=1):
        line = raw
        if in_doc is not None:
            end = line.find(in_doc)
            if end >= 0:
                out.append((number, line[:end]))
                in_doc = None
            else:
                out.append((number, line))
            continue
        if in_block and block:
            end = line.find(block[1])
            if end >= 0:
                out.append((number, line[:end]))
                line = line[end + len(block[1]) :]
                in_block = False
            else:
                out.append((number, line))
                continue
        if ext == ".py":
            for quote in ('"""', "'''"):
                pos = line.find(quote)
                if pos >= 0 and line.count(quote) == 1:
                    out.append((number, line[pos + 3 :]))
                    in_doc = quote
                    break
                if pos >= 0 and line.count(quote) >= 2:
                    parts = line.split(quote)
                    if len(parts) >= 3:
                        out.append((number, parts[1]))
            if in_doc is not None:
                continue
        if block:
            start = line.find(block[0])
            if start >= 0:
                end = line.find(block[1], start + len(block[0]))
                if end >= 0:
                    out.append((number, line[start + len(block[0]) : end]))
                    line = line[end + len(block[1]) :]
                else:
                    out.append((number, line[start + len(block[0]) :]))
                    in_block = True
                    continue
        for marker in markers:
            pos = line.find(marker)
            if pos >= 0 and line[:pos].count('"') % 2 == 0 and line[:pos].count("'") % 2 == 0:
                out.append((number, line[pos + len(marker) :]))
                break
    return [(n, t) for n, t in out if CYRILLIC.search(t)]


FENCE_RE = re.compile(r"^\s*(```|~~~)")
INLINE_CODE_RE = re.compile(r"`[^`]*`")
LINK_RE = re.compile(r"!?\[([^\]]*)\]\([^)]*\)")
HTML_COMMENT_RE = re.compile(r"<!--.*?-->", re.DOTALL)
URL_RE = re.compile(r"https?://\S+")
HEADING_RE = re.compile(r"^\s{0,3}#{1,6}\s+")
LIST_MARKER_RE = re.compile(r"^\s*(?:[-*+]|\d+[.)])\s+")
TABLE_RE = re.compile(r"^\s*\|")
TABLE_SEP_RE = re.compile(r"^\s*\|?[\s:|-]+\|[\s:|-]*$")


def prepare_markdown(lines: List[str]) -> List[Tuple[int, str, bool]]:
    """Возвращает список (номер строки, текст, это_проза).

    Код, таблицы и служебные строки помечены как не-проза: для них
    проверяют только лексику, но не длину предложений.
    """
    out: List[Tuple[int, str, bool]] = []
    in_fence = False
    in_frontmatter = False
    for number, raw in enumerate(lines, start=1):
        line = raw.rstrip("\n")
        if number == 1 and line.strip() == "---":
            in_frontmatter = True
            out.append((number, "", False))
            continue
        if in_frontmatter:
            if line.strip() in ("---", "..."):
                in_frontmatter = False
            out.append((number, "", False))
            continue
        if FENCE_RE.match(line):
            in_fence = not in_fence
            out.append((number, "", False))
            continue
        if in_fence:
            out.append((number, "", False))
            continue
        prose = True
        if TABLE_RE.match(line) or TABLE_SEP_RE.match(line):
            prose = False
        if LIST_MARKER_RE.match(line) or HEADING_RE.match(line):
            # Пункт списка и заголовок начинают новый блок.
            out.append((number, "", False))
        text = HTML_COMMENT_RE.sub(" ", line)
        text = LINK_RE.sub(r"\1", text)
        text = URL_RE.sub("ССЫЛКАКОД", text)
        text = INLINE_CODE_RE.sub("КОД", text)
        text = HEADING_RE.sub("", text)
        text = LIST_MARKER_RE.sub("", text)
        text = text.replace("|", " ")
        out.append((number, text, prose))
    return out


# --------------------------------------------------------------------------
# Глоссарий проекта
# --------------------------------------------------------------------------


@dataclass
class Glossary:
    terms: Dict[str, List[str]] = field(default_factory=dict)
    abbreviations: Dict[str, str] = field(default_factory=dict)
    banned: Dict[str, str] = field(default_factory=dict)
    allow: List[str] = field(default_factory=list)

    @staticmethod
    def load(path: str) -> "Glossary":
        with open(path, encoding="utf-8") as handle:
            data = json.load(handle)

        def clean(section) -> dict:
            if not isinstance(section, dict):
                return {}
            return {k: v for k, v in section.items() if not k.startswith("$")}

        allow = []
        allow_section = data.get("allow") or {}
        if isinstance(allow_section, dict):
            allow = [w.lower() for w in allow_section.get("words", [])]
        return Glossary(
            terms={k: list(v) for k, v in clean(data.get("terms")).items()},
            abbreviations=clean(data.get("abbreviations")),
            banned=clean(data.get("banned")),
            allow=allow,
        )

    def extra_lexicon(self):
        out = []
        for canonical, synonyms in self.terms.items():
            for synonym in synonyms:
                out.append(
                    (
                        re.compile(stem(re.escape(synonym.lower()), 3), re.IGNORECASE),
                        "канонический термин «%s»" % canonical,
                        "STR060",
                        "8.2.3.7",
                        "warning",
                    )
                )
        for word, replacement in self.banned.items():
            out.append(
                (
                    re.compile(stem(re.escape(word.lower()), 3), re.IGNORECASE),
                    replacement,
                    "STR041",
                    "8.2.3.6",
                    "warning",
                )
            )
        return out


# --------------------------------------------------------------------------
# Проверки
# --------------------------------------------------------------------------


class Linter:
    def __init__(self, mode: str = "docs", max_words: int = 20, max_sentences: int = 6,
                 glossary: Optional[Glossary] = None):
        self.mode = mode
        self.max_words = max_words
        self.max_sentences = max_sentences
        self.glossary = glossary or Glossary()
        self.lexicon = list(LEXICON) + self.glossary.extra_lexicon()
        if mode == "docs":
            self.lexicon += UI_LEXICON

    # -- вспомогательное ---------------------------------------------------

    def allowed(self, fragment: str) -> bool:
        low = fragment.lower()
        return any(word in low for word in self.glossary.allow)

    def add(self, out: List[Finding], path: str, line: int, rule: str, severity: str,
            clause: str, message: str, fragment: str = "", suggestion: str = "") -> None:
        if fragment and self.allowed(fragment):
            return
        out.append(Finding(path, line, rule, severity, clause, message, fragment.strip(), suggestion))

    # -- правила уровня предложения ---------------------------------------

    def check_sentence(self, out: List[Finding], path: str, line: int, sentence: str) -> None:
        if not CYRILLIC.search(sentence):
            return
        low = sentence.lower().replace("ё", "ё")

        length = count_words(sentence)
        if length > self.max_words:
            self.add(out, path, line, "STR001", "error", "8.2.5.1",
                     "Предложение содержит %d слов при пределе %d. Разбейте его." % (length, self.max_words),
                     shorten(sentence))
        for part in bracket_parts(sentence):
            part_length = count_words(part)
            if part_length > self.max_words:
                self.add(out, path, line, "STR001", "error", "8.2.5.1",
                         "Текст в скобках считают отдельным предложением: %d слов." % part_length,
                         shorten(part))

        for regex in (PARTICIPLE_ACTIVE, PARTICIPLE_PASSIVE):
            for match in regex.finditer(sentence):
                if is_participle_stop(match.group(0)):
                    continue
                self.add(out, path, line, "STR010", "warning", "8.2.3.11",
                         "Причастие «%s». Замените придаточным или отдельным предложением." % match.group(0),
                         match.group(0))

        for match in GERUND_RE.finditer(sentence):
            word = match.group(0).lower()
            if word in GERUND_STOP:
                continue
            self.add(out, path, line, "STR011", "warning", "8.2.3.11",
                     "Деепричастие «%s». Разбейте предложение." % match.group(0), match.group(0))
        for word in words_of(low):
            if word in GERUND_WORDS:
                self.add(out, path, line, "STR011", "warning", "8.2.3.11",
                         "Деепричастие «%s». Разбейте предложение." % word, word)

        for match in REFLEXIVE_PASSIVE.finditer(sentence):
            if match.group(0).lower() in REFLEXIVE_STOP:
                continue
            self.add(out, path, line, "STR012", "warning", "8.2.3.13",
                     "Возможен страдательный залог: «%s». Примените действительный залог." % match.group(0),
                     match.group(0))
        if self.mode != "report":
            # В отчёте краткое причастие сообщает результат: «Кэш переписан».
            # Пункт 8.2.3.13 ограничен инструкциями, отчёт под него не подпадает.
            for match in SHORT_PASSIVE.finditer(sentence):
                if match.group(0).lower() in SHORT_PASSIVE_STOP:
                    continue
                self.add(out, path, line, "STR012", "warning", "8.2.3.13",
                         "Возможно краткое страдательное причастие: «%s»." % match.group(0),
                         match.group(0))
        for match in BE_PASSIVE.finditer(sentence):
            self.add(out, path, line, "STR012", "warning", "8.2.3.13",
                     "Страдательный залог: «%s»." % match.group(0), match.group(0))

        for match in COMPOUND_PREDICATE.finditer(sentence):
            self.add(out, path, line, "STR013", "warning", "8.2.3.11",
                     "Связка «%s». Уберите её или замените глаголом." % match.group(0), match.group(0))

        self.check_noun_chain(out, path, line, sentence)
        self.check_imperative(out, path, line, sentence)

        if len(SEMICOLON_LIST.findall(sentence)) >= 2:
            self.add(out, path, line, "STR050", "info", "8.2.3.16",
                     "Перечисление внутри предложения. Оформите вертикальным маркированным списком.",
                     shorten(sentence))

        for pattern, replacement, rule, clause, severity in self.lexicon:
            match = pattern.search(sentence)
            if match:
                self.add(out, path, line, rule, severity, clause,
                         "«%s» → %s" % (match.group(0), replacement), match.group(0), replacement)

    def check_noun_chain(self, out: List[Finding], path: str, line: int, sentence: str) -> None:
        run: List[str] = []
        for token in re.findall(r"[а-яёА-ЯЁ]+", sentence):
            low = token.lower()
            base = re.sub(r"(?:ся|сь)$", "", low)
            nounish = (
                len(low) >= 4
                and low not in FUNCTION_WORDS
                and low not in ADVERB_STOP
                and not ADJ_END.search(low)
                and not VERB_END.search(base)
            )
            if nounish:
                run.append(token)
                continue
            if len(run) >= 3:
                self.add(out, path, line, "STR020", "info", "8.2.3.10",
                         "Возможна цепочка существительных: «%s». Примените глагол или сокращение."
                         % " ".join(run), " ".join(run))
            run = []
        if len(run) >= 3:
            self.add(out, path, line, "STR020", "info", "8.2.3.10",
                     "Возможна цепочка существительных: «%s». Примените глагол или сокращение."
                     % " ".join(run), " ".join(run))

    def check_imperative(self, out: List[Finding], path: str, line: int, sentence: str) -> None:
        tokens = re.findall(r"[а-яёА-ЯЁ]+", sentence)
        for index, token in enumerate(tokens):
            if token.lower() in IMPERATIVE_SG and index <= 2:
                self.add(out, path, line, "STR030", "error", "8.2.3.9",
                         "Повелительное наклонение единственного числа: «%s». Примените множественное число."
                         % token, token)
                break
        plural = [m.group(0) for m in IMPERATIVE_PL.finditer(sentence)
                  if m.group(0).lower() not in IMPERATIVE_PL_STOP]
        if len(plural) >= 2 and " или " not in sentence.lower():
            self.add(out, path, line, "STR031", "warning", "8.2.5.2",
                     "В предложении несколько команд: %s. Разделите предложения."
                     % ", ".join("«%s»" % p for p in plural), shorten(sentence))

    # -- правила уровня абзаца и документа ---------------------------------

    def check_document(self, path: str, units: List[Tuple[int, str, bool]],
                       break_lines: bool = False) -> List[Finding]:
        out: List[Finding] = []
        paragraphs: List[Tuple[int, str, List[Tuple[int, int]]]] = []
        buffer: List[Tuple[int, str]] = []
        previous_line = None
        for number, text, prose in units:
            gap = previous_line is not None and number > previous_line + 1
            if text.strip() and prose and not gap:
                buffer.append((number, text))
                previous_line = number
                continue
            if buffer:
                paragraphs.append(build_block(buffer, break_lines))
                buffer = []
            if text.strip() and prose:
                buffer.append((number, text))
                previous_line = number
                continue
            previous_line = number if text.strip() else previous_line
            if text.strip() and not prose:
                for _, sentence in split_sentences(text):
                    self.check_lexicon_only(out, path, number, sentence)
        if buffer:
            paragraphs.append(build_block(buffer, break_lines))

        single_sentence = 0
        for line, paragraph, offsets in paragraphs:
            sentences = split_sentences(paragraph)
            for offset, sentence in sentences:
                self.check_sentence(out, path, line_at(offsets, offset, line), sentence)
            if self.mode != "chat" and len(sentences) > self.max_sentences:
                self.add(out, path, line, "STR002", "warning", "8.2.6.2",
                         "Абзац содержит %d предложений при пределе %d. Разделите абзац."
                         % (len(sentences), self.max_sentences), shorten(paragraph))
            if len(sentences) == 1:
                single_sentence += 1
        if self.mode == "docs" and len(paragraphs) >= 10:
            allowed = max(1, len(paragraphs) // 10)
            if single_sentence > allowed:
                self.add(out, path, paragraphs[0][0], "STR003", "info", "8.2.6.2",
                         "Абзацев из одного предложения: %d при норме %d на %d абзацев."
                         % (single_sentence, allowed, len(paragraphs)))
        out.extend(self.check_abbreviations(path, units))
        return out

    def check_lexicon_only(self, out: List[Finding], path: str, line: int, sentence: str) -> None:
        if not CYRILLIC.search(sentence):
            return
        for pattern, replacement, rule, clause, severity in self.lexicon:
            match = pattern.search(sentence)
            if match:
                self.add(out, path, line, rule, severity, clause,
                         "«%s» → %s" % (match.group(0), replacement), match.group(0), replacement)

    def check_abbreviations(self, path: str, units: List[Tuple[int, str, bool]]) -> List[Finding]:
        out: List[Finding] = []
        if not self.glossary.abbreviations:
            return out
        joined = "\n".join(text for _, text, _ in units)
        for abbreviation, full in self.glossary.abbreviations.items():
            match = re.search(r"\b%s\b" % re.escape(abbreviation), joined)
            if not match:
                continue
            head = joined[: match.start()]
            first_word = full.split()[0] if full.split() else full
            if first_word.lower() in head.lower():
                continue
            line = joined.count("\n", 0, match.start()) + 1
            self.add(out, path, line, "STR061", "info", "8.2.3.8",
                     "Сокращение «%s» встречается без расшифровки. Приведите полную форму: %s."
                     % (abbreviation, full), abbreviation)
        return out


def build_block(items: List[Tuple[int, str]], break_lines: bool):
    """Склеивает строки абзаца и запоминает смещение каждой строки.

    В режиме комментариев строка без конечного знака препинания перед строкой
    с прописной буквы считается концом предложения.
    """
    text = ""
    offsets: List[Tuple[int, int]] = []
    for number, raw in items:
        chunk = raw.strip()
        if not chunk:
            continue
        if text:
            if break_lines and text[-1] not in ".!?:;,-—" and chunk[:1].isupper():
                text += ". "
            else:
                text += " "
        offsets.append((len(text), number))
        text += chunk
    start = offsets[0][1] if offsets else (items[0][0] if items else 0)
    return start, text, offsets


def line_at(offsets: List[Tuple[int, int]], position: int, default: int) -> int:
    line = default
    for start, number in offsets:
        if start <= position:
            line = number
        else:
            break
    return line


def dedupe(findings: List[Finding]) -> List[Finding]:
    """Убирает повторы. Один фрагмент в одной строке даёт одну находку."""
    findings = sorted(findings, key=lambda f: (f.path, f.line, f.rule))
    seen = set()
    out = []
    for finding in findings:
        if not finding.fragment:
            out.append(finding)
            continue
        key = (finding.path, finding.line, finding.fragment.lower())
        if key in seen:
            continue
        seen.add(key)
        out.append(finding)
    return out


def shorten(text: str, limit: int = 90) -> str:
    text = " ".join(text.split())
    return text if len(text) <= limit else text[: limit - 1] + "…"


# --------------------------------------------------------------------------
# Обход файлов
# --------------------------------------------------------------------------


def iter_files(paths: Sequence[str], on_error=None) -> Iterable[str]:
    """Обходит пути. on_error получает OSError при недоступном каталоге."""
    for path in paths:
        if path == "-":
            yield path
            continue
        if os.path.isdir(path):
            for root, dirs, files in os.walk(path, onerror=on_error):
                dirs[:] = [d for d in dirs if d not in {".git", "node_modules", ".venv", "venv", "__pycache__", "dist", "build"}]
                for name in sorted(files):
                    ext = os.path.splitext(name)[1].lower()
                    if ext in TEXT_EXT or ext in SOURCE_EXT:
                        yield os.path.join(root, name)
        else:
            yield path


def read_lines(path: str) -> List[str]:
    if path == "-":
        return sys.stdin.read().splitlines()
    with open(path, encoding="utf-8", errors="replace") as handle:
        return handle.read().splitlines()


DISABLE_FILE_RE = re.compile(r"utr-lint:\s*disable-file")
DISABLE_NEXT_RE = re.compile(r"utr-lint:\s*disable-next-line")
DISABLE_LINE_RE = re.compile(r"utr-lint:\s*disable\b(?!-)")


def suppressed_lines(lines: List[str]) -> Optional[set]:
    """Возвращает номера подавленных строк. None означает «пропустить файл»."""
    if any(DISABLE_FILE_RE.search(line) for line in lines[:30]):
        return None
    skip = set()
    for number, line in enumerate(lines, start=1):
        if DISABLE_NEXT_RE.search(line):
            skip.add(number + 1)
        elif DISABLE_LINE_RE.search(line):
            skip.add(number)
    return skip


def analyse(path: str, linter: Linter, only_comments: Optional[bool]) -> List[Finding]:
    lines = read_lines(path)
    skip = suppressed_lines(lines)
    if skip is None:
        return []
    ext = os.path.splitext(path)[1].lower() if path != "-" else ""
    use_comments = only_comments if only_comments is not None else (ext in SOURCE_EXT)
    if use_comments and ext in SOURCE_EXT:
        units = [(number, text, True) for number, text in extract_comments(lines, ext)]
        findings = linter.check_document(path, units, break_lines=True)
    else:
        findings = linter.check_document(path, prepare_markdown(lines))
    return [f for f in findings if f.line not in skip]


# --------------------------------------------------------------------------
# Вывод
# --------------------------------------------------------------------------


def report_text(findings: List[Finding], show_rules: bool) -> str:
    if not findings:
        return "Нарушений не найдено."
    lines = []
    for finding in findings:
        lines.append(
            "%s:%d: %s [%s] %s (ГОСТ Р 58049-2017, пункт %s)"
            % (finding.path, finding.line, finding.rule,
               SEVERITY_RU[finding.severity], finding.message, finding.clause)
        )
        if finding.fragment and finding.fragment not in finding.message:
            lines.append("    → %s" % shorten(finding.fragment))
    counts = {"error": 0, "warning": 0, "info": 0}
    for finding in findings:
        counts[finding.severity] += 1
    lines.append("")
    lines.append("Итого: ошибок %d, предупреждений %d, подсказок %d."
                 % (counts["error"], counts["warning"], counts["info"]))
    if show_rules:
        lines.append("Правила: python3 utr_lint.py --list-rules")
    return "\n".join(lines)


def report_json(findings: List[Finding]) -> str:
    return json.dumps([f.as_dict() for f in findings], ensure_ascii=False, indent=2)


def list_rules() -> str:
    lines = ["Правила линтера УТР (ГОСТ Р 58049-2017):", ""]
    for rule, severity, clause, title in RULES:
        lines.append("%s  %-14s п. %-8s %s" % (rule, SEVERITY_RU[severity], clause, title))
    return "\n".join(lines)


def run_hook(args) -> int:
    """Режим хука Claude Code (PostToolUse).

    Читает событие в JSON со стандартного ввода, проверяет записанный файл и
    возвращает нарушения модели через поле reason. Ход не прерывает.
    """
    try:
        payload = json.load(sys.stdin)
    except (ValueError, TypeError):
        return 0
    tool_input = payload.get("tool_input") or {}
    tool_response = payload.get("tool_response") or {}
    path = tool_response.get("filePath") or tool_input.get("file_path")
    if not isinstance(path, str) or not os.path.isfile(path):
        return 0
    ext = os.path.splitext(path)[1].lower()
    if ext not in TEXT_EXT and ext not in SOURCE_EXT:
        return 0

    glossary = Glossary.load(args.lexicon) if args.lexicon else None
    linter = Linter(mode="code" if ext in SOURCE_EXT else "docs",
                    max_words=args.max_words, max_sentences=args.max_sentences,
                    glossary=glossary)
    try:
        findings = dedupe(analyse(path, linter, args.only_comments))
    except OSError:
        return 0

    threshold = SEVERITY_ORDER[args.min_severity or "error"]
    findings = [f for f in findings if SEVERITY_ORDER[f.severity] >= threshold]
    if not findings:
        return 0

    lines = ["Русский текст в %s нарушает УТР (ГОСТ Р 58049—2017). Исправьте:" % path]
    for finding in findings[:20]:
        lines.append("- строка %d, %s (пункт %s): %s"
                     % (finding.line, finding.rule, finding.clause, finding.message))
    if len(findings) > 20:
        lines.append("- ещё %d находок" % (len(findings) - 20))
    print(json.dumps({
        "decision": "block",
        "reason": "\n".join(lines),
        "systemMessage": "УТР: найдено нарушений — %d" % len(findings),
    }, ensure_ascii=False))
    return 0


def main(argv: Optional[Sequence[str]] = None) -> int:
    parser = argparse.ArgumentParser(
        prog="utr_lint.py",
        description="Линтер упрощённого технического русского языка (ГОСТ Р 58049-2017, раздел 8.2).",
    )
    parser.add_argument("paths", nargs="*", help="файлы или каталоги; «-» читает стандартный ввод")
    parser.add_argument("--mode", choices=["docs", "code", "chat", "report"], default="docs",
                        help="режим проверки: docs (по умолчанию), code, chat, "
                             "report (описание MR, журнал изменений — краткое причастие разрешено)")
    parser.add_argument("--only-comments", dest="only_comments", action="store_true", default=None,
                        help="проверять только комментарии в исходных файлах")
    parser.add_argument("--full-text", dest="only_comments", action="store_false",
                        help="проверять файл целиком, даже если это исходный код")
    parser.add_argument("--max-words", type=int, default=20, help="предел слов в предложении (8.2.5.1)")
    parser.add_argument("--max-sentences", type=int, default=6, help="предел предложений в абзаце (8.2.6.2)")
    parser.add_argument("--lexicon", help="файл глоссария проекта в формате JSON (8.1.7)")
    parser.add_argument("--format", choices=["text", "json"], default="text", help="формат вывода")
    parser.add_argument("--fail-on", choices=["error", "warning", "info", "never"], default="error",
                        help="уровень, при котором код возврата равен 1 "
                             "(код 2 при ошибке чтения — независимо от этого флага)")
    parser.add_argument("--min-severity", choices=["error", "warning", "info"], default=None,
                        help="не показывать находки ниже уровня (по умолчанию info, в режиме --hook — error)")
    parser.add_argument("--hook", action="store_true",
                        help="режим хука Claude Code: читает событие PostToolUse со стандартного ввода")
    parser.add_argument("--list-rules", action="store_true", help="показать список правил и выйти")
    parser.add_argument("--version", action="version", version="utr_lint %s" % VERSION)
    args = parser.parse_args(argv)

    if args.list_rules:
        print(list_rules())
        return 0
    if args.hook:
        return run_hook(args)
    if not args.paths:
        parser.print_help()
        return 0

    glossary = Glossary.load(args.lexicon) if args.lexicon else None
    linter = Linter(mode=args.mode, max_words=args.max_words,
                    max_sentences=args.max_sentences, glossary=glossary)

    findings: List[Finding] = []
    read_error = False

    def note_walk_error(error: OSError) -> None:
        nonlocal read_error
        print("Каталог не прочитан: %s (%s)"
              % (getattr(error, "filename", "?"), error), file=sys.stderr)
        read_error = True

    for path in iter_files(args.paths, on_error=note_walk_error):
        try:
            findings.extend(analyse(path, linter, args.only_comments))
        except OSError as error:
            print("Файл не прочитан: %s (%s)" % (path, error), file=sys.stderr)
            read_error = True

    findings = dedupe(findings)
    threshold = SEVERITY_ORDER[args.min_severity or "info"]
    findings = [f for f in findings if SEVERITY_ORDER[f.severity] >= threshold]
    findings.sort(key=lambda f: (f.path, f.line, -SEVERITY_ORDER[f.severity], f.rule))

    if args.format == "json":
        print(report_json(findings))
    else:
        print(report_text(findings, show_rules=bool(findings)))

    if read_error:
        return 2
    if args.fail_on == "never":
        return 0
    limit = SEVERITY_ORDER[args.fail_on]
    return 1 if any(SEVERITY_ORDER[f.severity] >= limit for f in findings) else 0


if __name__ == "__main__":
    sys.exit(main())
