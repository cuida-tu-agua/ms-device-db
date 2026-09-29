--liquibase formatted sql

--changeset diego:ddl-fk-003-linkh-device
--comment: FK device_link_history.device_id -> devices.id (same schema)
ALTER TABLE devices.device_link_history
    ADD CONSTRAINT FK_linkh_device
    FOREIGN KEY (device_id) REFERENCES devices.devices (id);
--rollback ALTER TABLE devices.device_link_history DROP CONSTRAINT FK_linkh_device;
