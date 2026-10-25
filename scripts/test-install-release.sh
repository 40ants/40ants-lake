#!/usr/bin/env bash
# Unit tests for scripts/install-release. Pure bash, no bats.
#
# Tests fake the host via env overrides: SRV_SERVICES_ROOT, SYSTEMCTL,
# RUN_AS, LOG_FILE. See the helper's header for their semantics.

set -uuo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
HELPER="$SCRIPT_DIR/install-release"

PASS=0
FAIL=0
ALL_TMP=()


pass() {
  PASS=$((PASS + 1))
  printf '  ok - %s\n' "$1"
}

fail() {
  FAIL=$((FAIL + 1))
  printf '  NOT OK - %s\n' "$1"
}

t() {
  printf '* %s\n' "$1"
}

assert_eq() {
  # assert_eq <expected> <actual> <label>
  if [[ "$2" == "$1" ]]; then
    pass "$3"
  else
    fail "$3 (expected '$1', got '$2')"
  fi
}

assert_contains() {
  # assert_contains <file> <needle> <label>
  if [[ -f "$1" ]] && grep -qF -- "$2" "$1"; then
    pass "$3"
  else
    fail "$3 (missing '$2' in $1)"
  fi
}

assert_exists() {
  if [[ -e "$1" ]]; then
    pass "$2"
  else
    fail "$2 ($1 missing)"
  fi
}

assert_absent() {
  if [[ ! -e "$1" ]]; then
    pass "$2"
  else
    fail "$2 ($1 still exists)"
  fi
}

assert_nonzero_exit() {
  # assert_nonzero_exit <cmd...>
  "$@" >/dev/null 2>&1
  local rc=$?
  if [[ $rc -ne 0 ]]; then
    pass "non-zero exit: $*"
  else
    fail "expected non-zero exit, got 0: $*"
  fi
}

setup_env() {
  mkdir -p /tmp/opencode
  local tmp
  tmp=$(mktemp -d /tmp/opencode/ir-test.XXXXXXXX)
  ALL_TMP+=("$tmp")

  SRV="$tmp/srv/services"
  export SRV_SERVICES_ROOT="$SRV"
  export LOG_FILE="$tmp/install.log"
  : >"$LOG_FILE"

  export SYSTEMCTL_LOG="$tmp/systemctl.log"
  export RUNAS_LOG="$tmp/runas.log"
  : >"$SYSTEMCTL_LOG"
  : >"$RUNAS_LOG"

  mkdir -p "$tmp/bin"
  printf '%s\n' '#!/bin/sh' 'echo "$@" >> "$SYSTEMCTL_LOG"' >"$tmp/bin/systemctl"
  printf '%s\n' '#!/bin/sh' 'name="$1"; shift' \
    'echo "RUN-AS $name: $*" >> "$RUNAS_LOG"' 'exec "$@"' >"$tmp/bin/run-as"
  chmod +x "$tmp/bin/systemctl" "$tmp/bin/run-as"
  export SYSTEMCTL="$tmp/bin/systemctl"
  export RUN_AS="$tmp/bin/run-as"

  mkdir -p "$SRV/foo/releases" "$SRV/foo/config" "$SRV/foo/data"
  echo secret-value >"$SRV/foo/config/service.env"
  echo db-data >"$SRV/foo/data/notifier.sqlite3"

  FIX="$tmp/fixture"
}

mk_fixture() {
  # mk_fixture [smoke-exit-code]
  local code="${1:-0}"
  mkdir -p "$FIX/bin"
  printf '#!/bin/sh\nexit %s\n' "$code" >"$FIX/bin/foo"
  chmod +x "$FIX/bin/foo"
  echo '<html>index</html>' >"$FIX/index.html"
}

seed_revisions() {
  # seed_revisions <name> <count> — fake revisions 20260101-000000 ... oldest first
  local name="$1" count="$2" i
  for ((i = 1; i <= count; i++)); do
    mkdir -p "$SRV/$name/releases/2026010$i-000000"
  done
}

newest_revision() {
  ls -1 "$SRV/$1/releases" | sort | tail -1
}

revision_count() {
  ls -1 "$SRV/$1/releases" | wc -l
}


test_install_new_release() {
  t "test_install_new_release"
  setup_env
  mk_fixture
  "$HELPER" foo "$FIX" 3 >/dev/null 2>&1
  assert_eq 0 $? "helper exits 0"
  local rev
  rev=$(newest_revision foo)
  assert_eq "releases/$rev" "$(readlink "$SRV/foo/current")" "current points to the new revision"
  assert_exists "$SRV/foo/releases/$rev/bin/foo" "release binary copied"
  assert_exists "$SRV/foo/releases/$rev/index.html" "release payload copied"
  assert_eq secret-value "$(cat "$SRV/foo/config/service.env")" "config/ untouched"
  assert_eq db-data "$(cat "$SRV/foo/data/notifier.sqlite3")" "data/ untouched"
  assert_contains "$SYSTEMCTL_LOG" "daemon-reload" "daemon-reload called"
  assert_contains "$SYSTEMCTL_LOG" "restart foo" "service restarted"
  assert_contains "$LOG_FILE" "releases/$rev" "actions are logged"
}

test_smoke_runs_as_service_user() {
  t "test_smoke_runs_as_service_user"
  setup_env
  mk_fixture
  "$HELPER" foo "$FIX" 3 >/dev/null 2>&1
  assert_eq 0 $? "helper exits 0"
  local rev
  rev=$(newest_revision foo)
  assert_contains "$RUNAS_LOG" "$SRV/foo/releases/$rev/bin/foo --help" \
    "smoke runs bin/foo --help as the service user"
}

test_smoke_failure_aborts() {
  t "test_smoke_failure_aborts"
  setup_env
  seed_revisions foo 1
  ln -sfn releases/20260101-000000 "$SRV/foo/current"
  mk_fixture 1
  assert_nonzero_exit "$HELPER" foo "$FIX" 3
  assert_eq 1 "$(revision_count foo)" "failed revision was removed"
  assert_eq 20260101-000000 "$(newest_revision foo)" "only the pre-existing revision remains"
  assert_eq "releases/20260101-000000" "$(readlink "$SRV/foo/current")" "current untouched"
}

test_retention_never_deletes_current() {
  t "test_retention_never_deletes_current"
  setup_env
  seed_revisions foo 5
  ln -sfn releases/20260101-000000 "$SRV/foo/current"
  mk_fixture
  "$HELPER" foo "$FIX" 3 >/dev/null 2>&1
  assert_eq 0 $? "helper exits 0"
  assert_eq 3 "$(revision_count foo)" "keep=3 revisions remain"
  local cur_target
  cur_target=$(readlink "$SRV/foo/current")
  assert_exists "$SRV/foo/$cur_target" "current target survives retention"
  assert_exists "$SRV/foo/releases/$(newest_revision foo)" "newly installed revision survives"
}

test_switch_rollback() {
  t "test_switch_rollback"
  setup_env
  seed_revisions foo 5
  ln -sfn releases/20260101-000000 "$SRV/foo/current"
  "$HELPER" --switch foo 20260103-000000 >/dev/null 2>&1
  assert_eq 0 $? "helper exits 0"
  assert_eq "releases/20260103-000000" "$(readlink "$SRV/foo/current")" "current switched to the given revision"
  assert_contains "$SYSTEMCTL_LOG" "restart foo" "service restarted"
  assert_eq 5 "$(revision_count foo)" "retention did not run on switch"
}

test_atomic_flip() {
  t "test_atomic_flip"
  setup_env
  seed_revisions foo 1
  ln -sfn releases/20260101-000000 "$SRV/foo/current"
  mk_fixture
  "$HELPER" foo "$FIX" 3 >/dev/null 2>&1
  assert_eq 0 $? "helper exits 0"
  assert_exists "$SRV/foo/current" "current exists after install"
  [[ -L "$SRV/foo/current" ]]
  assert_eq 0 $? "current is a symlink"
  local rev
  rev=$(newest_revision foo)
  assert_eq "releases/$rev" "$(readlink "$SRV/foo/current")" "current resolves to the new revision"
  # The atomicity contract lives in the code: only mv -Tf, never ln -sfn.
  assert_contains "$HELPER" "mv -Tf" "flip uses mv -Tf"
  if grep -q 'ln -sfn' "$HELPER"; then
    fail "forbidden ln -sfn found in helper source"
  else
    pass "no ln -sfn in helper source"
  fi
}

test_name_validation() {
  t "test_name_validation"
  setup_env
  mk_fixture
  assert_nonzero_exit "$HELPER" "a/b" "$FIX" 3
  assert_nonzero_exit "$HELPER" ".." "$FIX" 3
  assert_nonzero_exit "$HELPER" foo "$FIX/does-not-exist" 3
}


test_install_new_release
test_smoke_runs_as_service_user
test_smoke_failure_aborts
test_retention_never_deletes_current
test_switch_rollback
test_atomic_flip
test_name_validation

printf '\n%d passed, %d failed\n' "$PASS" "$FAIL"
rm -rf "${ALL_TMP[@]}" 2>/dev/null || true
[[ $FAIL -eq 0 ]]
