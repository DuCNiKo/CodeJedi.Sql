-- Afficher les noms et prénoms des employés
SELECT P.[BusinessEntityID], P.[FirstName], P.[LastName]
FROM [HumanResources].[Employee] E
	INNER JOIN [Person].[Person] P ON E.[BusinessEntityID] = P.[BusinessEntityID]
ORDER BY P.[BusinessEntityID];

SELECT P.[BusinessEntityID], P.[FirstName], P.[LastName]
FROM [Person].[Person] P 
WHERE EXISTS(SELECT 1 FROM [HumanResources].[Employee] E WHERE P.[BusinessEntityID] = E.[BusinessEntityID])
ORDER BY P.[BusinessEntityID];

-- Avec les numéros de téléphones et le type de téléphone
SELECT P.[BusinessEntityID], P.[FirstName], P.[LastName], PP.[PhoneNumber], PNT.[Name]
FROM [Person].[Person] P 
	INNER JOIN [Person].[PersonPhone] PP ON P.[BusinessEntityID] = PP.[BusinessEntityID]
	INNER JOIN [Person].[PhoneNumberType] PNT ON PP.[PhoneNumberTypeID] = PNT.[PhoneNumberTypeID]
WHERE EXISTS(SELECT 1 FROM [HumanResources].[Employee] E WHERE P.[BusinessEntityID] = E.[BusinessEntityID])
ORDER BY P.[BusinessEntityID];

-- Les téléphones portables ou null pour les autres.
SELECT P.[BusinessEntityID], P.[FirstName], P.[LastName], A.[PhoneNumber]
FROM [Person].[Person] P 
	LEFT JOIN (
		SELECT PP.[BusinessEntityID], PP.[PhoneNumber], PNT.[Name] 
		FROM [Person].[PersonPhone] PP 
			INNER JOIN [Person].[PhoneNumberType] PNT ON PP.[PhoneNumberTypeID] = PNT.[PhoneNumberTypeID]
	 ) A ON P.[BusinessEntityID] = A.[BusinessEntityID] AND A.[Name] = 'Cell'
WHERE EXISTS(SELECT 1 FROM [HumanResources].[Employee] E WHERE P.[BusinessEntityID] = E.[BusinessEntityID])
ORDER BY P.[BusinessEntityID];
