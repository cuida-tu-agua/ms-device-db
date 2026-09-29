--liquibase formatted sql

--changeset diego:ddl-fk-002-devices-linked-by
--comment: Cross-schema FK devices.linked_by -> security.users.id (who owns the current link)
--preconditions onFail:HALT onError:HALT
--precondition-sql-check expectedResult:1 SELECT CASE WHEN OBJECT_ID(N'security.users', N'U') IS NULL THEN 0 ELSE 1 END
ALTER TABLE devices.devices
    ADD CONSTRAINT FK_devices_linked_by
    FOREIGN KEY (linked_by) REFERENCES security.users (id);
--rollback ALTER TABLE devices.devices DROP CONSTRAINT FK_devices_linked_by;
