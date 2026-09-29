--liquibase formatted sql

--changeset diego:ddl-ix-001-devices
--comment: HU-012 at most ONE device per place (filtered unique); HU-013 the status sweeper looks for CONNECTED devices with an old last_report_at
CREATE UNIQUE INDEX UX_devices_place         ON devices.devices (place_id) WHERE place_id IS NOT NULL;
CREATE INDEX        IX_devices_status_report ON devices.devices (status, last_report_at);
--rollback DROP INDEX IX_devices_status_report ON devices.devices;
--rollback DROP INDEX UX_devices_place         ON devices.devices;
