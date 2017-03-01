--
--  File: licence_options.sql
--
--  Author: Ron Reidy
--
--  Description:  Use this script to list DB options used
--
-- This script comes with no warranty ...use at own risk 
-- Copied from the oracle-l list - http://www.freelists.org/post/oracle-l/Oracle-license-requirements-for-unused-options,34
-- 
-- This program is free software; you can redistribute it and/or modify 
-- it under the terms of the GNU General Public License as published by 
-- the Free Software Foundation; version 2 of the License. 
-- 
-- This program is distributed in the hope that it will be useful, 
-- but WITHOUT ANY WARRANTY; without even the implied warranty of 
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the 
-- GNU General Public License for more details. 
-- 
-- You should have received a copy of the GNU General Public License 
-- along with this program or from the site that you downloaded it 
-- from; if not, write to the Free Software Foundation, Inc., 59 Temple 
-- Place, Suite 330, Boston, MA  02111-1307   USA
--
WITH features AS (
    SELECT a OPTIONS, b NAME  
    FROM
    (
        SELECT 'Active Data Guard' a,  'Active Data Guard - Real-Time Query on Physical StANDby' b 
        FROM    dual
        UNION ALL 
        SELECT 'Advanced Compression', 'HeapCompression' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Compression', 'Backup BZIP2 Compression' 
        FROM    dual
        UNION ALL 
        SELECT 'Advanced Compression', 'Backup DEFAULT Compression' 
        FROM    dual
        UNION ALL 
        SELECT 'Advanced Compression', 'Backup HIGH Compression' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Compression', 'Backup LOW Compression' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Compression', 'Backup MEDIUM Compression' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Compression', 'Backup ZLIB, Compression' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Compression', 'SecureFile Compression (user)' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Compression', 'SecureFile Deduplication (user)' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Compression',        'Data Guard' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Compression', 'Oracle Utility Datapump (Export)' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Compression', 'Oracle Utility Datapump (Import)' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Security',     'ASO native encryption AND checksumming' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Security', 'Transparent Data Encryption' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Security', 'Encrypted Tablespaces' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Security', 'Backup Encryption' 
        FROM    dual
        UNION ALL
        SELECT 'Advanced Security', 'SecureFile Encryption (user)' 
        FROM    dual
        UNION ALL
        SELECT 'Change Management Pack',        'Change Management Pack (GC)' 
        FROM    dual
        UNION ALL
        SELECT 'Data Masking Pack',     'Data Masking Pack (GC)' 
        FROM    dual
        UNION ALL
        SELECT 'Data Mining',   'Data Mining' 
        FROM    dual
        UNION ALL
        SELECT 'Diagnostic Pack',       'Diagnostic Pack' 
        FROM    dual
        UNION ALL
        SELECT 'Diagnostic Pack',       'ADDM' 
        FROM    dual
        UNION ALL
        SELECT 'Diagnostic Pack',       'AWR Baseline' 
        FROM    dual
        UNION ALL
        SELECT 'Diagnostic Pack',       'AWR Baseline Template' 
        FROM    dual
        UNION ALL
        SELECT 'Diagnostic Pack',       'AWR Report' 
        FROM    dual
        UNION ALL
        SELECT 'Diagnostic Pack',       'Baseline Adaptive Thresholds' 
        FROM    dual
        UNION ALL
        SELECT 'Diagnostic Pack',       'Baseline Static Computations' 
        FROM    dual
        UNION ALL
        SELECT 'Tuning  Pack',          'Tuning Pack' 
        FROM    dual
        UNION ALL
        SELECT 'Tuning  Pack',          'Real-Time SQL Monitoring' 
        FROM    dual
        UNION ALL
        SELECT 'Tuning  Pack',          'SQL Tuning Advisor' 
        FROM    dual
        UNION ALL
        SELECT 'Tuning  Pack',          'SQL Access Advisor' 
        FROM    dual
        UNION ALL
        SELECT 'Tuning  Pack',          'SQL Profile' 
        FROM    dual
        UNION ALL
        SELECT 'Tuning  Pack',          'Automatic SQL Tuning Advisor' 
        FROM    dual
        UNION ALL
        SELECT 'Database Vault',        'Oracle Database Vault' 
        FROM    dual
        UNION ALL
        SELECT 'WebLogic Server Management Pack Enterprise Edition',    'EM AS Provisioning AND Patch Automation (GC)' 
        FROM    dual
        UNION ALL
        SELECT 'Configuration Management Pack for Oracle Database',     'EM Config Management Pack (GC)' 
        FROM    dual
        UNION ALL
        SELECT 'Provisioning AND Patch Automation Pack for Database',   'EM Database Provisioning AND Patch Automation (GC)' 
        FROM    dual
        UNION ALL
        SELECT 'Provisioning AND Patch Automation Pack',        'EM StANDalone Provisioning AND Patch Automation Pack (GC)' 
        FROM    dual
        UNION ALL
        SELECT 'Exadata',       'Exadata' 
        FROM    dual
        UNION ALL
        SELECT 'Label Security',        'Label Security' 
        FROM    dual
        UNION ALL
        SELECT 'OLAP',          'OLAP - Analytic Workspaces' 
        FROM    dual
        UNION ALL
        SELECT 'Partitioning',          'Partitioning (user)' 
        FROM    dual
        UNION ALL
        SELECT 'Real Application Clusters',     'Real Application Clusters (RAC)' 
        FROM    dual
        UNION ALL
        SELECT 'Real Application Testing',      'Database Replay: Workload Capture' 
        FROM    dual
        UNION ALL
        SELECT 'Real Application Testing',      'Database Replay: Workload Replay' 
        FROM    dual
        UNION ALL
        SELECT 'Real Application Testing',      'SQL Performance Analyzer' 
        FROM    dual
        UNION ALL
        SELECT 'Spatial'        ,'Spatial (Not used because this does not differential usage of spatial over locator, which is free)' 
        FROM    dual
        UNION ALL
        SELECT 'Total Recall',  'Flashback Data Archive' 
        FROM    dual
    )
)
SELECT t.o "Option/Management Pack", 
       t.u "Used",
       d.DBID "DBID",
       d.name "DB Name",
       i.version "DB Version",
       i.host_name "Host Name",
       TO_CHAR(sysdate, 'YYYY-MM-DD HH24:MI:SS') "ReportGen Time"
FROM   (SELECT OPTIONS o, DECODE(sum(num),0,'NO','YES') u
        FROM   (SELECT f.OPTIONS OPTIONS, 
                       CASE WHEN f_stat.name IS NULL THEN 0
                            WHEN ((
                                    f_stat.currently_used = 'TRUE' AND
                                    f_stat.detected_usages > 0 AND
                                    (sysdate - f_stat.last_usage_date) < 366 AND
                                    f_stat.total_samples > 0
                                  ) OR 
                                  (
                                   f_stat.detected_usages > 0 AND 
                                   (sysdate - f_stat.last_usage_date) < 366 AND
                                   f_stat.total_samples > 0
                                  )
                                 ) AND 
                                 (
                                  f_stat.name NOT IN ('Data Guard', 'Oracle Utility Datapump (Export)', 'Oracle Utility Datapump (Import)') OR
                                  (
                                   f_stat.name IN ('Data Guard', 'Oracle Utility Datapump (Export)', 'Oracle Utility Datapump (Import)') AND
                                   f_stat.feature_info IS NOT NULL AND TRIM(SUBSTR(TO_CHAR(feature_info), INSTR(TO_CHAR(feature_info), 'compression used: ',1,1) + 18, 2)) != '0'
                                  )
                                 ) THEN 1
                            ELSE 0
                       END num
                FROM  features f, sys.dba_feature_usage_statistics f_stat
                WHERE f.name = f_stat.name(+)
               )
        GROUP BY options
       ) t,
       v$instance i,
       v$database d
ORDER BY 2 desc,1;
