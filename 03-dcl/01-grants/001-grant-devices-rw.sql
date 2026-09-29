--liquibase formatted sql

--changeset diego:dcl-grant-001-devices-rw runInTransaction:false
--comment: Minimum permissions for the app role. No DELETE anywhere (history is permanent). The app cannot INSERT devices: they are registered at the factory (seed/script) with the migrator user
GRANT SELECT, INSERT, UPDATE ON SCHEMA::devices TO devices_rw;
DENY  INSERT, DELETE         ON OBJECT::devices.devices               TO devices_rw;
DENY  DELETE                 ON OBJECT::devices.device_link_history   TO devices_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::devices.DATABASECHANGELOG     TO devices_rw;
DENY  INSERT, UPDATE, DELETE ON OBJECT::devices.DATABASECHANGELOGLOCK TO devices_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::devices.DATABASECHANGELOGLOCK FROM devices_rw;
--rollback REVOKE INSERT, UPDATE, DELETE ON OBJECT::devices.DATABASECHANGELOG     FROM devices_rw;
--rollback REVOKE DELETE                 ON OBJECT::devices.device_link_history   FROM devices_rw;
--rollback REVOKE INSERT, DELETE         ON OBJECT::devices.devices               FROM devices_rw;
--rollback REVOKE SELECT, INSERT, UPDATE ON SCHEMA::devices FROM devices_rw;
