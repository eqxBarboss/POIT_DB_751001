--------------------------------------------- #define TASK2 ---------------------------------------------

--------------------------------------------- #define preparations --------------------------------------
USE [master];
GO

IF EXISTS(select * from [sys].[databases] where [name]='AdventureWorks')
DROP DATABASE [AdventureWorks];

RESTORE DATABASE [AdventureWorks]
	FROM DISK = 'C:\Users\eqxba\Desktop\��\aw2012fdb\AdventureWorks2012-Full Database Backup.bak'
	WITH MOVE 'AdventureWorks2012_Data' TO 'C:\Users\eqxba\Desktop\��\aw2012fdb\AdventureWorks2012_Data.mdf',
	MOVE 'AdventureWorks2012_Log' TO 'C:\Users\eqxba\Desktop\��\aw2012fdb\AdventureWorks2012_Log.ldf';
GO

USE [AdventureWorks]
GO
--------------------------------------------- #undef preparations ---------------------------------------

--------------------------------------------- #define SUBTASK1 ------------------------------------------
SELECT 
	  [BusinessEntityID]
	, [JobTitle]
	, [BirthDate]
	, [HireDate]
FROM
	[AdventureWorks].[HumanResources].[Employee]
WHERE
	DATEDIFF(YEAR, [BirthDate], '1981') <= 0
	AND
	DATEDIFF(DAY, [HireDate], '2003-04-2') <= 0;
--------------------------------------------- #undef SUBTASK1 -------------------------------------------

--------------------------------------------- #define SUBTASK2 ------------------------------------------
SELECT 
	  SUM([VacationHours]) as [SumVacationHours]
	, SUM([SickLeaveHours]) as [SumSickLeaveHours]
FROM
	[AdventureWorks].[HumanResources].[Employee];
--------------------------------------------- #undef SUBTASK2 -------------------------------------------

--------------------------------------------- #define SUBTASK3 ------------------------------------------
SELECT TOP 3 
	  [BusinessEntityID]
	, [JobTitle]
	, [BirthDate]
	, [HireDate]
FROM
	[AdventureWorks].[HumanResources].[Employee]
ORDER BY 
	[HireDate] 
	ASC;
--------------------------------------------- #undef SUBTASK3 -------------------------------------------

--------------------------------------------- #undef  TASK2 ---------------------------------------------