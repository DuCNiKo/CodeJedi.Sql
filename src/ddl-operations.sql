-- Premières tables

CREATE TABLE [Person] (
    [PersonId] INT IDENTITY(1, 1) NOT NULL,
    [Firstname] VARCHAR(50) NOT NULL,
    [Lastname] VARCHAR(50) NOT NULL,
    [Birthdate] DATETIME NOT NULL,
    CONSTRAINT [PK_dbo_Person] PRIMARY KEY ([PersonId])
);

CREATE TABLE [EmailAddress] (
    [EmailAddressId] INT IDENTITY (1, 1) NOT NULL,
    [PersonId] INT NOT NULL,
    [EmailAddress] VARCHAR(200) NOT NULL,
    CONSTRAINT [PK_dbo_EmailAddress] PRIMARY KEY ([EmailAddressId]),
    CONSTRAINT [FK_EmailAddress_Person] FOREIGN KEY ([PersonId]) REFERENCES [Person]([PersonId])
);

-- Modification des tables

ALTER TABLE [Person] 
    ADD CONSTRAINT [CK_Person_Birthdate] CHECK ([BirthDate] < GETDATE());

ALTER TABLE [EmailAddress]
    ADD CONSTRAINT [UQ_EmailAddress_EmailAddress] UNIQUE ([EmailAddress]);

ALTER TABLE [EmailAddress]
    ADD [EmailVerified] BIT NOT NULL DEFAULT (0);