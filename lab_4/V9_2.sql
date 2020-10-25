--------------------------------------------- #define TASK2 ---------------------------------------------

USE [AdventureWorks];
GO

--------------------------------------------- #define SUBTASK_A -----------------------------------------
CREATE VIEW [SpecialOfferInfo_View]
WITH SCHEMABINDING
AS
SELECT
	  [sop].[ProductID]
	, [p].[Name]
	, [so].[SpecialOfferID]
	, [so].[Description]
	, [so].[DiscountPct]
	, [so].[Type]
	, [so].[Category]
	, [so].[StartDate]
	, [so].[EndDate]
	, [so].[MinQty]
	, [so].[MaxQty]
	, [so].[rowguid] [SpecialOfferRowGuid]
	, [so].[ModifiedDate] [SpecialOfferModifiedDate]
	, [sop].[rowguid] [SpecialOfferProductRowGuid]
	, [sop].[ModifiedDate] [SpecialOfferProductModifiedDate]
FROM [Sales].[SpecialOffer] [so]
INNER JOIN [Sales].[SpecialOfferProduct] [sop]
	ON ([sop].[SpecialOfferID] = [so].[SpecialOfferID])
INNER JOIN [Production].[Product] [p]
	ON ([p].[ProductID] = [sop].[ProductID]);
GO

CREATE UNIQUE CLUSTERED INDEX [SpecialOfferInfo_Index]
	ON [SpecialOfferInfo_View]([ProductID], [SpecialOfferID]);
GO	
--------------------------------------------- #undef SUBTASK_A ------------------------------------------

--------------------------------------------- #define SUBTASK_B -----------------------------------------
CREATE TRIGGER [SpecialOfferInfo_Trigger]
ON [SpecialOfferInfo_View]
INSTEAD OF INSERT, UPDATE, DELETE
AS
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	IF UPDATE([SpecialOfferID])
	BEGIN
		RAISERROR('UPDATE of SpecialOfferID is not allowed.', 18, 1);
		ROLLBACK;
	END
	ELSE
	BEGIN
		UPDATE [Sales].[SpecialOffer]
		SET 
			  [Description] = inserted.[Description]
			, [DiscountPct] = inserted.[DiscountPct]
			, [Type] = inserted.[Type]
			, [Category] = inserted.[Category]
			, [StartDate] = inserted.[StartDate]
			, [EndDate] = inserted.[EndDate]
			, [MinQty] = inserted.[MinQty]
			, [MaxQty] = inserted.[MaxQty]
			, [ModifiedDate] = CURRENT_TIMESTAMP
		FROM inserted
		INNER JOIN [Production].[Product] [p]
			ON ([p].[Name] = inserted.[Name])
		WHERE [Sales].[SpecialOffer].[SpecialOfferID] = inserted.[SpecialOfferID];
	END
ELSE IF EXISTS (SELECT * FROM inserted)
BEGIN
	INSERT INTO [Sales].[SpecialOffer]
	SELECT
		  [Description]
		, [DiscountPct]
		, [Type]
		, [Category]
		, [StartDate]
		, [EndDate]
		, [MinQty]
		, [MaxQty]
		, NEWID()
		, CURRENT_TIMESTAMP
	FROM inserted
	INNER JOIN [Production].[Product] [p]
		ON ([p].[Name] = inserted.[Name]);
	INSERT INTO [Sales].[SpecialOfferProduct]
	SELECT
		  SCOPE_IDENTITY()
		, [p].[ProductID]
		, NEWID()
		, CURRENT_TIMESTAMP
	FROM inserted
	INNER JOIN [Production].[Product] [p]
		ON ([p].[Name] = inserted.[Name]);
END
ELSE IF EXISTS (SELECT * FROM deleted)
BEGIN
	CREATE TABLE #SOToDelete (
		[SpecialOfferID] INT NOT NULL);
	INSERT INTO [#SOToDelete]
	SELECT DISTINCT 
		[sop].[SpecialOfferID]
	FROM deleted
	INNER JOIN [Production].[Product] [p]
		ON ([p].[Name] = deleted.[Name])
	INNER JOIN [Sales].[SpecialOfferProduct] [sop]
		ON ([sop].[ProductID] = [p].[ProductID]);
	DELETE 
	FROM [Sales].[SpecialOfferProduct]
	WHERE [Sales].[SpecialOfferProduct].[ProductID] IN (
		SELECT DISTINCT deleted.[ProductID]
		FROM deleted
		INNER JOIN [Production].[Product] [p]
			ON ([p].[Name] = deleted.[Name]));
	DELETE 
	FROM [Sales].[SpecialOffer]
	WHERE [Sales].[SpecialOffer].[SpecialOfferID] IN (
		SELECT [sotd].[SpecialOfferID]
		FROM [#SOToDelete] [sotd]
		LEFT JOIN [Sales].[SpecialOfferProduct] [sop]
			ON ([sop].[SpecialOfferID] = [sotd].[SpecialOfferID])
		WHERE [sop].[SpecialOfferID] IS NULL);
END;
GO
--------------------------------------------- #undef SUBTASK_B ------------------------------------------

--------------------------------------------- #define SUBTASK_C -----------------------------------------
INSERT INTO [SpecialOfferInfo_View] (
	  [Name]
	, [Description]
	, [DiscountPct]
	, [Type]
	, [Category]
	, [StartDate]
	, [EndDate]
	, [MinQty]
	, [MaxQty])
VALUES (
	  'Adjustable Race'
	, 'Ultra mega discount'
	, 0.99
	, 'Volume Discount'
	, 'Reseller'
	, '2005-06-01 00:00:00.000'
	, '2005-10-01 00:00:00.000'
	, 0
	, 10);
GO

UPDATE [SpecialOfferInfo_View]
SET 
	  [Description] = 'Some another cool discount'
	, [DiscountPct] = 0.7
	, [Type] = 'Volume Discount'
	, [Category] = 'Reseller'
	, [StartDate] = '2005-07-01 00:00:00.000'
	, [EndDate] = '2005-08-01 00:00:00.000'
	, [MinQty] = 123
	, [MaxQty] = 1254
WHERE [Name] = 'Adjustable Race' AND [SpecialOfferID] = 18;	
GO

DELETE 
FROM [SpecialOfferInfo_View] 
WHERE ((SpecialOfferID = 18) AND (ProductID = 1));
GO
--------------------------------------------- #undef SUBTASK_C ------------------------------------------

--------------------------------------------- #undef  TASK2 ---------------------------------------------