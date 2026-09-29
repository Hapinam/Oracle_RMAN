#!/usr/bin/env bash
# -----------------------------------------------------------------------------
# File      : backup/disk_backup.sh
# Purpose   : Example full RMAN backup to disk with archivelogs and metadata.
# Usage     : Set ORACLE_HOME, ORACLE_SID and BACKUP_DIR, then run this script.
# Requires  : RMAN target authentication and a writable backup destination.
#
# NOTE      : This backup script does not delete archived redo logs. Retention
#             cleanup is kept separate under maintenance/ for safer operation.
# Copyright (c) 2026 Mohamed Dawood. MIT License; see LICENSE.
# -----------------------------------------------------------------------------
set -euo pipefail

: "${ORACLE_HOME:?Set ORACLE_HOME}"
: "${ORACLE_SID:?Set ORACLE_SID}"
: "${BACKUP_DIR:?Set BACKUP_DIR}"

export PATH="$ORACLE_HOME/bin:$PATH"

rman target / <<RMAN
RUN {
  CROSSCHECK BACKUP;
  CROSSCHECK ARCHIVELOG ALL;

  ALLOCATE CHANNEL c1 TYPE DISK;
  ALLOCATE CHANNEL c2 TYPE DISK;

  BACKUP AS COMPRESSED BACKUPSET DATABASE
    FORMAT '$BACKUP_DIR/database_%d_%T_%U.bkp';

  SQL 'ALTER SYSTEM ARCHIVE LOG CURRENT';

  BACKUP AS COMPRESSED BACKUPSET ARCHIVELOG ALL
    FORMAT '$BACKUP_DIR/archivelog_%d_%T_%U.bkp';

  BACKUP CURRENT CONTROLFILE
    FORMAT '$BACKUP_DIR/controlfile_%d_%T_%U.bkp';

  BACKUP SPFILE
    FORMAT '$BACKUP_DIR/spfile_%d_%T_%U.bkp';

  RELEASE CHANNEL c1;
  RELEASE CHANNEL c2;
}

LIST BACKUP SUMMARY;
RMAN
