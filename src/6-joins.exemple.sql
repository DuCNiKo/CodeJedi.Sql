/***********************
 * CREATION DES TABLES *
 ***********************/
 CREATE TABLE [Table1](
	[Table1Id] INT NOT NULL,
	[Value1] CHAR(1) NOT NULL,
	CONSTRAINT [Table1_PK] PRIMARY KEY ([Table1Id])
);

CREATE TABLE [Table2] (
	[Table2Id] INT NOT NULL,
	[Table1Id] INT NULL,
	[Value2] CHAR(1) NOT NULL,
	CONSTRAINT [Table2_PK] PRIMARY KEY ([Table2Id]),
	CONSTRAINT [Table2_Table1_FK] FOREIGN KEY ([Table1Id]) REFERENCES [Table1]([Table1Id])
);

/******************************
 * INITIALISATION DES DONNEES *
 ******************************/
INSERT INTO [Table1] VALUES 
	(1, 'A')
	, (2, 'B')
	, (3, 'C')
	, (4, 'D')
	, (5, 'E');

INSERT INTO [Table2] VALUES
	(1, NULL, 'A')
	, (2, 1, 'B')
	, (3, 4, 'C')
	, (4, NULL, 'D')
	, (5, 2, 'E')
	, (6, 3, 'F');

/************************
 * EXEMPLE DE JOINTURES *
 ************************/
SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
	CROSS JOIN [Table2] T2;

SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
	LEFT JOIN [Table2] T2 ON T1.[Table1Id] = T2.[Table1Id];

SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
	RIGHT JOIN [Table2] T2 ON T1.[Table1Id] = T2.[Table1Id];

SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
	FULL JOIN [Table2] T2 ON T1.[Table1Id] = T2.[Table1Id];

SELECT T1.[Table1Id], T1.[Value1], T2.[Value2], T2.[Table2Id]
FROM [Table1] T1
	INNER JOIN [Table2] T2 ON T1.[Table1Id] = T2.[Table1Id];

