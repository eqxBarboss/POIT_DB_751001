--------------------------------------------- #define TASK2 ---------------------------------------------

USE [AdventureWorks];
GO

--------------------------------------------- #define SUBTASK_A -----------------------------------------
ALTER TABLE [dbo].[StateProvince]
	ADD
		  [TaxRate]             SMALLMONEY   NULL
		, [CurrencyCode]        NCHAR(3)     NULL
		, [AverageRate]         MONEY        NULL
		, [IntTaxRate] AS CEILING(TaxRate);
--------------------------------------------- #undef SUBTASK_A ------------------------------------------

--------------------------------------------- #define SUBTASK_B -----------------------------------------
CREATE TABLE [#StateProvince] (
	  [StateProvinceID]         INT          NOT NULL PRIMARY KEY
	, [StateProvinceCode]       NCHAR(3)     NOT NULL
	, [CountryRegionCode]       NVARCHAR(3)  NOT NULL
	, [IsOnlyStateProvinceFlag] SMALLINT     NULL
	, [Name]                    NVARCHAR(50) NOT NULL
	, [TerritoryID]             INT          NOT NULL
	, [ModifiedDate]            DATETIME     NOT NULL
	, [TaxRate]                 SMALLMONEY   NULL
	, [CurrencyCode]            NCHAR(3)     NULL
	, [AverageRate]             MONEY        NULL);	
--------------------------------------------- #undef SUBTASK_B ------------------------------------------

--------------------------------------------- #define SUBTASK_C -----------------------------------------
INSERT INTO [#StateProvince]
SELECT 
	  [sp].[StateProvinceID]
	, [sp].[StateProvinceCode]
	, [sp].[CountryRegionCode]
	, [sp].[IsOnlyStateProvinceFlag]
	, [sp].[Name]
	, [sp].[TerritoryID]
	, [sp].[ModifiedDate]
	, COALESCE([str].[TaxRate], 0)
	, [crc].[CurrencyCode]
	, NULL
FROM [dbo].[StateProvince] [sp]
LEFT OUTER JOIN [Sales].[SalesTaxRate] [str]
	ON (([str].[StateProvinceID] = [sp].[StateProvinceID]) AND ([str].[TaxType] = 1))
INNER JOIN [Sales].[CountryRegionCurrency] [crc]
	ON ([crc].[CountryRegionCode] = [sp].[CountryRegionCode]);

WITH [CTE] AS (
	SELECT 
		  MAX([cr].[AverageRate]) [AverageRate] 
		, [sp].[CurrencyCode]
	FROM [#StateProvince] [sp]
	INNER JOIN [Sales].[CurrencyRate] [cr]
		ON (([cr].[ToCurrencyCode] COLLATE SQL_Latin1_General_CP1_CI_AS) = [sp].[CurrencyCode])
	GROUP BY [sp].[CurrencyCode]
)
UPDATE [#StateProvince]
SET [AverageRate] = [CTE].[AverageRate]
FROM [CTE]
WHERE [#StateProvince].[CurrencyCode] = [CTE].[CurrencyCode];
--------------------------------------------- #undef SUBTASK_C ------------------------------------------

--------------------------------------------- #define SUBTASK_D -----------------------------------------
DELETE 
FROM [dbo].[StateProvince]
WHERE [CountryRegionCode] = 'CA';
--------------------------------------------- #undef SUBTASK_D ------------------------------------------

--------------------------------------------- #define SUBTASK_E -----------------------------------------
MERGE [dbo].[StateProvince] [target]
USING [#StateProvince] [source]
	ON ([source].[StateProvinceID] = [target].[StateProvinceID])
WHEN MATCHED THEN 
	UPDATE
		SET 
			  [target].[TaxRate] = [source].[TaxRate]
			, [target].[CurrencyCode] = [source].[CurrencyCode]
			, [target].[AverageRate] = [source].[AverageRate]
WHEN NOT MATCHED BY TARGET THEN
	INSERT (  
		  [StateProvinceID]
		, [StateProvinceCode]
		, [CountryRegionCode]
		, [IsOnlyStateProvinceFlag]
		, [Name]
		, [TerritoryID]
		, [ModifiedDate]
		, [TaxRate]
		, [CurrencyCode]
		, [AverageRate])
	VALUES (
		  [source].[StateProvinceID]
		, [source].[StateProvinceCode]
		, [source].[CountryRegionCode]
		, [source].[IsOnlyStateProvinceFlag]
		, [source].[Name]
		, [source].[TerritoryID]
		, [source].[ModifiedDate]
		, [source].[TaxRate]
		, [source].[CurrencyCode]
		, [source].[AverageRate])
WHEN NOT MATCHED BY SOURCE THEN
	DELETE;
--------------------------------------------- #undef SUBTASK_E ------------------------------------------

--------------------------------------------- #undef  TASK2 ---------------------------------------------