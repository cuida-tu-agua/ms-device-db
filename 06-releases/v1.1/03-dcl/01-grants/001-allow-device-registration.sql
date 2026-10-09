--liquibase formatted sql

--changeset diego:v1.1-dcl-grant-001-allow-device-registration runInTransaction:false
--comment: The administrator registers devices from the panel (factory registration), so the app role may INSERT into devices.devices (v1.0 denied it: devices were only registered with the migrator user). The endpoint is ADMIN-only. The admin log is append-only: no UPDATE / DELETE
REVOKE INSERT ON OBJECT::devices.devices FROM devices_rw;
DENY UPDATE, DELETE ON OBJECT::devices.device_admin_log TO devices_rw;
--rollback REVOKE UPDATE, DELETE ON OBJECT::devices.device_admin_log FROM devices_rw;
--rollback DENY INSERT ON OBJECT::devices.devices TO devices_rw;
