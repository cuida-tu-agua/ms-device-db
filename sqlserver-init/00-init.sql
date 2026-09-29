-- sqlserver-init/00-init.sql
-- Runs once as sa. The database comes from ms-iam-db and places.places from ms-places-db.
IF DB_ID('sy-water-db') IS NULL
    THROW 50001, 'Database sy-water-db does not exist. Run ms-iam-db first.', 1;
GO

USE [sy-water-db];
GO

IF OBJECT_ID(N'places.places', N'U') IS NULL
    THROW 50002, 'Table places.places does not exist. Run ms-places-db first.', 1;
GO

IF SCHEMA_ID('devices') IS NULL
    EXEC('CREATE SCHEMA devices');
GO

-- Runtime user for device-service
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name='devices_app')
    CREATE LOGIN devices_app WITH PASSWORD='$(DEVICES_APP_PASSWORD)';
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='devices_app')
BEGIN
    CREATE USER devices_app FOR LOGIN devices_app
        WITH DEFAULT_SCHEMA = devices;
END
GO

-- Migration user for Liquibase
IF NOT EXISTS (SELECT 1 FROM sys.server_principals WHERE name='devices_migrator')
    CREATE LOGIN devices_migrator WITH PASSWORD='$(DEVICES_MIGRATOR_PASSWORD)';
IF NOT EXISTS (SELECT 1 FROM sys.database_principals WHERE name='devices_migrator')
BEGIN
    CREATE USER devices_migrator FOR LOGIN devices_migrator
        WITH DEFAULT_SCHEMA = devices;
END
GO

GRANT CONTROL ON SCHEMA::devices TO devices_migrator;
GRANT CREATE TABLE TO devices_migrator;
GRANT CREATE ROLE TO devices_migrator;
GRANT ALTER ANY ROLE TO devices_migrator;
GO

-- Needed to create the cross-schema FKs (places.places and security.users)
GRANT REFERENCES ON OBJECT::places.places  TO devices_migrator;
GRANT REFERENCES ON OBJECT::security.users TO devices_migrator;
GO
