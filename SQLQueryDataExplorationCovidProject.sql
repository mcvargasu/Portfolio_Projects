--Overviewing Data
SELECT *
FROM WHRData2021$
--Top 10 Countries with highest change in population 
SELECT TOP 10 [Countryname],[Population2020],[Population2019],([Population2020]-[Population2019])/[Population2019] AS Overall_Change
FROM WHRData2021$
ORDER BY Overall_Change DESC
--Top 10 countries with highest covid 10 deaths per 100000 population
SELECT TOP 10 [Countryname],[COVID-19deathsper100,000populationin2020]
FROM WHRData2021$
ORDER BY [COVID-19deathsper100,000populationin2020] DESC
--Top 10 islands with highest covid 10 deaths per 100000 population
SELECT TOP 10 [Countryname],[COVID-19deathsper100,000populationin2020]
FROM WHRData2021$
WHERE Island=1
SELECT TOP 10 [Countryname],[COVID-19deathsper100,000populationin2020]/[Population2020]
FROM WHRData2021$
WHERE Island=1
ORDER BY [COVID-19deathsper100,000populationin2020] DESC
--Top 5 countries with highest median age of the population
SELECT TOP 5 [Countryname],[Medianage]/1000 AS MedianAge
FROM WHRData2021$
ORDER BY [MedianAge] DESC
--Top 5 countries with lowest median age of the population
SELECT TOP 5 [Countryname],[Medianage]/1000 AS MedianAge
FROM WHRData2021$
WHERE [Medianage] IS NOT NULL
ORDER BY [MedianAge] ASC
--Top 10 countries with highest infection rates are ruled by female or male?
with CTE_Top10Covid as 
(SELECT TOP 10 [Countryname],[COVID-19deathsper100,000populationin2020]
FROM WHRData2021$
ORDER BY [COVID-19deathsper100,000populationin2020] DESC)
SELECT WHRData2021$.[Countryname],[Femaleheadofgovernment],WHRData2021$.[COVID-19deathsper100,000populationin2020]
FROM CTE_Top10Covid
JOIN WHRData2021$
ON CTE_Top10Covid.[Countryname]=WHRData2021$.[Countryname]
ORDER BY CTE_Top10Covid.[COVID-19deathsper100,000populationin2020] ASC
--Top 10 countries with lowest infection rates are ruled by female or male?
with CTE_Top10Covid2 as 
(SELECT TOP 10 [Countryname],[COVID-19deathsper100,000populationin2020]
FROM WHRData2021$
WHERE [COVID-19deathsper100,000populationin2020] IS NOT NULL
ORDER BY [COVID-19deathsper100,000populationin2020] ASC)
SELECT WHRData2021$.[Countryname],[Femaleheadofgovernment],WHRData2021$.[COVID-19deathsper100,000populationin2020]
FROM CTE_Top10Covid2
JOIN WHRData2021$
ON CTE_Top10Covid2.[Countryname]=WHRData2021$.[Countryname]
ORDER BY CTE_Top10Covid2.[COVID-19deathsper100,000populationin2020] ASC
--Countries with infection rates by category 
SELECT  MIN(cast([COVID-19deathsper100,000populationin2020] as int)),AVG(cast([COVID-19deathsper100,000populationin2020] as int)),Max(cast([COVID-19deathsper100,000populationin2020] as int))
FROM WHRData2021$
SELECT [COVID-19deathsper100,000populationin2020],[Countryname],
	CASE
WHEN [COVID-19deathsper100,000populationin2020]>=1078 AND [COVID-19deathsper100,000populationin2020]<=38086 THEN 'Category_1'
WHEN [COVID-19deathsper100,000populationin2020]>38086 AND [COVID-19deathsper100,000populationin2020]<=160000 THEN 'Category_2'
ELSE 'Category_3'
END AS Category_Name
FROM WHRData2021$
WHERE cast([COVID-19deathsper100,000populationin2020] as int)  IS NOT NULL
GROUP BY [COVID-19deathsper100,000populationin2020],[Countryname]
--Ranking in the categories
SELECT a.[COVID-19deathsper100,000populationin2020],a.[Countryname],a.Category_Name,RANK() OVER(PARTITION BY a.[Category_Name] ORDER BY a.[COVID-19deathsper100,000populationin2020] DESC) AS Ranking
FROM (
SELECT [COVID-19deathsper100,000populationin2020],[Countryname],
	CASE
WHEN [COVID-19deathsper100,000populationin2020]>=1078 AND [COVID-19deathsper100,000populationin2020]<=38086 THEN 'Category_1'
WHEN [COVID-19deathsper100,000populationin2020]>38086 AND [COVID-19deathsper100,000populationin2020]<=160000 THEN 'Category_2'
ELSE 'Category_3'
END AS Category_Name
FROM WHRData2021$
WHERE cast([COVID-19deathsper100,000populationin2020] as int)  IS NOT NULL
GROUP BY [COVID-19deathsper100,000populationin2020],[Countryname]) a

