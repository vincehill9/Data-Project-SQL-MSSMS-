SELECT [Project Title]
      ,[Object ID]
      ,[Global ID]
      ,[Closure Description]
      ,[Roads Closed]
      ,[Closure Type]
      ,[Closure End Time]
      ,[Closure Start Time]
      ,[Closure End Time Status]
      ,[Location]
 FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

-- Identify the duplicates 
WITH cte_duplicates AS
(
SELECT *, ROW_NUMBER() OVER(PARTITION BY 
       [Project Title]
      ,[Object ID]
      ,[Global ID]
      ,[Closure Description]
      ,[Roads Closed]
      ,[Closure Type]
      ,[Closure End Time]
      ,[Closure Start Time]
      ,[Closure End Time Status]
      ,[Location] ORDER BY [Project Title]) AS row_num
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
)
SELECT *
FROM cte_duplicates
WHERE row_num > 1;


-- Standardise the data 

-- Project Title column
SELECT DISTINCT [Project Title]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT TRIM([Project Title])
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
ORDER BY 1;

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Project Title] = TRIM([Project Title]);

SELECT DISTINCT [Project Title]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT [Project Title]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
WHERE [Project Title] LIKE '2017 / 2018 Residential Street Improvements – Design Package 4 - Construction of new speed humps.';

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Project Title] = '2017 / 2018 Residential Street Improvements Design Package 4 - Construction of new speed humps.'
--WHERE [Project Title] LIKE '2017 / 2018 Residential Street Improvements – Design Package 4 - Construction of new speed humps.';

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Project Title] = '2017 / 2018 Residential Street Improvements Design Package 4 - Construction of new speed humps.'
--WHERE [Project Title] = '2017 / 2018 Residential Street Improvements – Design Package 4- Construction of new speed humps.';

SELECT DISTINCT [Project Title]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
WHERE [Project Title] LIKE 'Civil works associated with the Transport Canberra Light Rail project%';

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Project Title] = 'Civil works associated with the Transport Canberra Light Rail project.'
--WHERE [Project Title] LIKE 'Civil works associated with the Transport Canberra Light Rail project%';

--[Object ID] from float to int
SELECT [Object ID]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
ORDER BY [Object ID];

--ALTER TABLE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--ALTER COLUMN [Object ID] int;

SELECT *
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

--[Closure Description]
SELECT DISTINCT [Closure Description]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
ORDER BY 1;

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure Description] = 'To prevent illegal dumping and vandalism in the area.'
--WHERE [Closure Description] = 'To prevent illegal dumping and vandalism in the area'

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure Description] = 'To restrict level of vandalism.'
--WHERE [Closure Description] = 'To restrict level of vandalism'

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure Description] = 'To restrict the level of vandalism of the Gunner Memorial'
--WHERE [Closure Description] = 'To restrict the level of vandalism of the “Gunner Memorial”'

--[Roads Closed] column
SELECT TRIM([Roads Closed])
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
ORDER BY 1;

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Roads Closed] = 'WERE STREET, CALWELL: WERE ST and CASEY ST roundabout at Calwell is closed (near Calwell High) in both directions.'
--WHERE [Roads Closed] = '
--WERE STREET, CALWELL: WERE ST and CASEY ST roundabout at Calwell is closed (near Calwell High) in both directions.';

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Roads Closed] = TRIM([Roads Closed]);

SELECT DISTINCT [Roads Closed]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
ORDER BY 1;

--[Closure Type] column (Used AI to help)
SELECT [Closure Type]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

WITH RecursiveCTE AS (
    SELECT 
        CAST(STUFF([Closure Type], 1, 1, UPPER(SUBSTRING([Closure Type], 1, 1))) AS VARCHAR(MAX)) AS separatedColumn,
        1 AS pos
    FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
    UNION ALL
    SELECT 
        CAST(STUFF(separatedColumn, pos+1, 1, ' ' + LOWER(SUBSTRING(separatedColumn, pos+1, 1))) AS VARCHAR(MAX)),
        pos + 1
    FROM RecursiveCTE
    WHERE pos < LEN(separatedColumn)
        AND SUBSTRING(separatedColumn, pos+1, 1) COLLATE Latin1_General_BIN LIKE '[A-Z]'
)
SELECT separatedColumn
FROM RecursiveCTE;


--[Closure End Time] and [Closure Start Time] columns 

SELECT [Closure End Time], 
CASE
	WHEN [Closure End Time] LIKE '%AM%' THEN LEFT([Closure End Time],19)
	WHEN [Closure End Time] LIKE '%PM%' THEN LEFT([Closure End Time],19)
	ELSE [Closure End Time]
END
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];


--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure End Time] = 
--CASE
	--WHEN [Closure End Time] LIKE '%AM%' THEN LEFT([Closure End Time],19)
	--WHEN [Closure End Time] LIKE '%PM%' THEN LEFT([Closure End Time],19)
	--ELSE [Closure End Time]
--END
--FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT [Closure End Time]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT [Closure Start Time]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT [Closure Start Time], 
CASE
	WHEN [Closure Start Time] LIKE '%AM%' THEN LEFT([Closure Start Time],19)
	WHEN [Closure Start Time] LIKE '%PM%' THEN LEFT([Closure Start Time],19)
	ELSE ([Closure Start Time]+':00')
END
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];



--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure Start Time] = 
--CASE
	--WHEN [Closure Start Time] LIKE '%AM%' THEN LEFT([Closure Start Time],19)
	--WHEN [Closure Start Time] LIKE '%PM%' THEN LEFT([Closure Start Time],19)
	--ELSE ([Closure Start Time]+':00')
--END
--FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT [Closure Start Time], [Closure End Time]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

--ALTER TABLE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--ADD
--[Closure Start Date] nvarchar(255) NULL,
--[Closure End Date] nvarchar(255) NULL

SELECT [Closure Start Time], [Closure Start Date], [Closure End Time], [Closure End Date]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];


SELECT [Closure Start Time], LEFT([Closure Start Time],10) as 'start_date', [Closure End Time], LEFT([Closure End Time],10) as 'end_date'
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure Start Date] = LEFT([Closure Start Time],10);

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure End Date] = LEFT([Closure End Time],10);


SELECT [Closure End Time]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];


SELECT [Closure End Time], CHARINDEX(' ', [Closure End Time])
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT [Closure End Time], LEN([Closure End Time]), CHARINDEX(' ', [Closure End Time]), LEN([Closure End Time]) - CHARINDEX(' ', [Closure End Time])
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT [Closure End Time], (RIGHT([Closure End Time], LEN([Closure End Time]) - CHARINDEX(' ', [Closure End Time])) + ':00')
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure End Time] = (RIGHT([Closure End Time], LEN([Closure End Time]) - CHARINDEX(' ', [Closure End Time])) + ':00');

SELECT [Closure End Time]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT LEFT([Closure End Time],6)
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT [Closure End Time], LEN([Closure End Time]),
CASE
	WHEN LEN([Closure End Time]) = 7 THEN '0' + [Closure End Time]
	WHEN LEN([Closure End Time]) > 8 THEN LEFT([Closure End Time], 8)
	ELSE [Closure End Time]
END
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure End Time] = 
--CASE
	--WHEN LEN([Closure End Time]) = 7 THEN '0' + [Closure End Time]
	--WHEN LEN([Closure End Time]) > 8 THEN LEFT([Closure End Time], 8)
	--ELSE [Closure End Time]
--END

SELECT [Closure Start Time], CHARINDEX(' ', [Closure Start Time])
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

SELECT [Closure Start Time], SUBSTRING([Closure Start Time],CHARINDEX(' ', [Closure Start Time]),10)
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure Start Time] = SUBSTRING([Closure Start Time],CHARINDEX(' ', [Closure Start Time]),10);

SELECT [Closure Start Time]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

--UPDATE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--SET [Closure Start Time]= 
--CASE
	--WHEN LEN([Closure Start Time]) = 7 THEN '0' + [Closure Start Time]
	--ELSE [Closure Start Time]
--END

--ALTER TABLE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--ALTER COLUMN [Closure Start Date] date;

--ALTER TABLE [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
--ALTER COLUMN [Closure End Date] date;

-----------
-- Exploratory Data Analysis

SELECT [Project Title],	[Object ID], [Closure Description], [Closure Type],	[Roads Closed],	
[Closure Start Date], [Closure Start Time], [Closure End Date],	[Closure End Time],	[Closure End Time Status]		
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

--Data period
SELECT MIN([Closure Start Date]) AS [Start_date], MAX([Closure End Date]) AS [Finish_date], 
DATEDIFF(year,MIN([Closure Start Date]),MAX([Closure End Date])) AS [Years]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$];

--Count of closure types
SELECT [Closure Description], COUNT([Closure Description]) AS [Closure Count]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
GROUP BY [Closure Description]
ORDER BY [Closure Count] DESC;

--Top 3 Count of Roads Closed
SELECT TOP 3 [Roads Closed], COUNT([Roads Closed]) as [Closure Count]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
GROUP BY [Roads Closed]
ORDER BY [Closure Count] DESC;

--Days closed per project and road
SELECT [Project Title], [Roads Closed], [Closure Start Date], [Closure End Date],
DATEDIFF(dy, [Closure Start Date], [Closure End Date]) AS [Days Closed]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
ORDER BY [Days Closed] DESC;

--NULL Values
SELECT [Project Title],	[Object ID], [Closure Description], [Closure Type],	[Roads Closed],	
[Closure Start Date], [Closure End Date]
FROM [PortfolioProjects].[dbo].[Unplanned_Road_Closures__Histor$]
WHERE [Closure Start Date] IS NULL OR [Closure End Date] IS NULL
ORDER BY [Closure Start Date];