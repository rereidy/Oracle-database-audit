--
--  File: account_analysis.sql
--
--  Author: Ron Reidy
--
--  Description:  Use this script to list all accounts and roles in the 
--                database instance along with other attributes.
--
-- This script comes with no warranty ...use at own risk 
-- Copyright (C) 2014  Ron Reidy
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
--  Note:  This script will list password hashes.  If that is not permitted in
--         your audit, comment out the lines that get the password hashes
--         as shown below.
--
SELECT d.name AS database_name, d.created AS database_created,
       TRUNC(NVL((SYSDATE - d.created),-1)) AS database_age,
       a.name AS account_name,
       DECODE(a.type#, 0, 'ROLE', 1, 'USER ACCOUNT', 2, 'SCHEMA SYNONYM') as account_type,
       b.account_status,
       a.ext_username,
       TRUNC(NVL((SYSDATE - a.ctime),-1)) AS account_age, 
       a.ctime,
       TRUNC(NVL((SYSDATE - a.ptime),-1)) AS password_age,
       a.ptime,
       a.exptime,
       a.ltime,
       b.authentication_type,
       /* passwords next 2 lines */
       a.password,
       a.spare4,
       b.password_versions,
       a.lcount
FROM   sys.user$ a, dba_users b, v$database d
WHERE  a.name = b.username(+)
ORDER BY a.user#;

