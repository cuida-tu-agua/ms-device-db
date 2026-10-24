--liquibase formatted sql

--changeset esteban:v1.2-dml-patch-001-devices-threshold-1min
--comment: HU-013 hotfix: existing devices still on the old default (10 min) move to 1 minute
UPDATE devices.devices SET inactivity_threshold_min = 1, updated_at = SYSUTCDATETIME() WHERE inactivity_threshold_min = 10;
--rollback UPDATE devices.devices SET inactivity_threshold_min = 10 WHERE inactivity_threshold_min = 1;