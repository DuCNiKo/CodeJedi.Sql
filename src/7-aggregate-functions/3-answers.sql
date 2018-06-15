-- Compte d'employés par département.
SELECT D.[Name], COUNT(1)
FROM [HumanResources].[Employee] E
	INNER JOIN [HumanResources].[EmployeeDepartmentHistory] EDH ON E.[BusinessEntityID] = EDH.[BusinessEntityID]
	INNER JOIN [HumanResources].[Department] D ON EDH.[DepartmentID] = D.[DepartmentID]
WHERE EDH.[EndDate] IS NULL
GROUP BY D.[Name];

-- Quantité * Prix unitaire des commandes ayant au moins 20 produits différents sur l'année 2012 et regroupé par commande et magasin
SELECT SOH.[PurchaseOrderNumber], S.[Name] AS [StoreName], SUM(SOD.[OrderQty] * SOD.[UnitPrice])
FROM [Sales].[SalesOrderDetail] SOD
	INNER JOIN [Sales].[SalesOrderHeader] SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
	INNER JOIN [Sales].[Customer] C ON SOH.[CustomerID] = C.[CustomerID]
	INNER JOIN [Sales].[Store] S ON C.[StoreID] = S.[BusinessEntityID]
WHERE DATEPART(YEAR, SOH.[OrderDate]) = 2012
GROUP BY SOH.[PurchaseOrderNumber], S.[Name]
HAVING COUNT(DISTINCT SOD.[ProductId]) > 20
;