
/************************
 * EXEMPLE DE JOINTURES *
 ************************/
SELECT LT.[LeftTableId], LT.[LeftValue], RT.[RightValue], RT.[RightTableId]
FROM [LeftTable] LT
	CROSS JOIN [RightTable] RT;

SELECT LT.[LeftTableId], LT.[LeftValue], RT.[RightValue], RT.[RightTableId]
FROM [LeftTable] LT
	LEFT JOIN [RightTable] RT ON LT.[LeftTableId] = RT.[LeftTableId];

SELECT LT.[LeftTableId], LT.[LeftValue], RT.[RightValue], RT.[RightTableId]
FROM [LeftTable] LT
	RIGHT JOIN [RightTable] RT ON LT.[LeftTableId] = RT.[LeftTableId];

SELECT LT.[LeftTableId], LT.[LeftValue], RT.[RightValue], RT.[RightTableId]
FROM [LeftTable] LT
	FULL JOIN [RightTable] RT ON LT.[LeftTableId] = RT.[LeftTableId];

SELECT LT.[LeftTableId], LT.[LeftValue], RT.[RightValue], RT.[RightTableId]
FROM [LeftTable] LT
	INNER JOIN [RightTable] RT ON LT.[LeftTableId] = RT.[LeftTableId];

