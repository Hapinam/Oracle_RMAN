#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# File      : maintenance/delete_archivelogs.sh
# Purpose   : Crosscheck archived logs and delete logs older than a configured
#             number of days after RMAN metadata cleanup.
# Usage     : Set ORACLE_HOME, ORACLE_SID and ARCHIVELOG_DAYS, then run.
# Requires  : RMAN target authentication.
#
# WARNING   : This script deletes archived redo logs. Confirm recovery,
#             backup and Data Guard requirements before use.
# Copyright (c) 2026 Mohamed Dawood. MIT License; see LICENSE.
# -----------------------------------------------------------------------------
set -euo pipefail

: "${ORACLE_HOME:?Set ORACLE_HOME}"
: "${ORACLE_SID:?Set ORACLE_SID}"
: "${ARCHIVELOG_DAYS:=5}"

export PATH="$ORACLE_HOME/bin:$PATH"

case "$ARCHIVELOG_DAYS" in
  ''|*[!0-9]*) echo "ARCHIVELOG_DAYS must be a non-negative integer" >&2; exit 2 ;;
esac

rman target / <<RMAN
RUN {
  CROSSCHECK ARCHIVELOG ALL;
  DELETE NOPROMPT EXPIRED ARCHIVELOG ALL;
  DELETE NOPROMPT ARCHIVELOG ALL COMPLETED BEFORE 'SYSDATE-${ARCHIVELOG_DAYS}';
}
RMAN
