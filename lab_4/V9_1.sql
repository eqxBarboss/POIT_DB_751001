--------------------------------------------- #define TASK1 ---------------------------------------------

USE [AdventureWorks];
GO

--------------------------------------------- #define SUBTASK_A -----------------------------------------
CREATE TABLE [Sales].[SpecialOfferHst] (
	  [ID]           INT IDENTITY(1,1) PRIMARY KEY
	, [Action]       NVARCHAR(6)       NOT NULL
	, [ModifiedDate] DATETIME          NOT NULL
	, [SourceID]     INT               NOT NULL
	, [UserName]     NVARCHAR(30)      NOT NULL);
GO	
--------------------------------------------- #undef SUBTASK_A ------------------------------------------	

--------------------------------------------- #define SUBTASK_B -----------------------------------------
CREATE TRIGGER [SpecialOfferHst_Trigger]
ON [Sales].[SpecialOffer]
AFTER INSERT, UPDATE, DELETE
AS
IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
	INSERT INTO [Sales].[SpecialOfferHst]
	SELECT
		  'update'
		, CURRENT_TIMESTAMP	
		, [SpecialOfferID]
		, CURRENT_USER
	FROM inserted
ELSE IF EXISTS (SELECT * FROM inserted)
	INSERT INTO [Sales].[SpecialOfferHst]
	SELECT
		  'insert'
		, CURRENT_TIMESTAMP	
		, [SpecialOfferID]
		, CURRENT_USER
	FROM inserted
ELSE IF EXISTS (SELECT * FROM deleted)
	INSERT INTO [Sales].[SpecialOfferHst]
	SELECT
		  'delete'
		, CURRENT_TIMESTAMP	
		, [SpecialOfferID]
		, CURRENT_USER
	FROM deleted;
GO			
--------------------------------------------- #undef SUBTASK_B ------------------------------------------

--------------------------------------------- #define SUBTASK_C -----------------------------------------
CREATE VIEW [SpecialOffer_View] 
WITH ENCRYPTION
AS
SELECT * FROM [Sales].[SpecialOffer];
GO
--------------------------------------------- #undef SUBTASK_C ------------------------------------------

--------------------------------------------- #define SUBTASK_D -----------------------------------------
INSERT INTO [SpecialOffer_View] (
	  [Description]
	, [DiscountPct]
	, [Type]
	, [Category]
	, [StartDate]
	, [EndDate]
	, [MinQty]
	, [MaxQty]
	, [rowguid]
	, [ModifiedDate])
VALUES (
	  'bla-bla-bla'
	, 0
	, 'No Discount'
	, 'No Discount'
	, '2005-06-01 00:00:00.000'
	, '2008-12-31 00:00:00.000'
	, 0
	, NULL
	, NEWID()
	, '2005-05-02 00:00:00.000');
GO

UPDATE [SpecialOffer_View]
SET [Type] = 'QQWRD'
WHERE [Description] = 'bla-bla-bla';
GO

DELETE FROM [SpecialOffer_View]
WHERE [Description] = 'bla-bla-bla';
GO

SELECT * FROM [Sales].[SpecialOfferHst];
GO
--------------------------------------------- #undef SUBTASK_D ------------------------------------------

--------------------------------------------- #undef TASK1 ----------------------------------------------