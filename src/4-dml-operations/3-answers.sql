-- 1. Tous les départements existants
SELECT * FROM [HumanResources].[Department];

-- 2. Produits misen vante depuis le 01/01/2010 classé par prix croissant
SELECT * 
FROM [Production].[Product] P 
WHERE P.[SellStartDate] >= '2010-01-01' 
ORDER BY P.[StandardCost] ASC;

-- 3. Ajouter le département French stores. 
BEGIN TRAN
	SELECT * FROM [HumanResources].[Department];

	INSERT INTO [HumanResources].[Department]([Name], [GroupName]) 
	VALUES ('French stores', 'stores');

	SELECT * FROM [HumanResources].[Department];
COMMIT

-- 4. Modification d'une commande
BEGIN TRAN
	DECLARE @SalesOrderId INT, @SalesOrderDetailId INT;

	SELECT @SalesOrderId = SOD.[SalesOrderID], @SalesOrderDetailId = SOD.[SalesOrderDetailId]
	FROM [Production].[Product] P
		INNER JOIN [Sales].[SalesOrderDetail] SOD ON P.[ProductID] = SOD.[ProductID]
		INNER JOIN [Sales].[SalesOrderHeader] SOH ON SOD.[SalesOrderID] = SOH.[SalesOrderID]
		INNER JOIN [Sales].[Customer] C ON SOH.[CustomerID] = C.[CustomerID]
		INNER JOIN [Sales].[Store] S ON C.[StoreID] = S.[BusinessEntityID]
	WHERE SOH.[OrderDate] = '2011-05-31'
		AND S.[Name] = 'Seventh Bike Store'
		AND P.[Name] = 'Sport-100 Helmet, Black';

	SELECT * FROM [Sales].[SalesOrderDetail] WHERE [SalesOrderID] = @SalesOrderId AND [SalesOrderDetailID] = @SalesOrderDetailId;

	UPDATE [Sales].[SalesOrderDetail]
	SET [OrderQty] = 3
	WHERE [SalesOrderID] = @SalesOrderId AND [SalesOrderDetailID] = @SalesOrderDetailId;

	SELECT * FROM [Sales].[SalesOrderDetail] WHERE [SalesOrderID] = @SalesOrderId AND [SalesOrderDetailID] = @SalesOrderDetailId;
COMMIT

-- 5. Suppression du département French Stores
BEGIN TRAN
	DECLARE @DepartmentId INT;
	SELECT @DepartmentId = [DepartmentId] FROM [HumanResources].[Department] WHERE [Name] = 'Franch stores';

	SELECT * FROM [HumanResources].[Department] WHERE [DepartmentID] = @DepartmentId;

	DELETE FROM [HumanResources].[Department] WHERE [DepartmentID] = @DepartmentId;

	SELECT * FROM [HumanResources].[Department] WHERE [DepartmentID] = @DepartmentId;
COMMIT

-- 6. Modifier les types d'addresses
BEGIN TRAN
	SELECT * FROM [Person].[AddressType];

	DECLARE @Date DATETIME = GETDATE();

	SET IDENTITY_INSERT [Person].[AddressType] ON

	MERGE INTO [Person].[AddressType] T
	USING (
		SELECT 1, 'Billing', '00000000-0000-0000-0000-000000000001', @Date
		UNION ALL SELECT 2, 'Home', '00000000-0000-0000-0000-000000000002', @Date
		UNION ALL SELECT 3, 'Main Office', '00000000-0000-0000-0000-000000000003', @Date
		UNION ALL SELECT 4, 'Primary', '00000000-0000-0000-0000-000000000004', @Date
		UNION ALL SELECT 5, 'Shipping', '00000000-0000-0000-0000-000000000005', @Date
		UNION ALL SELECT 6, 'Archive', '00000000-0000-0000-0000-000000000006', @Date
		UNION ALL SELECT 7, 'Factory', '00000000-0000-0000-0000-000000000007', @Date
	) S([AddressTypeId], [Name], [rowguid], [ModifiedDate]) ON T.[AddressTypeId] = S.[AddressTypeId]
	WHEN MATCHED THEN UPDATE SET [Name] = S.[Name], [rowguid] = S.[rowguid], [ModifiedDate] = S.[ModifiedDate]
	WHEN NOT MATCHED BY TARGET THEN INSERT([AddressTypeId], [Name], [rowguid], [ModifiedDate]) VALUES (S.[AddressTypeId], S.[Name], S.[rowguid], S.[ModifiedDate]);

	SET IDENTITY_INSERT [Person].[AddressType] OFF

	SELECT * FROM [Person].[AddressType];
COMMIT