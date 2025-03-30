 /*
=====================================================
Create Database and Schemas
=====================================================
Script Purpose:
  This script creates a new database named 'DataWarehouse' after checking if it already
  exists. If the database exists, it is dropped and recreated. Additionally, the script 
  sets up three tables within the database: 'bronze', 'silver', 'gold'.
WARNING:
  Running this script will drop the entire 'DataWarehouse' database if it exists.
  All data in the database will be permanently deleted. proceed with caution and
  ensure you have proper backups before running this script.
*/

USE MASTER;

GO

-- Drop and recreate the 'DataWarehouse' database
IF EXISTS (SELECT 1 FROM sys.databases WHERE NAME = 'DataWarehouse')
	BEGIN 
		ALTER DATABASE DataWarehouse SET SINGLE_USER WITH ROLLBACK IMMEDIATE; 
		DROP DATABASE DataWarehouse; 
	END;

GO

-- Create the 'DataWarehouse' database
CREATE DATABASE DataWarehouse;

GO

USE DataWarehouse;

GO

-- Create Schemas
CREATE SCHEMA bronze;

GO
CREATE SCHEMA silver;

GO
CREATE SCHEMA gold;

