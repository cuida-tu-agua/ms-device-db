--liquibase formatted sql

--changeset diego:ddl-fk-004-linkh-place
--comment: Cross-schema FK device_link_history.place_id -> places.places.id
--preconditions onFail:HALT onError:HALT
--precondition-sql-check expectedResult:1 SELECT CASE WHEN OBJECT_ID(N'places.places', N'U') IS NULL THEN 0 ELSE 1 END
ALTER TABLE devices.device_link_history
    ADD CONSTRAINT FK_linkh_place
    FOREIGN KEY (place_id) REFERENCES places.places (id);
--rollback ALTER TABLE devices.device_link_history DROP CONSTRAINT FK_linkh_place;
