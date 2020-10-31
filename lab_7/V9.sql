--------------------------------------------- #define TASK1 ---------------------------------------------

USE [AdventureWorks];
GO

--------------------------------------------- #define SUBTASK_1 -----------------------------------------
DECLARE @xml XML;

SET @xml = (
	SELECT
		  [edh].[StartDate] [Start]
		, [edh].[EndDate] [End]
		, [d].[GroupName] [Department/Group]
		, [d].[Name] [Department/Name]
		FROM [HumanResources].[EmployeeDepartmentHistory] [edh]
		INNER JOIN [HumanResources].[Department] [d]
			ON ([d].[DepartmentID] = [edh].[DepartmentID])
		FOR XML PATH ('Transaction'), ROOT('History'));

SELECT @xml;
--------------------------------------------- #undef SUBTASK_1 ------------------------------------------

--------------------------------------------- #define SUBTASK_2 -----------------------------------------
CREATE TABLE [#tmp] ([sql] XML);

INSERT INTO [#tmp]
	SELECT [xml].[c].query('.')
	FROM @xml.nodes('History/Transaction/Department') [xml]([c]);

SELECT * FROM [#tmp];
--------------------------------------------- #undef SUBTASK_2 ------------------------------------------		

--------------------------------------------- #undef TASK1 ----------------------------------------------