--------------------------------------------- #define TASK1 ---------------------------------------------

USE [AdventureWorks];
GO

--------------------------------------------- #define SUBTASK1 ------------------------------------------
ALTER TABLE [dbo].[StateProvince]
	ADD [AddressType] NVARCHAR(50) null;
--------------------------------------------- #undef SUBTASK1 -------------------------------------------
	
--------------------------------------------- #define SUBTASK2 ------------------------------------------
SELECT * INTO [#tempStateProvince]
FROM [dbo].[StateProvince];

UPDATE [#tempStateProvince]
SET [#tempStateProvince].[AddressType] = [at].[Name]
FROM [#tempStateProvince] [tsp]
INNER JOIN [Person].[Address] [a]
	ON ([a].[StateProvinceID] = [tsp].[StateProvinceID])
INNER JOIN [Person].[BusinessEntityAddress] [bea]
	ON ([a].[AddressID] = [bea].[AddressID])
INNER JOIN [Person].[AddressType] [at]
	ON ([bea].[AddressTypeID] = [at].[AddressTypeID]);
--------------------------------------------- #undef SUBTASK2 -------------------------------------------

--------------------------------------------- #define SUBTASK3 ------------------------------------------
UPDATE [dbo].[StateProvince]
SET
	  [dbo].[StateProvince].[AddressType] = [tsp].[AddressType]
	, [dbo].[StateProvince].[Name] = [cr].[Name] + ' ' + [dbo].[StateProvince].[Name]
FROM [#tempStateProvince] [tsp]
INNER JOIN [Person].[CountryRegion] [cr]
	ON ([cr].[CountryRegionCode] = [tsp].[CountryRegionCode])
WHERE ([dbo].[StateProvince].[StateProvinceID] = [tsp].[StateProvinceID]);
--------------------------------------------- #undef SUBTASK3 -------------------------------------------

--------------------------------------------- #define SUBTASK4 ------------------------------------------
DELETE FROM [dbo].[StateProvince]
FROM [dbo].[StateProvince] [sp]
INNER JOIN (
	SELECT 
		  [AddressType]
		, MAX([StateProvinceID]) [MaxStateProvinceID] 
	FROM [dbo].[StateProvince]
	GROUP BY [AddressType]
) [maxSPIDbyAT]
	ON ([maxSPIDbyAT].[AddressType] = [sp].[AddressType])
WHERE [sp].[StateProvinceID] <> [maxSPIDbyAT].[MaxStateProvinceID];
--------------------------------------------- #undef SUBTASK4 -------------------------------------------

--------------------------------------------- #define SUBTASK5 ------------------------------------------
ALTER TABLE [dbo].[StateProvince]
	DROP COLUMN [AddressType]

SELECT *
FROM [INFORMATION_SCHEMA].[TABLE_CONSTRAINTS]
WHERE [TABLE_SCHEMA] = 'dbo' and [TABLE_NAME] = 'StateProvince';

SELECT *
FROM [INFORMATION_SCHEMA].[CONSTRAINT_COLUMN_USAGE]
WHERE [TABLE_SCHEMA] = 'dbo' and [TABLE_NAME] = 'StateProvince';

SELECT *
FROM [INFORMATION_SCHEMA].[CONSTRAINT_TABLE_USAGE]
WHERE TABLE_SCHEMA = 'dbo' and TABLE_NAME = 'StateProvince';

SELECT
	[DEFAULT_CONSTRAINTS].[NAME]
FROM [SYS].[ALL_COLUMNS]
INNER JOIN [SYS].[TABLES]
	ON [ALL_COLUMNS].[OBJECT_ID] = [TABLES].[OBJECT_ID]
INNER JOIN  [SYS].[SCHEMAS]
	ON [TABLES].[SCHEMA_ID] = [SCHEMAS].[SCHEMA_ID]
INNER JOIN  [SYS].[DEFAULT_CONSTRAINTS]
	ON [ALL_COLUMNS].[DEFAULT_OBJECT_ID] = [DEFAULT_CONSTRAINTS].[OBJECT_ID]
WHERE [SCHEMAS].[NAME] = 'dbo' and [TABLES].[NAME] = 'StateProvince'

ALTER TABLE [dbo].[StateProvince]
  DROP CONSTRAINT [PK_StateProvinceID_StateProvinceCode], [TerritoryID_Domain_Check], [TerritoryID_Default_Value]
--------------------------------------------- #undef SUBTASK5 -------------------------------------------

--------------------------------------------- #define SUBTASK6 ------------------------------------------
DROP TABLE [dbo].[StateProvince]
--------------------------------------------- #undef SUBTASK6 -------------------------------------------

--------------------------------------------- #undef TASK1 ----------------------------------------------