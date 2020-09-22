--------------------------------------------- #define TASK2 ---------------------------------------------

USE [AdventureWorks];
GO

--------------------------------------------- #define SUBTASK_A -----------------------------------------
CREATE TABLE [dbo].[StateProvince] (
	  [StateProvinceID]			INT			NOT NULL
	, [StateProvinceCode]		NCHAR(3)	NOT NULL
	, [CountryRegionCode]		NVARCHAR(3) NOT NULL
	, [IsOnlyStateProvinceFlag] FLAG		NOT NULL
	, [Name]					NAME		NOT NULL
	, TerritoryID				INT			NOT NULL
	, ModifiedDate				DATETIME	NOT NULL);	
--------------------------------------------- #undef SUBTASK_A ------------------------------------------

--------------------------------------------- #define SUBTASK_B -----------------------------------------
ALTER TABLE [dbo].[StateProvince]
	ADD CONSTRAINT [PK_StateProvinceID_StateProvinceCode] 
		PRIMARY KEY CLUSTERED (StateProvinceID, StateProvinceCode);
--------------------------------------------- #undef SUBTASK_B ------------------------------------------

--------------------------------------------- #define SUBTASK_C -----------------------------------------
GO
CREATE FUNCTION [dbo].[IsMadeOfEvenDigits](@value INT)  
RETURNS BIT  
AS   
BEGIN  
	DECLARE @lastDigit INT;  
	WHILE (@value <> 0)
	BEGIN
		SET @lastDigit = @value % 10;
		IF ((@lastDigit % 2) <> 0)
			RETURN 0;
		SET @value = (@value - @lastDigit) / 10;
	END;
	RETURN 1
END;  
GO  

ALTER TABLE [dbo].[StateProvince]
	ADD CONSTRAINT [TerritoryID_Domain_Check]
		CHECK ([dbo].[IsMadeOfEvenDigits]([TerritoryID]) = 1);
--------------------------------------------- #undef SUBTASK_C ------------------------------------------

--------------------------------------------- #define SUBTASK_D -----------------------------------------
ALTER TABLE [dbo].[StateProvince]
	ADD CONSTRAINT [TerritoryID_Default_Value]
		DEFAULT 2 FOR [TerritoryID];
--------------------------------------------- #undef SUBTASK_D ------------------------------------------

--------------------------------------------- #define SUBTASK_E -----------------------------------------
INSERT INTO [dbo].[StateProvince] (
	  [StateProvinceID]
	, [StateProvinceCode]
	, [CountryRegionCode]
	, [IsOnlyStateProvinceFlag]
	, [Name]
	, [ModifiedDate])
	SELECT
		  [t].[StateProvinceID]
		, [t].[StateProvinceCode]
		, [t].[CountryRegionCode]
		, [t].[IsOnlyStateProvinceFlag]
		, [t].[Name]
		, [t].[ModifiedDate]
	FROM (
		SELECT 		
			  [sp].[StateProvinceID]
			, [sp].[StateProvinceCode]
			, [sp].[CountryRegionCode]
			, [sp].[IsOnlyStateProvinceFlag]
			, [sp].[Name]
			, [sp].[ModifiedDate]			
			, [a].[AddressID]
			, MAX([a].[AddressID]) OVER (PARTITION BY [sp].[StateProvinceID], [sp].[StateProvinceCode]) [MaxAddressID]
		FROM [Person].[StateProvince] [sp]
		INNER JOIN [Person].[Address] [a]
			ON ([a].[StateProvinceID] = [sp].[StateProvinceID])
		INNER JOIN [Person].[BusinessEntityAddress] [bea]
			ON ([a].[AddressID] = [bea].[AddressID])
		INNER JOIN [Person].[AddressType] [at]
			ON ([bea].[AddressTypeID] = [at].[AddressTypeID])
		WHERE [at].[Name] = 'Shipping'
	) [t]
	WHERE [t].[MaxAddressID] = [t].[AddressID];
--------------------------------------------- #undef SUBTASK_E ------------------------------------------

--------------------------------------------- #define SUBTASK_F -----------------------------------------
ALTER TABLE [dbo].[StateProvince]
	ALTER COLUMN [IsOnlyStateProvinceFlag] SMALLINT NULL;
--------------------------------------------- #undef SUBTASK_F ------------------------------------------

--------------------------------------------- #undef  TASK2 ---------------------------------------------