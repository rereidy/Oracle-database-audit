--
--  File: last_changed_objs.sql
--
--  Author: Ron Reidy
--
--  Description:  Use this script to list database objects which have changed.
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
SET serveroutput on size unlimited
SET lines 256 trimspool on feed off autoprint off verify off

ACCEPT days_back NUMBER PROMPT 'Enter number of days back from now to test object age [30]: ' DEFAULT 30

DECLARE
    CURSOR obj_list_c
    IS
        SELECT owner, object_name, object_type, created, last_ddl_time,
               TRUNC(sysdate - &days_back) AS system_date,
               TO_DATE(SUBSTR(TIMESTAMP, 1, 10), 'YYYY-MM-DD') AS change_date
        FROM   dba_objects
        WHERE  (
                object_type IN (
                                'PROCEDURE',
                                'TRIGGER',
                                'OPERATOR',
                                'VIEW',
                                'MATERIALIZED VIEW',
                                'SYNONYM',
                                'OUTLN'
                                ) OR
                object_type LIKE 'PACKAGE%' OR
                object_type LIKE 'JAVA%' OR
                object_type LIKE 'TYPE%'
               )
        ORDER BY owner, object_name, object_type;   

    obj_list_rec obj_list_c%ROWTYPE;

BEGIN

    DBMS_OUTPUT.put_line('OWNER,OBJECT_NAME,OBJECT_TYPE,CREATED,LAST_DDL_TIME,SYSTEM_DATE,CHANGE_DATE');
    OPEN obj_list_c;
    LOOP
        FETCH obj_list_c INTO obj_list_rec;
        EXIT WHEN obj_list_c%NOTFOUND;

        IF obj_list_rec.change_date >= obj_list_rec.system_date OR
           obj_list_rec.created >= obj_list_rec.system_date
        THEN
            DBMS_OUTPUT.put_line(
                obj_list_rec.owner || ',' ||
                obj_list_rec.object_name || ',' || 
                obj_list_rec.object_type || ',' || 
                obj_list_rec.created || ',' || 
                obj_list_rec.last_ddl_time || ',' || 
                obj_list_rec.system_date || ',' || 
                obj_list_rec.change_date
            );
        END IF;

    END LOOP;

EXCEPTION
    WHEN others THEN
        DBMS_OUTPUT.put_line(sqlerrm);
        RAISE;
END;
/

UNDEFINE days_back

