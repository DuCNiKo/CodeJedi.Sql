-- ROW_NUMBER, RANK et DENSE_RANK
SELECT ROW_NUMBER() OVER (PARTITION BY DATEPART(YYYY, AM.[MouvementDate]), DATEPART(MM, AM.[MouvementDate]) ORDER BY AM.[Name]) AS [Order], DATEPART(YYYY, AM.[MouvementDate]) AS [Year], DATEPART(MM, AM.[MouvementDate]) AS [Month], AM.[Amount], AM.[Name]
FROM [chapter8].[AccountMouvement] AM;

SELECT RANK() OVER (PARTITION BY DATEPART(YYYY, AM.[MouvementDate]), DATEPART(MM, AM.[MouvementDate]) ORDER BY AM.[Name]) AS [Order], DATEPART(YYYY, AM.[MouvementDate]) AS [Year], DATEPART(MM, AM.[MouvementDate]) AS [Month], AM.[Amount], AM.[Name]
FROM [chapter8].[AccountMouvement] AM;

SELECT DENSE_RANK() OVER (PARTITION BY DATEPART(YYYY, AM.[MouvementDate]), DATEPART(MM, AM.[MouvementDate]) ORDER BY AM.[Name]) AS [Order], DATEPART(YYYY, AM.[MouvementDate]) AS [Year], DATEPART(MM, AM.[MouvementDate]) AS [Month], AM.[Amount], AM.[Name]
FROM [chapter8].[AccountMouvement] AM;

-- CTE et récursivité
WITH [Recur]([ParentVehiculeId], [Name]) AS (
	SELECT V.[ParentVehiculeId], V.[Name] FROM [chapter8].[Vehicule] V WHERE V.[VehiculeId] = 11
	UNION ALL SELECT V.[ParentVehiculeId], V.[Name] FROM [chapter8].[Vehicule] V INNER JOIN [Recur] R ON R.[ParentVehiculeId] = V.[VehiculeId]
)
SELECT * FROM [Recur];

WITH [Recur]([VehiculeId], [Level], [Name]) AS (
	SELECT V.[VehiculeId], 0, CONVERT(VARCHAR(MAX), V.[Name]) FROM [chapter8].[Vehicule] V WHERE V.[ParentVehiculeId] IS NULL
	UNION ALL SELECT V.[VehiculeId], R.[Level] + 1, CONCAT(R.[Name], ' => ', V.[Name]) FROM [chapter8].[Vehicule] V INNER JOIN [Recur] R ON R.[VehiculeId] = V.[ParentVehiculeId]
)
SELECT * FROM [Recur] R WHERE NOT EXISTS(SELECT 1 FROM [chapter8].[Vehicule] V WHERE V.[ParentVehiculeId] = R.[VehiculeId]);

WITH [Recur] AS (
	SELECT 
		UR.[UserId]
		, CONVERT(VARCHAR(MAX), CASE WHEN CHARINDEX(',', UR.[Roles]) > 0 THEN LEFT(UR.[Roles], CHARINDEX(',', UR.[Roles]) - 1) ELSE UR.[Roles] END) AS [OneRole]
		, CONVERT(VARCHAR(MAX), CASE WHEN CHARINDEX(',', UR.[Roles]) > 0 THEN RIGHT(UR.[Roles], LEN(UR.[Roles]) - CHARINDEX(',', UR.[Roles])) ELSE NULL END) AS [RolesLeft] 
	FROM [chapter8].[UserRole] UR
	UNION ALL SELECT 
		R.[UserId]
		, CONVERT(VARCHAR(MAX), CASE WHEN CHARINDEX(',', R.[RolesLeft]) > 0 THEN LEFT(R.[RolesLeft], CHARINDEX(',', R.[RolesLeft]) - 1) ELSE R.[RolesLeft] END)
		, CONVERT(VARCHAR(MAX), CASE WHEN CHARINDEX(',', R.[RolesLeft]) > 0 THEN RIGHT(R.[RolesLeft], LEN(R.[RolesLeft]) - CHARINDEX(',', R.[RolesLeft])) ELSE NULL END)
	FROM [Recur] R 
	WHERE R.[RolesLeft] IS NOT NULL
)
SELECT [UserId], [OneRole]
FROM [Recur]
ORDER BY [UserId], [OneRole]

-- Procédures stockées
DECLARE 
	@Var1 INT = 1, @Var2 INT = 2;

-- Appel sans nommer les variables et sans valeur de sortie
EXEC [chapter8].[FirstProc] @Var1, @Var2;
-- Les variables ne sont pas changées
SELECT @Var1, @Var2;

-- Appel avec nommage des variables (l'ordre est différent) et une valeur de sortie
EXEC [chapter8].[SecondProc] @Variable2 = @Var2, @Variable1 = @Var1 OUT;
-- La variable locale @Var1 est modifiée
SELECT @Var1, @Var2;
