#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# File      : tools/check_repo.sh
# Purpose   : Basic repository security and hygiene checks.
# Usage     : ./tools/check_repo.sh
# Copyright (c) 2026 Mohamed Dawood. MIT License; see LICENSE.
# -----------------------------------------------------------------------------
set -uo pipefail
cd "$(dirname "$0")/.."

status=0
fail() { echo "FAIL: $1"; status=1; }

while IFS= read -r f; do
  grep -qlU $'\r' "$f" && fail "CRLF line endings: $f"
done < <(git ls-files)

patterns=(
  'IDENTIFIED[[:space:]]+BY[[:space:]]+[^<[:space:];]+'
  '(CONNECT|CATALOG|TARGET)[[:space:]]+[^[:space:]/]+/[^[:space:]@]+@'
  'USERID[[:space:]]*=[[:space:]]*[^[:space:]/]+/[^[:space:]@]+@'
  'conn(ect)?[[:space:]]+[^[:space:]/]+/[^[:space:]@]+@'
)

for p in "${patterns[@]}"; do
  if git grep -nEI "$p" -- . ':!tools/check_repo.sh' >/dev/null; then
    git grep -nEI "$p" -- . ':!tools/check_repo.sh'
    fail "possible embedded credential"
  fi
done

if git grep -nEI '(^|[^0-9.])(10\.[0-9]{1,3}|192\.168|172\.(1[6-9]|2[0-9]|3[01]))\.[0-9]{1,3}\.[0-9]{1,3}([^0-9.]|$)' -- . ':!tools/check_repo.sh' >/dev/null; then
  fail "private IP address committed"
fi

[ "$status" -eq 0 ] && echo "All checks passed."
exit "$status"
