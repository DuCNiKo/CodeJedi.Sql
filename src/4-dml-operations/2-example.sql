-- SELECT
SELECT * 
FROM [chapter4].[TableSelect];

SELECT [DateValue] AS [ADate] 
FROM [chapter4].[TableSelect];

---- WHERE
SELECT * 
FROM [chapter4].[TableSelect]
WHERE [IntValue] = '42';

SELECT * 
FROM [chapter4].[TableSelect]
WHERE [DateValue] < GETDATE();

SELECT * 
FROM [chapter4].[TableSelect]
WHERE [IntValue] = '42' AND [TextValue] = 'The Ultimate Question of Life, the Universe and Everything';

---- ORDER BY
SELECT * 
FROM [chapter4].[TableSelect]
ORDER BY [DateValue];

SELECT * 
FROM [chapter4].[TableSelect]
ORDER BY [IntValue] ASC, [TextValue] ASC;

---- DISTINCT
SELECT DISTINCT * 
FROM [chapter4].[TableSelect];

---- TOP
SELECT TOP 2 * 
FROM [chapter4].[TableSelect];

-- INSERT
INSERT INTO [chapter4].[TableInsert] ([DateValue], [IntValue], [TextValue])
    SELECT [DateValue], [IntValue], [TextValue] 
    FROM [chapter4].[TableSelect]
    WHERE [IntValue] = 42;

INSERT INTO [chapter4].[TableInsert] ([DateValue], [IntValue], [TextValue])
    VALUES (NULL, 42, 'Still not my age');

INSERT INTO [chapter4].[TableInsert] ([DateValue], [IntValue], [TextValue]) VALUES 
    (NULL, 42, 'How many times must I say that it''s not my age!!!')
    , (NULL, 42, 'How many times must I say that it''s not my age!!!')
    , (NULL, 42, 'How many times must I say that it''s not my age!!!')
    , (NULL, 42, 'How many times must I say that it''s not my age!!!')
    , (NULL, 42, 'How many times must I say that it''s not my age!!!');

-- UPDATE
UPDATE [chapter4].[TableUpdate]
	SET [IntValue] = 2, [TextValue] = 'This line is no longer duplicated.'
	WHERE [TableUpdateId] = 2;

-- DELETE
DELETE FROM [chapter4].[TableDelete]
WHERE [DateValue] IS NULL;

-- MERGE
SET IDENTITY_INSERT [chapter4].[TableMerge] ON;

MERGE INTO [chapter4].[TableMerge] T
USING (
    SELECT 1, 'M', 'Monsieur'
    UNION SELECT 2, 'Mme', 'Madame'
    UNION SELECT 3, 'Mlle', 'Mademoiselle'
    UNION SELECT 4, 'Dr', 'Docteur'
    UNION SELECT 5, 'MM', 'Messieurs'
    ) S([Id], [Code], [DisplayText]) ON T.[TableMergeId] = S.[Id]
WHEN MATCHED THEN UPDATE SET [Code] = S.[Code], [DisplayText] = S.[DisplayText]
WHEN NOT MATCHED BY TARGET THEN INSERT ([TableMergeId], [Code], [DisplayText]) VALUES (S.[Id], S.[Code], S.[DisplayText])
WHEN NOT MATCHED BY SOURCE THEN DELETE
;

