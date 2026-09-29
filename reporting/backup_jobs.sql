------------------------------------------------------------------------------
-- Script    : reporting/backup_jobs.sql
-- Purpose   : Report recent RMAN backup jobs, duration, status and output size.
-- Usage     : SQL> @reporting/backup_jobs.sql
-- Requires  : SELECT privilege on V$RMAN_BACKUP_JOB_DETAILS.
--
-- Copyright (c) 2026 Mohamed Dawood. MIT License; see LICENSE.
------------------------------------------------------------------------------

SET LINESIZE 180
SET PAGESIZE 100

COLUMN input_type FORMAT A20
COLUMN status FORMAT A12
COLUMN start_time FORMAT A17
COLUMN end_time FORMAT A17
COLUMN hours FORMAT 99990.99
COLUMN output_size FORMAT A12

SELECT session_key,
       input_type,
       status,
       TO_CHAR(start_time, 'YYYY-MM-DD HH24:MI') AS start_time,
       TO_CHAR(end_time, 'YYYY-MM-DD HH24:MI') AS end_time,
       ROUND(elapsed_seconds / 3600, 2) AS hours,
       output_bytes_display AS output_size
FROM   v$rman_backup_job_details
ORDER  BY session_key DESC;
