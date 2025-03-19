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

-- Drop and Recreate 'DataWarehouse' Database
DROP DATABASE IF EXISTS DataWarehouse;

-- Create Database 'DataWarehouse' Database
CREATE DATABASE DataWarehouse;

USE DataWarehouse;  

-- Create Tables 
CREATE TABLE bronze(
data LONGTEXT
);

CREATE TABLE silver(
data LONGTEXT
);
 
CREATE TABLE gold(
data LONGTEXT
