-- Création des tables
CREATE TABLE [chapter3].[MyFirstTable](
	[MyFirstTableId] INT IDENTITY (1, 1) NOT NULL,
	[VarcharValue] VARCHAR(50) NOT NULL,
	[DateValue] DATETIME NULL,
	[CheckConstraint] INT NOT NULL,
	[DefaultConstraint] DATETIME NOT NULL DEFAULT(GETDATE()),
	CONSTRAINT [chapter3_MyFirstTable_PK] PRIMARY KEY ([MyFirstTableId]),
	CONSTRAINT [chapter3_MyFirstTable_CheckConstraint_CC] CHECK ([CheckConstraint] > 0)
);

CREATE TABLE [chapter3].[MySecondTable] (
    [MySecondTableId] INT IDENTITY (1, 1) NOT NULL,
    [MyFirstTableId] INT NULL,
    [VarcharValue] VARCHAR(50) NULL,
    CONSTRAINT [chapter3_MySecondTable_PK] PRIMARY KEY ([MySecondTableId]),
    CONSTRAINT [chapter3_MySecondTable_MyFirstTable_FK] FOREIGN KEY ([MyFirstTableId]) REFERENCES [chapter3].[MyFirstTable]([MyFirstTableId])
);

CREATE TABLE [chapter3].[TableToDrop](
	[TableToDropId] INT IDENTITY (1, 1) NOT NULL,
	[VarcharValue] VARCHAR(50) NOT NULL,
	CONSTRAINT [chapter3_TableToDrop_PK] PRIMARY KEY ([TableToDropId])
);

CREATE TABLE [chapter3].[TableToAlter](
	[TableToAlterId] INT IDENTITY (1, 1) NOT NULL,
	[VarcharValue] VARCHAR(50) NOT NULL,
	CONSTRAINT [chapter3_TableToAlter_PK] PRIMARY KEY ([TableToAlterId])
);

-- Suppression de table
DROP TABLE [chapter3].[TableToDrop];

-- Modification de table 
---- Ajout de colonne
ALTER TABLE [chapter3].[TableToAlter] ADD
	[DateValue] DATETIME NULL,
	[CheckConstraint] INT NULL,
	[UnusedCol] VARCHAR(10),
	[DefaultConstraint] DATETIME NOT NULL DEFAULT(GETDATE());

---- Ajout de contrainte
ALTER TABLE [chapter3].[TableToAlter] 
    ADD CONSTRAINT [chapter3_TableToAlter_CheckConstraint_CC] CHECK ([CheckConstraint] > 0);

---- Suppression de colonne
ALTER TABLE [chapter3].[TableToAlter] 
	DROP COLUMN [UnusedCol];

---- Suppression de contrainte
ALTER TABLE [chapter3].[TableToAlter]
	DROP CONSTRAINT [chapter3_TableToAlter_CheckConstraint_CC];

---- Modification de colonne
ALTER TABLE [chapter3].[TableToAlter] 
	ALTER COLUMN [CheckConstraint] INT NOT NULL;
