--liquibase formatted sql

--changeset diego:dcl-role-001-devices-rw runInTransaction:false
--comment: DB role for app read/write + devices_app membership
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='devices_rw' AND type='R')
    CREATE ROLE devices_rw;
ALTER ROLE devices_rw ADD MEMBER devices_app;
--rollback ALTER ROLE devices_rw DROP MEMBER devices_app;
--rollback DROP ROLE devices_rw;
