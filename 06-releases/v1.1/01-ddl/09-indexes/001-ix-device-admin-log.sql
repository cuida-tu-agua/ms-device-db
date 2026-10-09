--liquibase formatted sql

--changeset diego:v1.1-ddl-index-001-ix-device-admin-log
--comment: The detail of a device shows its admin history, newest first
CREATE INDEX IX_dadmin_device_time ON devices.device_admin_log (device_id, occurred_at DESC);
--rollback DROP INDEX IX_dadmin_device_time ON devices.device_admin_log;
