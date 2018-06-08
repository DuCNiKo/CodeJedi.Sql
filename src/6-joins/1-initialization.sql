CREATE SCHEMA [chapter6];
GO

CREATE TABLE [LeftTable](
	[LeftTableId] INT NOT NULL,
	[LeftValue] CHAR(1) NOT NULL,
	CONSTRAINT [LeftTable_PK] PRIMARY KEY ([LeftTableId])
);

CREATE TABLE [RightTable] (
	[RightTableId] INT NOT NULL,
	[LeftTableId] INT NULL,
	[RightValue] CHAR(1) NOT NULL,
	CONSTRAINT [RightTable_PK] PRIMARY KEY ([RightTableId]),
	CONSTRAINT [RightTable_LeftTable_FK] FOREIGN KEY ([LeftTableId]) REFERENCES [LeftTable]([LeftTableId])
);

/******************************
 * INITIALISATION DES DONNEES *
 ******************************/
INSERT INTO [LeftTable] VALUES 
	(1, 'A')
	, (2, 'B')
	, (3, 'C')
	, (4, 'D')
	, (5, 'E');

INSERT INTO [RightTable] VALUES
	(1, NULL, 'A')
	, (2, 1, 'B')
	, (3, 4, 'C')
	, (4, NULL, 'D')
	, (5, 2, 'E')
	, (6, 3, 'F');
