--liquibase formatted sql

--changeset diego:ddl-fk-001-devices-place
--comment: Cross-schema FK devices.place_id -> places.places.id (ADR-002 rule 3). No cascade: places are soft-deleted
--preconditions onFail:HALT onError:HALT
--precondition-sql-check expectedResult:1 SELECT CASE WHEN OBJECT_ID(N'places.places', N'U') IS NULL THEN 0 ELSE 1 END
ALTER TABLE devices.devices
    ADD CONSTRAINT FK_devices_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE devices.devices DROP CONSTRAINT FK_devices_place;
