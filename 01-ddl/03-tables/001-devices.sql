--liquibase formatted sql

--changeset diego:ddl-table-001-devices
--comment: BC-03 Device aggregate root (HU-012/013/014). One row per ESP32 registered at the factory. place_id/linked_by/linked_at describe the CURRENT link (all NULL = not linked)
CREATE TABLE devices.devices (
    id                       UNIQUEIDENTIFIER NOT NULL CONSTRAINT DF_devices_id         DEFAULT (NEWID()),
    serial_number            NVARCHAR(32)     NOT NULL,
    -- Factory secrets. Only SHA-256 hashes (64 hex chars) are stored, never the plain values
    auth_token_hash          VARCHAR(64)      NOT NULL,
    auth_token_last_used_at  DATETIME2        NULL,
    auth_token_revoked_at    DATETIME2        NULL,
    pairing_code_hash        VARCHAR(64)      NOT NULL,
    pairing_failed_attempts  INT              NOT NULL CONSTRAINT DF_devices_pairing_fails DEFAULT (0),
    pairing_locked_until     DATETIME2        NULL,
    -- Current link
    place_id                 UNIQUEIDENTIFIER NULL,
    linked_by                UNIQUEIDENTIFIER NULL,
    linked_at                DATETIME2        NULL,
    -- Connection status (HU-013)
    status                   NVARCHAR(15)     NOT NULL CONSTRAINT DF_devices_status     DEFAULT (N'NEVER_REPORTED'),
    last_report_at           DATETIME2        NULL,
    firmware_version         NVARCHAR(20)     NULL,
    inactivity_threshold_min INT              NOT NULL CONSTRAINT DF_devices_threshold  DEFAULT (10),
    created_at               DATETIME2        NOT NULL CONSTRAINT DF_devices_created_at DEFAULT (SYSUTCDATETIME()),
    updated_at               DATETIME2        NOT NULL CONSTRAINT DF_devices_updated_at DEFAULT (SYSUTCDATETIME()),
    CONSTRAINT PK_devices            PRIMARY KEY (id),
    CONSTRAINT UQ_devices_serial     UNIQUE (serial_number),
    CONSTRAINT CK_devices_status     CHECK (status IN (N'CONNECTED', N'DISCONNECTED', N'NEVER_REPORTED')),
    CONSTRAINT CK_devices_threshold  CHECK (inactivity_threshold_min BETWEEN 1 AND 1440),
    CONSTRAINT CK_devices_fails      CHECK (pairing_failed_attempts >= 0),
    -- The three link columns are either all set or all NULL
    CONSTRAINT CK_devices_link       CHECK (
        (place_id IS NULL     AND linked_by IS NULL     AND linked_at IS NULL) OR
        (place_id IS NOT NULL AND linked_by IS NOT NULL AND linked_at IS NOT NULL)),
    -- A device that never reported cannot have a last report date
    CONSTRAINT CK_devices_report     CHECK (status <> N'NEVER_REPORTED' OR last_report_at IS NULL)
);
--rollback DROP TABLE devices.devices;
