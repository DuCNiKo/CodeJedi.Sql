CREATE SCHEMA [chapter5];
GO

CREATE TABLE [chapter5].[TableIsNull] (
    [TextValue] VARCHAR(50) NULL
);

INSERT INTO [chapter5].[TableIsNull] VALUES
    (NULL)
    , ('A Text')
    , ('Another text')
    , (NULL)
    , (NULL)
    , ('Final text');

