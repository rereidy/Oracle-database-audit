--
--  File: list_account_profile_password_settings.sql
--
--  Author: Ron Reidy
--
--  Description:  Use this script to list accounts and their password profile settings.
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
SELECT a.username, a.profile, b.resource_name, b.limit
FROM   dba_users a, dba_profiles b
WHERE  a.profile = b.profile
ORDER BY a.user_id;
