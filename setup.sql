CREATE DATABASE TestDB;
GO
USE TestDB;
GO

CREATE TABLE Inventory (id INT, name NVARCHAR(50), quantity INT);
GO
CREATE TABLE Books(Id INT PRIMARY KEY IDENTITY(1,1), Name VARCHAR (50) NOT NULL, Price INT);
GO
CREATE TABLE Persons (
    PID int NOT NULL,
    LastName varchar(255) NOT NULL,
    FirstName varchar(255),
    Age int,
    City varchar(255) DEFAULT 'London'
);
GO
CREATE TABLE Class (
    CID int NOT NULL,
    Name varchar(255),
    Year int DEFAULT 1,
);
GO
CREATE SCHEMA Migrated;
GO