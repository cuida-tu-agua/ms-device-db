--liquibase formatted sql

--changeset diego:ddl-ix-002-device-link-history
--comment: History of a device ordered by date; at most one OPEN link per device (unlinked_at IS NULL)
CREATE INDEX        IX_linkh_device_time   ON devices.device_link_history (device_id, linked_at DESC);
CREATE INDEX        IX_linkh_place         ON devices.device_link_history (place_id);
CREATE UNIQUE INDEX UX_linkh_device_active ON devices.device_link_history (device_id) WHERE unlinked_at IS NULL;
--rollback DROP INDEX UX_linkh_device_active ON devices.device_link_history;
--rollback DROP INDEX IX_linkh_place         ON devices.device_link_history;
--rollback DROP INDEX IX_linkh_device_time   ON devices.device_link_history;
