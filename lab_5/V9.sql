--------------------------------------------- #define TASK1 ---------------------------------------------

USE [AdventureWorks];
GO

--------------------------------------------- #define SUBTASK_1 -----------------------------------------
CREATE FUNCTION [Sales].[SpecialOfferStartDate] (@SpecialOfferID INT)
RETURNS NVARCHAR(50) AS
BEGIN
	DECLARE @StartDate DATETIME
	SELECT @StartDate = [so].[StartDate]
	FROM [Sales].[SpecialOffer] [so]
	WHERE [SpecialOfferID] = @SpecialOfferID;
	RETURN
		DATENAME(mm, @startDate) + ', ' + DATENAME(day, @startDate) + '. ' + DATENAME(dw, @startDate);
END
GO	

SELECT [Sales].[SpecialOfferStartDate](1);
GO
--------------------------------------------- #undef SUBTASK_1 ------------------------------------------	

--------------------------------------------- #define SUBTASK_2 -----------------------------------------
CREATE FUNCTION [Sales].[GetSpecialOfferProducts](@SpecialOfferID INT)
RETURNS TABLE AS
RETURN 
	SELECT [p].[ProductID], [p].[Name]
	FROM [Sales].[SpecialOfferProduct] [sop]
	INNER JOIN [Production].[Product] [p]
		ON ([p].[ProductID] = [sop].[ProductID])
	WHERE [sop].[SpecialOfferID] = @SpecialOfferID;
GO

SELECT * 
FROM [Sales].[GetSpecialOfferProducts](1);
GO		
--------------------------------------------- #undef SUBTASK_2 ------------------------------------------

--------------------------------------------- #define SUBTASK_3 -----------------------------------------
SELECT 
	  [SpecialOfferID]
	, [ProductID]
	, [Name]
FROM [Sales].[SpecialOffer] [so]
CROSS APPLY 
	[Sales].[GetSpecialOfferProducts]([so].[SpecialOfferID]);
GO

SELECT 
	  [SpecialOfferID]
	, [ProductID]
	, [Name]
FROM [Sales].[SpecialOffer] [so]
OUTER APPLY 
	[Sales].[GetSpecialOfferProducts]([so].[SpecialOfferID]);
GO
--------------------------------------------- #undef SUBTASK_3 ------------------------------------------

--------------------------------------------- #define SUBTASK_4 -----------------------------------------
CREATE FUNCTION [Sales].[GetSpecialOfferProductsMulti](@SpecialOfferID int)
RETURNS @result TABLE (
	  [ProductID] INT
	, [Name] nvarchar(50)) 
AS
BEGIN
	INSERT INTO @result
		SELECT 
			  [p].[ProductID]
			, [p].[Name]
		FROM [Sales].[SpecialOfferProduct] [sop]
		INNER JOIN [Production].[Product] [p]
			ON ([sop].[ProductID] = [p].[ProductID])
		WHERE [sop].[SpecialOfferID] = @SpecialOfferID;
	RETURN;
END
GO

SELECT * 
FROM [Sales].[GetSpecialOfferProductsMulti](1);
GO
--------------------------------------------- #undef SUBTASK_4 ------------------------------------------

--------------------------------------------- #undef TASK1 ----------------------------------------------