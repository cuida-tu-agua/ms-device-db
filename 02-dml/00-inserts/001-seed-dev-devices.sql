--liquibase formatted sql

--changeset diego:dml-001-seed-dev-devices context:dev
--comment: FIVE fake factory devices for local development ONLY (context dev). The plain token/code are here on purpose so the team can test; real devices are registered with scripts/new-device.ps1 and their secrets never enter git
INSERT INTO devices.devices (serial_number, auth_token_hash, pairing_code_hash)
SELECT v.serial,
       LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', v.token), 2)),
       LOWER(CONVERT(VARCHAR(64), HASHBYTES('SHA2_256', CONCAT(CAST(v.serial AS VARCHAR(32)), ':', v.pairing_code)), 2))
FROM (VALUES
    (N'SW-ESP32-000001', '1gQn7MIHy0iGmO2hDpGM1n_uAdZRQUtJ', '4HZXVCDP'),
    (N'SW-ESP32-000002', 'MN11ZeszG1G5EAG8RXrl3_Ujcfgq8TFJ', 'QANZXC4D'),
    (N'SW-ESP32-000003', 'faq4edp2IFRljWT0fX4VZDSJSMzKEd0Y', 'PTY95U79'),
    (N'SW-ESP32-000004', 'XM7Kx-ZYUaA8pMlKwd4PX4YT5fZDjx9z', 'ARMTKT4A'),
    (N'SW-ESP32-000005', 'gincE3nzQXizrWORoCwBz8e9tH7IYuU3', 'X5BU7YJT')
) AS v (serial, token, pairing_code);
--rollback DELETE FROM devices.devices WHERE serial_number IN (N'SW-ESP32-000001', N'SW-ESP32-000002', N'SW-ESP32-000003', N'SW-ESP32-000004', N'SW-ESP32-000005');
