# Oracle RMAN Toolkit

Practical Oracle Recovery Manager (RMAN) examples for backup operations, backup reporting, recovery catalog registration, and archivelog maintenance.

## Scope

This repository is designed as a reference toolkit for Oracle DBAs. It intentionally contains no passwords, database-specific credentials, hostnames, or production identifiers.

## Requirements

- Oracle Database with RMAN available
- SQL*Plus or SQLcl for reporting queries
- Appropriate Oracle privileges for the operation being performed
- A tested backup destination and retention policy
- For tape examples, a correctly configured SBT media-management library

## Repository layout

| Path | Purpose |
| --- | --- |
| `config/rman_configuration.rman` | Example RMAN retention and control-file autobackup configuration |
| `backup/disk_backup.sh` | Full database, archivelog, control-file and SPFILE backup to disk |
| `backup/tape_backup.rman` | Generic SBT/tape backup example |
| `reporting/backup_jobs.sql` | Query RMAN backup-job history |
| `catalog/catalog_setup.rman` | Recovery catalog creation and database registration workflow |
| `maintenance/delete_archivelogs.sh` | Example archivelog maintenance workflow |

## Usage

Review every script before running it. Replace placeholders and environment variables with values appropriate for your environment.

For a disk backup, set the Oracle environment and backup directory, then run:

```bash
export ORACLE_HOME=/path/to/oracle/home
export ORACLE_SID=ORCL
export BACKUP_DIR=/path/to/backup
./backup/disk_backup.sh
```

For reporting:

```sql
SQL> @reporting/backup_jobs.sql
```

## Safety

RMAN backup and maintenance commands can change backup metadata or delete archived redo logs. Validate recovery requirements, Data Guard dependencies, retention policy, backup availability, and restore procedures before using destructive commands.

The examples in this repository are templates. Test them in a non-production environment before adapting them for production.

## Security

Credentials must not be stored in this repository. Use Oracle Wallet, operating-system authentication, protected environment configuration, or another approved secret-management mechanism.

`tools/check_repo.sh` performs basic hygiene checks for credential-like values, private IP addresses, and CRLF line endings.

## License

Released under the MIT License. Copyright (c) 2026 Mohamed Dawood.
