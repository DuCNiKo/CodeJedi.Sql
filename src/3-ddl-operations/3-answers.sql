/*
    Premières tables
*/

CREATE TABLE [chapter3].[Person] (
    [PersonId] INT NOT NULL IDENTITY(1, 1),
    [Firstname] VARCHAR(100),
    [Lastname] VARCHAR(100),
    [BirthDate] DATETIME,
    CONSTRAINT [chapter3_Person_PK] PRIMARY KEY ([PersonId])
);

CREATE TABLE [chapter3].[Email] (
    [EmailId] INT NOT NULL IDENTITY(1, 1),
    [PersonId] INT NOT NULL,
    [EmailAddress] VARCHAR(500) NOT NULL,
    CONSTRAINT [chapter3_Email_PK] PRIMARY KEY ([EmailId]),
    CONSTRAINT [chapter3_Email_Person_FK] FOREIGN KEY ([PersonId]) REFERENCES [chapter3].[Person]([PersonId])
);

/*
    Modification des tables
*/

ALTER TABLE [chapter3].[Person]
ADD CONSTRAINT [chapter3_Person_BirthDate_CK] CHECK ([BirthDate] < GETDATE());

BEGIN TRY
    INSERT INTO [chapter3].[Person]([Firstname], [Lastname], [BirthDate])
    VALUES ('Not', 'Born', DATEADD(YEAR, 1, GETDATE()));
    
    PRINT 'hu ho, something is not working';
END TRY
BEGIN CATCH
    PRINT 'Yeaaaaah the constraint is working :)'
END CATCH

ALTER TABLE [chapter3].[Email] 
ADD CONSTRAINT [chapter3_Email_EmailAddress_UQ] UNIQUE ([EmailAddress]);

BEGIN TRY
    INSERT INTO [chapter3].[Person]([Firstname], [Lastname], [BirthDate])
    VALUES ('Duplicated', 'EmailAddress', DATEADD(YEAR, -1, GETDATE()));
    
    DECLARE @PersonId INT = @@SCOPE_IDENTITY;

    INSERT INTO [chapter3].[Email]([PersonId], [EmailAddress]) VALUES 
        (@PersonId, 'Duplicated.EmailAddress@Ai3.fr'),
        (@PersonId, 'Duplicated.EmailAddress@Ai3.fr');

    PRINT 'hu ho, something is not working';
END TRY
BEGIN CATCH
    PRINT 'Yeaaaaah the constraint is working :)'
END CATCH

ALTER TABLE [chapter3].[Person]
    ADD [Verified] BIT NOT NULL DEFAULT(0);