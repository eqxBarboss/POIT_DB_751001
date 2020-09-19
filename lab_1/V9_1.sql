--------------------------------------------- #define TASK1 ---------------------------------------------

USE [master];
GO

IF EXISTS(select * from [sys].[databases] where [name]='DANIIL_YASKEVICH')
DROP DATABASE [DANIIL_YASKEVICH];

CREATE DATABASE [DANIIL_YASKEVICH];
GO

USE [DANIIL_YASKEVICH];
GO

CREATE SCHEMA [sales];
GO

CREATE TABLE [sales].[Orders] ([OrderNum] INT NULL);

BACKUP DATABASE [DANIIL_YASKEVICH]
	TO DISK = 'C:\Users\eqxba\Desktop\ад\lab_1\DANIIL_YASKEVICH_DB.bak';
GO

USE master;
GO

DROP DATABASE [DANIIL_YASKEVICH];

RESTORE DATABASE [DANIIL_YASKEVICH]
	FROM DISK = 'C:\Users\eqxba\Desktop\ад\lab_1\DANIIL_YASKEVICH_DB.bak';

--------------------------------------------- #undef TASK1 ----------------------------------------------