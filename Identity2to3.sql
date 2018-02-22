PRINT N'Dropping [dbo].[AspNetUserClaims].[IX_UserId]...';
GO
DROP INDEX [IX_UserId] ON [dbo].[AspNetUserClaims];
GO

PRINT N'Dropping [dbo].[AspNetUserLogins].[IX_UserId]...';
GO
DROP INDEX [IX_UserId] ON [dbo].[AspNetUserLogins];
GO


PRINT N'Dropping [dbo].[AspNetUserRoles].[IX_RoleId]...';
GO
DROP INDEX [IX_RoleId] ON [dbo].[AspNetUserRoles];
GO


PRINT N'Dropping [dbo].[AspNetUserRoles].[IX_UserId]...';
GO
DROP INDEX [IX_UserId] ON [dbo].[AspNetUserRoles];
GO


PRINT N'Dropping [dbo].[FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId]...';
GO
ALTER TABLE [dbo].[AspNetUserRoles] DROP CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetRoles_RoleId];
GO


PRINT N'Dropping [dbo].[FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId]...';
GO
ALTER TABLE [dbo].[AspNetUserClaims] DROP CONSTRAINT [FK_dbo.AspNetUserClaims_dbo.AspNetUsers_UserId];
GO


PRINT N'Dropping [dbo].[FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId]...';
GO
ALTER TABLE [dbo].[AspNetUserLogins] DROP CONSTRAINT [FK_dbo.AspNetUserLogins_dbo.AspNetUsers_UserId];
GO


PRINT N'Dropping [dbo].[FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId]...';
GO
ALTER TABLE [dbo].[AspNetUserRoles] DROP CONSTRAINT [FK_dbo.AspNetUserRoles_dbo.AspNetUsers_UserId];
GO


PRINT N'Starting rebuilding table [dbo].[AspNetRoles]...';
GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_AspNetRoles] (
    [Id]               NVARCHAR (128) NOT NULL,
    [ConcurrencyStamp] NVARCHAR (MAX) NULL,
    [Name]             NVARCHAR (256) NULL,
    [NormalizedName]   NVARCHAR (256) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_AspNetRoles1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[AspNetRoles])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_AspNetRoles] ([Id], [Name], [NormalizedName])
        SELECT   [Id],
                 [Name],
				 UPPER([Name])
        FROM     [dbo].[AspNetRoles]
        ORDER BY [Id] ASC;
    END

DROP TABLE [dbo].[AspNetRoles];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_AspNetRoles]', N'AspNetRoles';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_AspNetRoles1]', N'PK_AspNetRoles', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[AspNetRoles].[RoleNameIndex]...';


GO
CREATE NONCLUSTERED INDEX [RoleNameIndex]
    ON [dbo].[AspNetRoles]([NormalizedName] ASC);


GO
PRINT N'Starting rebuilding table [dbo].[AspNetUserClaims]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_AspNetUserClaims] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [ClaimType]  NVARCHAR (MAX) NULL,
    [ClaimValue] NVARCHAR (MAX) NULL,
    [UserId]     NVARCHAR (128) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_AspNetUserClaims1] PRIMARY KEY CLUSTERED ([Id] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[AspNetUserClaims])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_AspNetUserClaims] ON;
        INSERT INTO [dbo].[tmp_ms_xx_AspNetUserClaims] ([Id], [UserId], [ClaimType], [ClaimValue])
        SELECT   [Id],
                 [UserId],
                 [ClaimType],
                 [ClaimValue]
        FROM     [dbo].[AspNetUserClaims]
        ORDER BY [Id] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_AspNetUserClaims] OFF;
    END

DROP TABLE [dbo].[AspNetUserClaims];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_AspNetUserClaims]', N'AspNetUserClaims';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_AspNetUserClaims1]', N'PK_AspNetUserClaims', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[AspNetUserClaims].[IX_AspNetUserClaims_UserId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetUserClaims_UserId]
    ON [dbo].[AspNetUserClaims]([UserId] ASC);


GO
PRINT N'Starting rebuilding table [dbo].[AspNetUserLogins]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_AspNetUserLogins] (
    [LoginProvider]       NVARCHAR (128) NOT NULL,
    [ProviderKey]         NVARCHAR (450) NOT NULL,
    [ProviderDisplayName] NVARCHAR (MAX) NULL,
    [UserId]              NVARCHAR (128) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_AspNetUserLogins1] PRIMARY KEY CLUSTERED ([LoginProvider] ASC, [ProviderKey] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[AspNetUserLogins])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_AspNetUserLogins] ([LoginProvider], [ProviderKey], [ProviderDisplayName], [UserId])
        SELECT   [LoginProvider],
                 [ProviderKey],
				 [LoginProvider] AS [ProviderDisplayName],
                 [UserId]
        FROM     [dbo].[AspNetUserLogins]
        ORDER BY [LoginProvider] ASC, [ProviderKey] ASC;
    END

DROP TABLE [dbo].[AspNetUserLogins];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_AspNetUserLogins]', N'AspNetUserLogins';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_AspNetUserLogins1]', N'PK_AspNetUserLogins', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[AspNetUserLogins].[IX_AspNetUserLogins_UserId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetUserLogins_UserId]
    ON [dbo].[AspNetUserLogins]([UserId] ASC);


GO
PRINT N'Starting rebuilding table [dbo].[AspNetUserRoles]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_AspNetUserRoles] (
    [UserId] NVARCHAR (128) NOT NULL,
    [RoleId] NVARCHAR (128) NOT NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_AspNetUserRoles1] PRIMARY KEY CLUSTERED ([UserId] ASC, [RoleId] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[AspNetUserRoles])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_AspNetUserRoles] ([UserId], [RoleId])
        SELECT   [UserId],
                 [RoleId]
        FROM     [dbo].[AspNetUserRoles]
        ORDER BY [UserId] ASC, [RoleId] ASC;
    END

DROP TABLE [dbo].[AspNetUserRoles];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_AspNetUserRoles]', N'AspNetUserRoles';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_AspNetUserRoles1]', N'PK_AspNetUserRoles', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[AspNetUserRoles].[IX_AspNetUserRoles_RoleId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_RoleId]
    ON [dbo].[AspNetUserRoles]([RoleId] ASC);


GO
PRINT N'Creating [dbo].[AspNetUserRoles].[IX_AspNetUserRoles_UserId]...';


GO
CREATE NONCLUSTERED INDEX [IX_AspNetUserRoles_UserId]
    ON [dbo].[AspNetUserRoles]([UserId] ASC);


GO

-- CHANGE THE REST OF THE SCRIPT! We should NOT drop AspNetUsers
PRINT N'Starting rebuilding table [dbo].[AspNetUsers]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

ALTER TABLE [dbo].[AspNetUsers]
ADD [ConcurrencyStamp] NVARCHAR(MAX) NULL
GO

ALTER TABLE [dbo].[AspNetUsers]
ADD [LockoutEnd] DATETIMEOFFSET(7) NULL
GO

ALTER TABLE [dbo].[AspNetUsers]
ADD [NormalizedEmail] NVARCHAR(256) NULL
GO

ALTER TABLE [dbo].[AspNetUsers]
ADD [NormalizedUserName] NVARCHAR(256) NULL
GO

DROP INDEX [UserNameIndex] ON [dbo].[AspNetUsers];
GO

UPDATE [dbo].[AspNetUsers]
SET [NormalizedEmail] = UPPER([Email]), [NormalizedUserName] = UPPER([UserName])
GO

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;
GO

PRINT N'Creating [dbo].[AspNetUsers].[EmailIndex]...';
GO
CREATE NONCLUSTERED INDEX [EmailIndex]
    ON [dbo].[AspNetUsers]([NormalizedEmail] ASC);
GO


PRINT N'Creating [dbo].[AspNetUsers].[UserNameIndex]...';
GO
CREATE UNIQUE NONCLUSTERED INDEX [UserNameIndex]
    ON [dbo].[AspNetUsers]([NormalizedUserName] ASC);
GO


PRINT N'Creating [dbo].[AspNetRoleClaims]...';
GO
CREATE TABLE [dbo].[AspNetRoleClaims] (
    [Id]         INT            IDENTITY (1, 1) NOT NULL,
    [ClaimType]  NVARCHAR (MAX) NULL,
    [ClaimValue] NVARCHAR (MAX) NULL,
    [RoleId]     NVARCHAR (128) NOT NULL,
    CONSTRAINT [PK_AspNetRoleClaims] PRIMARY KEY CLUSTERED ([Id] ASC)
);
GO


PRINT N'Creating [dbo].[AspNetRoleClaims].[IX_AspNetRoleClaims_RoleId]...';
GO
CREATE NONCLUSTERED INDEX [IX_AspNetRoleClaims_RoleId]
    ON [dbo].[AspNetRoleClaims]([RoleId] ASC);
GO


PRINT N'Creating [dbo].[AspNetUserTokens]...';
GO
CREATE TABLE [dbo].[AspNetUserTokens] (
    [UserId]        NVARCHAR (128) NOT NULL,
    [LoginProvider] NVARCHAR (128) NOT NULL,
    [Name]          NVARCHAR (450) NOT NULL,
    [Value]         NVARCHAR (MAX) NULL,
    CONSTRAINT [PK_AspNetUserTokens] PRIMARY KEY CLUSTERED ([UserId] ASC, [LoginProvider] ASC, [Name] ASC)
);
GO


PRINT N'Creating [dbo].[FK_AspNetUserClaims_AspNetUsers_UserId]...';
GO
ALTER TABLE [dbo].[AspNetUserClaims] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO

PRINT N'Creating [dbo].[FK_AspNetUserLogins_AspNetUsers_UserId]...';
GO


ALTER TABLE [dbo].[AspNetUserLogins] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO


PRINT N'Creating [dbo].[FK_AspNetUserRoles_AspNetRoles_RoleId]...';
GO
ALTER TABLE [dbo].[AspNetUserRoles] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE;
GO


PRINT N'Creating [dbo].[FK_AspNetUserRoles_AspNetUsers_UserId]...';
GO
ALTER TABLE [dbo].[AspNetUserRoles] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId] FOREIGN KEY ([UserId]) REFERENCES [dbo].[AspNetUsers] ([Id]) ON DELETE CASCADE;
GO


PRINT N'Creating [dbo].[FK_AspNetRoleClaims_AspNetRoles_RoleId]...';
GO
ALTER TABLE [dbo].[AspNetRoleClaims] WITH NOCHECK
    ADD CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId] FOREIGN KEY ([RoleId]) REFERENCES [dbo].[AspNetRoles] ([Id]) ON DELETE CASCADE;
GO


PRINT N'Checking existing data against newly created constraints';
GO
ALTER TABLE [dbo].[AspNetUserClaims] WITH CHECK CHECK CONSTRAINT [FK_AspNetUserClaims_AspNetUsers_UserId];

ALTER TABLE [dbo].[AspNetUserLogins] WITH CHECK CHECK CONSTRAINT [FK_AspNetUserLogins_AspNetUsers_UserId];

ALTER TABLE [dbo].[AspNetUserRoles] WITH CHECK CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetRoles_RoleId];

ALTER TABLE [dbo].[AspNetUserRoles] WITH CHECK CHECK CONSTRAINT [FK_AspNetUserRoles_AspNetUsers_UserId];

ALTER TABLE [dbo].[AspNetRoleClaims] WITH CHECK CHECK CONSTRAINT [FK_AspNetRoleClaims_AspNetRoles_RoleId];


GO
PRINT N'Update complete.';


GO
