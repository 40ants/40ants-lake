import contextlib
import io
import os
import shutil
import sys
import tempfile
import unittest
from unittest import mock


ROOT = os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
sys.path.insert(0, os.path.join(ROOT, "scripts"))

import utr_lint


class MainTest(unittest.TestCase):
    def test_missing_file_returns_read_error(self):
        stderr = io.StringIO()
        stdout = io.StringIO()

        with contextlib.redirect_stderr(stderr), contextlib.redirect_stdout(stdout):
            result = utr_lint.main(["missing-file.md", "--fail-on", "never"])

        self.assertEqual(result, 2)
        self.assertIn("Файл не прочитан", stderr.getvalue())

    @unittest.skipIf(os.name != "posix" or os.geteuid() == 0,
                     "нужны права POSIX и запуск не от root")
    def test_unreadable_directory_returns_read_error(self):
        root = tempfile.mkdtemp()
        closed = os.path.join(root, "closed")
        os.mkdir(closed)
        with open(os.path.join(closed, "doc.md"), "w", encoding="utf-8") as handle:
            handle.write("Текст.\n")
        os.chmod(closed, 0o000)
        try:
            stderr = io.StringIO()
            with contextlib.redirect_stderr(stderr), contextlib.redirect_stdout(io.StringIO()):
                result = utr_lint.main([root, "--fail-on", "never"])
            self.assertEqual(result, 2)
            self.assertIn("Каталог не прочитан", stderr.getvalue())
        finally:
            os.chmod(closed, 0o755)
            shutil.rmtree(root)

    def test_walk_error_returns_read_error(self):
        def fail_walk(path, onerror):
            onerror(PermissionError(13, "Permission denied", path))
            return []

        stderr = io.StringIO()
        with tempfile.TemporaryDirectory() as root:
            with mock.patch.object(utr_lint.os, "walk", side_effect=fail_walk):
                with contextlib.redirect_stderr(stderr), contextlib.redirect_stdout(io.StringIO()):
                    result = utr_lint.main([root, "--fail-on", "never"])

        self.assertEqual(result, 2)
        self.assertIn("Каталог не прочитан", stderr.getvalue())
        self.assertIn(root, stderr.getvalue())

    def test_readable_file_returns_success(self):
        with tempfile.NamedTemporaryFile(mode="w", suffix=".md", encoding="utf-8") as handle:
            handle.write("Проверьте файл.\n")
            handle.flush()
            with contextlib.redirect_stdout(io.StringIO()):
                result = utr_lint.main([handle.name])

        self.assertEqual(result, 0)


class ReportModeTest(unittest.TestCase):
    """Отчёт о работе: краткое причастие сообщает результат (8.2.3.13 про инструкции)."""

    def _codes(self, text, mode):
        linter = utr_lint.Linter(mode=mode)
        units = utr_lint.prepare_markdown(text.splitlines())
        return {f.rule for f in linter.check_document("x.md", units)}

    def test_short_participle_allowed_in_report(self):
        self.assertNotIn("STR012", self._codes("Гонка исправлена.", "report"))

    def test_short_participle_flagged_in_docs(self):
        self.assertIn("STR012", self._codes("Гонка исправлена.", "docs"))

    def test_verbose_passive_still_flagged_in_report(self):
        self.assertIn("STR012", self._codes("Гонка была исправлена.", "report"))

    def test_reflexive_passive_still_flagged_in_report(self):
        self.assertIn("STR012", self._codes("Гонка исправляется.", "report"))


if __name__ == "__main__":
    unittest.main()
