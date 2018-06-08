CREATE SCHEMA [chapter4];
GO

-- Initialisation
CREATE TABLE [chapter4].[TableSelect](
    [TableSelectId] INT IDENTITY(1, 1) NOT NULL,
    [DateValue] DATETIME NULL,
    [IntValue] INT NULL,
    [TextValue] VARCHAR(200) NULL,
    CONSTRAINT [chapter4_TableSelect_PK] PRIMARY KEY ([TableSelectId])
);

INSERT INTO [chapter4].[TableSelect]([DateValue], [IntValue], [TextValue]) VALUES 
    ('2018-05-16 12:44:34', 12, 'A text')
    , (NULL, 1, 'This line is duplicated and will not appear with the DISTINCT keyword.')
    , (NULL, 1, 'This line is duplicated and will not appear with the DISTINCT keyword.')
    , (NULL, 42, 'The Ultimate Question of Life, the Universe and Everything')
    , ('2019-12-31 23:59:59', 42, 'Not my age !!!')
    ;

CREATE TABLE [chapter4].[TableInsert](
    [TableInsertId] INT IDENTITY(1, 1) NOT NULL,
    [DateValue] DATETIME NULL,
    [IntValue] INT NULL,
    [TextValue] VARCHAR(200) NULL,
    CONSTRAINT [chapter4_TableInsert_PK] PRIMARY KEY ([TableInsertId])
);

CREATE TABLE [chapter4].[TableUpdate](
    [TableUpdateId] INT IDENTITY(1, 1) NOT NULL,
    [DateValue] DATETIME NULL,
    [IntValue] INT NULL,
    [TextValue] VARCHAR(200) NULL,
    CONSTRAINT [chapter4_TableUpdate_PK] PRIMARY KEY ([TableUpdateId])
);

INSERT INTO [chapter4].[TableUpdate]([DateValue], [IntValue], [TextValue]) VALUES 
    ('2018-05-16 12:44:34', 12, 'A text')
    , (NULL, 1, 'This line is duplicated and will not appear with the DISTINCT keyword.')
    , (NULL, 1, 'This line is duplicated and will not appear with the DISTINCT keyword.')
    , (NULL, 42, 'The Ultimate Question of Life, the Universe and Everything')
    , ('2019-12-31 23:59:59', 42, 'Not my age !!!');

CREATE TABLE [chapter4].[TableDelete](
    [TableDeleteId] INT IDENTITY(1, 1) NOT NULL,
    [DateValue] DATETIME NULL,
    [IntValue] INT NULL,
    [TextValue] VARCHAR(200) NULL,
    CONSTRAINT [chapter4_TableDelete_PK] PRIMARY KEY ([TableDeleteId])
);

INSERT INTO [chapter4].[TableDelete]([DateValue], [IntValue], [TextValue]) VALUES 
    ('2018-05-16 12:44:34', 12, 'A text')
    , (NULL, 1, 'This line is duplicated and will not appear with the DISTINCT keyword.')
    , (NULL, 1, 'This line is duplicated and will not appear with the DISTINCT keyword.')
    , (NULL, 42, 'The Ultimate Question of Life, the Universe and Everything')
    , ('2019-12-31 23:59:59', 42, 'Not my age !!!');


CREATE TABLE [chapter4].[TableMerge](
    [TableMergeId] INT IDENTITY(1, 1) NOT NULL,
    [Code] VARCHAR(5) NOT NULL,
    [DisplayText] VARCHAR(50) NOT NULL,
    CONSTRAINT [chapter4_TableMerge_PK] PRIMARY KEY ([TableMergeId])
);

INSERT INTO [chapter4].[TableMerge] ([Code], [DisplayText]) VALUES 
    ('M', 'Monsieur')
    , ('Mme', 'Madame')
    , ('Mlle', 'Mam''zelle')
    , ('BF', 'Bouffon');