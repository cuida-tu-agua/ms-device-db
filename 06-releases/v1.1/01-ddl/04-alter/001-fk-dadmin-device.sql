--liquibase formatted sql

--changeset diego:v1.1-ddl-fk-001-fk-dadmin-device
--comment: device_admin_log.device_id -> devices.devices
ALTER TABLE devices.device_admin_log
    ADD CONSTRAINT FK_dadmin_device
    FOREIGN KEY (device_id) REFERENCES devices.devices (id);
--rollback ALTER TABLE devices.device_admin_log DROP CONSTRAINT FK_dadmin_device;

--changeset diego:v1.1-ddl-fk-002-fk-dadmin-user
--comment: device_admin_log.admin_user_id -> security.users (cross-schema, ADR-002)
ALTER TABLE devices.device_admin_log
    ADD CONSTRAINT FK_dadmin_user
    FOREIGN KEY (admin_user_id) REFERENCES security.users (id);
--rollback ALTER TABLE devices.device_admin_log DROP CONSTRAINT FK_dadmin_user;
