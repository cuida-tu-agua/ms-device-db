--liquibase formatted sql

--changeset diego:ddl-fk-005-linkh-users
--comment: Cross-schema FKs device_link_history.linked_by / unlinked_by -> security.users.id
--preconditions onFail:HALT onError:HALT
--precondition-sql-check expectedResult:1 SELECT CASE WHEN OBJECT_ID(N'security.users', N'U') IS NULL THEN 0 ELSE 1 END
ALTER TABLE devices.device_link_history
    ADD CONSTRAINT FK_linkh_linked_by
    FOREIGN KEY (linked_by) REFERENCES security.users (id);
ALTER TABLE devices.device_link_history
    ADD CONSTRAINT FK_linkh_unlinked_by
    FOREIGN KEY (unlinked_by) REFERENCES security.users (id);
--rollback ALTER TABLE devices.device_link_history DROP CONSTRAINT FK_linkh_unlinked_by;
--rollback ALTER TABLE devices.device_link_history DROP CONSTRAINT FK_linkh_linked_by;
