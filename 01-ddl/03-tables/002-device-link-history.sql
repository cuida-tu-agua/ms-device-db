--liquibase formatted sql

--changeset diego:ddl-table-002-device-link-history
--comment: Audit of every link/unlink (HU-012/014). Rows are never deleted: consumption-service (E4) uses them to know which place a reading belonged to
CREATE TABLE devices.device_link_history (
    id          UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_linkh_id         DEFAULT (NEWID()),
    device_id   UNIQUEIDENTIFIER NOT NULL,
    place_id    UNIQUEIDENTIFIER NOT NULL,
    linked_by   UNIQUEIDENTIFIER NOT NULL,
    linked_at   DATETIME2        NOT NULL,
    unlinked_at DATETIME2        NULL,
    unlinked_by UNIQUEIDENTIFIER NULL,
    created_at  DATETIME2        NOT NULL CONSTRAINT DF_linkh_created_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_device_link_history PRIMARY KEY (id),
    CONSTRAINT CK_linkh_unlink        CHECK (
        (unlinked_at IS NULL AND unlinked_by IS NULL) OR
        (unlinked_at IS NOT NULL AND unlinked_by IS NOT NULL AND unlinked_at >= linked_at))
);
--rollback DROP TABLE devices.device_link_history;
