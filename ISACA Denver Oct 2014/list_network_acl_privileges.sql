--
--  File: list_network_acl_privileges.sql
--
--  Author: Ron Reidy
--
--  Description:  Use this script to list network ACL privileges
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
SET serveroutput ON size unlimited
SET lines 256 trimspool on feed off

DECLARE

    TYPE acl_t IS TABLE OF VARCHAR2(4000) INDEX BY PLS_INTEGER;
    network_acl_paths acl_t;

    TYPE username_t IS TABLE OF VARCHAR2(100) INDEX BY PLS_INTEGER;
    usernames username_t;

    granted_sql VARCHAR2(4000) :=
        q'{SELECT DBMS_NETWORK_ACL_ADMIN.check_privilege(:the_path, :the_user, 'connect') AS con FROM dual}';

    con                   INTEGER;
    granted_denied_access VARCHAR2(7);

BEGIN

    -- only sys ALCs
    SELECT any_path
    BULK COLLECT INTO network_acl_paths
    FROM   resource_view
    WHERE  any_path LIKE '/sys/acls/%.xml';

    SELECT username
    BULK COLLECT INTO usernames
    FROM   dba_users;

    DBMS_OUTPUT.put_line('ACL,USERNAME,GRANTED?');
    FOR acl_indx IN network_acl_paths.FIRST .. network_acl_paths.LAST
    LOOP
        FOR usr_indx IN usernames.FIRST .. usernames.LAST
        LOOP
            EXECUTE IMMEDIATE granted_sql INTO con USING network_acl_paths(acl_indx), usernames(usr_indx);
            IF con = 1 THEN
                granted_denied_access := 'TRUE';
            ELSIF con = 0 THEN
                granted_denied_access := 'FALSE';
            ELSE
                granted_denied_access := NULL;
            END IF;
            DBMS_OUTPUT.put_line(network_acl_paths(acl_indx) || ',' || usernames(usr_indx) || ',' || granted_denied_access);
        END LOOP;
    END LOOP;

EXCEPTION
    WHEN others THEN
        DBMS_OUTPUT.put_line(sqlerrm);
END;
/

