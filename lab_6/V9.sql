--------------------------------------------- #define TASK1 ---------------------------------------------

USE [AdventureWorks];
GO

--------------------------------------------- #define SUBTASK_1 -----------------------------------------
CREATE PROCEDURE [Sales].[MaxDiscountByCategory](@categories NVARCHAR(max)) AS
BEGIN
	DECLARE @sqlQuery nvarchar(1024) = '
	SELECT * FROM (
		SELECT 
			  [so].[Category]
			, [so].[DiscountPct]
			, [p].[Name] 
		FROM [Sales].[SpecialOffer] [so]
		INNER JOIN [Sales].[SpecialOfferProduct] [sop]
			ON ([sop].[SpecialOfferID] = [so].[SpecialOfferID])
		INNER JOIN [Production].[Product] [p]
			ON ([p].[ProductID] = [sop].[ProductID])) [p]
	PIVOT (
		MAX([DiscountPct])
		FOR [Category] IN (' + @categories + ')) [pivot];';
	EXECUTE sp_executesql @sqlQuery;
END
GO

EXEC [Sales].[MaxDiscountByCategory] @categories = '[Reseller], [No Discount], [Customer]';
GO
--------------------------------------------- #undef SUBTASK_1 ------------------------------------------	

--------------------------------------------- #undef TASK1 ----------------------------------------------