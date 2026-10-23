--liquibase formatted sql

--changeset esteban:v1.2-ddl-alter-001-devices-threshold-default
--comment: HU-013 hotfix: a device is "disconnected" after 1 minute without reports (readings every 10 s, heartbeat every 30 s). New devices get 1 by default
ALTER TABLE devices.devices DROP CONSTRAINT DF_devices_threshold;
ALTER TABLE devices.devices ADD CONSTRAINT DF_devices_threshold DEFAULT (1) FOR inactivity_threshold_min;
--rollback ALTER TABLE devices.devices DROP CONSTRAINT DF_devices_threshold;
--rollback ALTER TABLE devices.devices ADD CONSTRAINT DF_devices_threshold DEFAULT (10) FOR inactivity_threshold_min;