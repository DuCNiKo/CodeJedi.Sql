-- Mettre ici sa date de naissance au format yyyy-MM-dd hh:mm
DECLARE @MyBirthDate DATETIME = '1979-09-02 22:34';

-- Quel était la date 125j après votre naissance ? 
SELECT DATEADD(DAY, 125, @MyBirthDate) AS [125j après ma naissance];

-- Quel âge allez vous avoir cette année ?
SELECT DATEDIFF(YEAR, @MyBirthDate, GETDATE()) AS [Mon age cette année];

-- Quel est votre âge (en minutes)
SELECT DATEDIFF(MINUTE, @MyBirthDate, GETDATE()) AS [Mon âge en minutes];

-- Splitter votre date de naissance en trois colonnes (Day, Month, Year)
SELECT DATEPART(DAY, @MyBirthDate) AS [Day], DATEPART(MONTH, @MyBirthDate) AS [Month], DATEPART(YEAR, @MyBirthDate) AS [Year]