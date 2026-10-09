--liquibase formatted sql

--changeset diego:v1.1-ddl-table-001-device-admin-log
--comment: Admin panel (factory registration, new credentials, decommission). Who did what to a device and when. Append-only: the app role cannot update or delete rows. The admin name is a snapshot, so the history still reads well if the account is renamed
CREATE TABLE devices.device_admin_log (
    id            UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_dadmin_id         DEFAULT (NEWID()),
    device_id     UNIQUEIDENTIFIER NOT NULL,
    action        NVARCHAR(30)     NOT NULL,
    admin_user_id UNIQUEIDENTIFIER NOT NULL,
    admin_name    NVARCHAR(150)    NULL,
    occurred_at   DATETIME2        NOT NULL CONSTRAINT DF_dadmin_occurred_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_device_admin_log PRIMARY KEY (id),
    CONSTRAINT CK_dadmin_action    CHECK (action IN (N'REGISTERED', N'CREDENTIALS_REGENERATED', N'DECOMMISSIONED'))
);
--rollback DROP TABLE devices.device_admin_log;
