--liquibase formatted sql

--changeset diego:dml-001-seed-dev-devices context:dev
--comment: One factory devices for local development ONLY (context dev). The plain token/code are here on purpose so the team can test; real devices are registered with scripts/new-device.ps1 and their secrets never enter git
INSERT INTO devices.devices (serial_number, auth_token_hash, pairing_code_hash)
SELECT v.serial,
       LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', v.token), 2)),
       LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', CONCAT(CAST(v.serial AS VARCHAR(32)), ':', v.pairing_code)), 2))
FROM (VALUES
    (N'SW-ESP32-000001', '1gQn7MIHy0iGmO2hDpGM1n_uAdZRQUtJ', '4HZXVCDP')
) AS v (serial, token, pairing_code);
--rollback DELETE FROM devices.devices WHERE serial_number IN (N'SW-ESP32-000001', N'SW-ESP32-000002', N'SW-ESP32-000003', N'SW-ESP32-000004', N'SW-ESP32-000005');
