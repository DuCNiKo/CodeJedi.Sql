-- Ordonner les employées par ordre d'arrivée dans leur département.
SELECT ROW_NUMBER() OVER (PARTITION BY D.[GroupName], D.[Name] ORDER BY EDH.[StartDate]) AS [Order], D.[GroupName], D.[Name] AS [DepartmentName], CONCAT(P.[FirstName], ' ', P.[LastName]) AS [EmployeeFullName]
FROM [HumanResources].[Department] D
	INNER JOIN [HumanResources].[EmployeeDepartmentHistory] EDH ON D.DepartmentID = EDH.DepartmentID
	INNER JOIN [Person].[Person] P ON EDH.BusinessEntityID = P.BusinessEntityID
WHERE EDH.[EndDate] IS NULL
ORDER BY D.[GroupName], D.[Name], 1