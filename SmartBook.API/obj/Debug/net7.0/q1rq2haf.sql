IF OBJECT_ID(N'[__EFMigrationsHistory]') IS NULL
BEGIN
    CREATE TABLE [__EFMigrationsHistory] (
        [MigrationId] nvarchar(150) NOT NULL,
        [ProductVersion] nvarchar(32) NOT NULL,
        CONSTRAINT [PK___EFMigrationsHistory] PRIMARY KEY ([MigrationId])
    );
END;
GO

BEGIN TRANSACTION;
GO

CREATE TABLE [Accounts] (
    [AccountID] int NOT NULL IDENTITY,
    [AccountCode] nvarchar(20) NULL,
    [AccountNameAr] nvarchar(200) NULL,
    [AccountNameEn] nvarchar(200) NULL,
    [ParentAccountID] int NULL,
    [AccountType] int NOT NULL,
    [Level] int NULL DEFAULT 1,
    [IsMain] bit NULL DEFAULT CAST(0 AS bit),
    [IsActive] bit NOT NULL DEFAULT CAST(1 AS bit),
    [CreatedAt] datetime NOT NULL DEFAULT ((getdate())),
    CONSTRAINT [PK_Accounts] PRIMARY KEY ([AccountID]),
    CONSTRAINT [FK_Accounts_Accounts_ParentAccountID] FOREIGN KEY ([ParentAccountID]) REFERENCES [Accounts] ([AccountID])
);
GO

CREATE TABLE [Adjustments] (
    [Id] nvarchar(450) NOT NULL,
    [Description] nvarchar(255) NOT NULL,
    [Amount] decimal(18,2) NOT NULL,
    [Date] datetime2 NOT NULL,
    [Type] int NOT NULL,
    [CreatedAt] datetime2 NOT NULL,
    CONSTRAINT [PK_Adjustments] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [CompanyProfile] (
    [ID] int NOT NULL IDENTITY,
    [NameAr] nvarchar(250) NULL,
    [NameEn] nvarchar(250) NULL,
    [TaxNumber] nvarchar(15) NULL,
    [Address] nvarchar(max) NULL,
    [Phone] nvarchar(20) NULL,
    [Email] nvarchar(100) NULL,
    [LogoPath] nvarchar(max) NULL,
    [Currency] nvarchar(50) NULL DEFAULT ((N'ر.س')),
    [CreatedAt] datetime NULL DEFAULT ((getdate())),
    CONSTRAINT [PK_CompanyProfile] PRIMARY KEY ([ID])
);
GO

CREATE TABLE [CompanySetting] (
    [Id] int NOT NULL IDENTITY,
    [CompanyName] nvarchar(max) NULL,
    [Currency] nvarchar(max) NULL,
    [FiscalYearStart] datetime2 NOT NULL,
    [FiscalYearEnd] datetime2 NOT NULL,
    CONSTRAINT [PK_CompanySetting] PRIMARY KEY ([Id])
);
GO

CREATE TABLE [JournalEntries] (
    [EntryID] int NOT NULL IDENTITY,
    [EntryDate] datetime NULL DEFAULT ((getdate())),
    [ReferenceNo] nvarchar(50) NULL,
    [Description] nvarchar(max) NULL,
    [CreatedAt] datetime NULL DEFAULT ((getdate())),
    [JournalStatus] nvarchar(max) NULL,
    CONSTRAINT [PK_JournalEntries] PRIMARY KEY ([EntryID])
);
GO

CREATE TABLE [Products] (
    [ProductId] int NOT NULL IDENTITY,
    [ProductNameAr] nvarchar(200) NOT NULL,
    [Barcode] nvarchar(max) NULL,
    [TotalStockQuantity] decimal(18,3) NOT NULL,
    [CostPrice] decimal(18,2) NOT NULL,
    [SellingPrice] decimal(18,2) NOT NULL,
    CONSTRAINT [PK_Products] PRIMARY KEY ([ProductId])
);
GO

CREATE TABLE [Roles] (
    [RoleID] int NOT NULL IDENTITY,
    [RoleName] nvarchar(50) NULL,
    CONSTRAINT [PK_Roles] PRIMARY KEY ([RoleID])
);
GO

CREATE TABLE [AccountMappings] (
    [Id] int NOT NULL IDENTITY,
    [MovementType] nvarchar(50) NOT NULL,
    [AccountId] int NOT NULL,
    [Description] nvarchar(200) NULL,
    CONSTRAINT [PK_AccountMappings] PRIMARY KEY ([Id]),
    CONSTRAINT [FK_AccountMappings_Accounts_AccountId] FOREIGN KEY ([AccountId]) REFERENCES [Accounts] ([AccountID]) ON DELETE NO ACTION
);
GO

CREATE TABLE [Contacts] (
    [ContactID] int NOT NULL IDENTITY,
    [Name] nvarchar(200) NULL,
    [ContactType] nvarchar(20) NULL,
    [TaxNumber] nvarchar(15) NULL,
    [Phone] nvarchar(20) NULL,
    [Email] nvarchar(100) NULL,
    [Address] nvarchar(max) NULL,
    [AccountID] int NULL,
    [CreatedAt] datetime NULL DEFAULT ((getdate())),
    [OpeningBalance] decimal(18,2) NOT NULL,
    [CurrentBalance] decimal(18,2) NOT NULL,
    CONSTRAINT [PK_Contacts] PRIMARY KEY ([ContactID]),
    CONSTRAINT [FK_Contacts_Accounts_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Accounts] ([AccountID])
);
GO

CREATE TABLE [JournalDetails] (
    [DetailID] int NOT NULL IDENTITY,
    [EntryID] int NULL,
    [AccountID] int NULL,
    [Debit] decimal(18,2) NULL DEFAULT 0.0,
    [Credit] decimal(18,2) NULL DEFAULT 0.0,
    [Description] nvarchar(max) NULL,
    CONSTRAINT [PK_JournalDetails] PRIMARY KEY ([DetailID]),
    CONSTRAINT [FK_JournalDetails_Accounts_AccountID] FOREIGN KEY ([AccountID]) REFERENCES [Accounts] ([AccountID]),
    CONSTRAINT [FK_JournalDetails_JournalEntries_EntryID] FOREIGN KEY ([EntryID]) REFERENCES [JournalEntries] ([EntryID])
);
GO

CREATE TABLE [InventoryLogs] (
    [LogId] int NOT NULL IDENTITY,
    [ProductId] int NOT NULL,
    [OldStock] decimal(18,2) NOT NULL,
    [NewStock] decimal(18,2) NOT NULL,
    [Note] nvarchar(500) NULL,
    [CreatedAt] datetime2 NOT NULL,
    CONSTRAINT [PK_InventoryLogs] PRIMARY KEY ([LogId]),
    CONSTRAINT [FK_InventoryLogs_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]) ON DELETE CASCADE
);
GO

CREATE TABLE [ProductUnits] (
    [UnitId] int NOT NULL IDENTITY,
    [UnitName] nvarchar(50) NOT NULL,
    [SalePrice] decimal(18,2) NOT NULL,
    [PurchasePrice] decimal(18,2) NOT NULL,
    [ConversionFactor] decimal(18,3) NOT NULL,
    [IsBaseUnit] bit NOT NULL,
    [ProductId] int NOT NULL,
    CONSTRAINT [PK_ProductUnits] PRIMARY KEY ([UnitId]),
    CONSTRAINT [FK_ProductUnits_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]) ON DELETE CASCADE
);
GO

CREATE TABLE [Users] (
    [UserID] int NOT NULL IDENTITY,
    [FullName] nvarchar(150) NULL,
    [Username] nvarchar(50) NULL,
    [PasswordHash] nvarchar(max) NULL,
    [RoleID] int NULL,
    [IsActive] bit NULL DEFAULT CAST(1 AS bit),
    [LastLogin] datetime NULL,
    [CreatedAt] datetime NULL DEFAULT ((getdate())),
    CONSTRAINT [PK_Users] PRIMARY KEY ([UserID]),
    CONSTRAINT [FK_Users_Roles_RoleID] FOREIGN KEY ([RoleID]) REFERENCES [Roles] ([RoleID])
);
GO

CREATE TABLE [Invoices] (
    [InvoiceID] int NOT NULL IDENTITY,
    [InvoiceNumber] nvarchar(50) NULL,
    [InvoiceDate] datetime NULL DEFAULT ((getdate())),
    [ContactID] int NULL,
    [SubTotal] decimal(18,2) NULL,
    [TaxAmount] decimal(18,2) NULL,
    [TotalAmount] decimal(18,2) NULL,
    [PaymentType] nvarchar(20) NULL,
    [UserID] int NULL,
    [Id] uniqueidentifier NOT NULL,
    [CustomerName] nvarchar(max) NULL,
    [Status] nvarchar(max) NULL,
    [EntryId] int NULL,
    CONSTRAINT [PK_Invoices] PRIMARY KEY ([InvoiceID]),
    CONSTRAINT [FK_Invoices_Contacts_ContactID] FOREIGN KEY ([ContactID]) REFERENCES [Contacts] ([ContactID]),
    CONSTRAINT [FK_Invoices_JournalEntries_EntryId] FOREIGN KEY ([EntryId]) REFERENCES [JournalEntries] ([EntryID]) ON DELETE SET NULL,
    CONSTRAINT [FK_Invoices_Users_UserID] FOREIGN KEY ([UserID]) REFERENCES [Users] ([UserID])
);
GO

CREATE TABLE [Vouchers] (
    [VoucherID] int NOT NULL IDENTITY,
    [VoucherNumber] nvarchar(50) NULL,
    [VoucherType] nvarchar(20) NULL,
    [VoucherDate] datetime NOT NULL DEFAULT ((getdate())),
    [TotalAmount] decimal(18,2) NOT NULL,
    [Description] nvarchar(max) NULL,
    [CreatedBy] int NULL,
    [CreatedAt] datetime NULL DEFAULT ((getdate())),
    [FromAccountId] int NULL,
    [ToAccountId] int NULL,
    [EntryID] int NULL,
    CONSTRAINT [PK_Vouchers] PRIMARY KEY ([VoucherID]),
    CONSTRAINT [FK_Vouchers_Accounts_FromAccountId] FOREIGN KEY ([FromAccountId]) REFERENCES [Accounts] ([AccountID]),
    CONSTRAINT [FK_Vouchers_Accounts_ToAccountId] FOREIGN KEY ([ToAccountId]) REFERENCES [Accounts] ([AccountID]),
    CONSTRAINT [FK_Vouchers_JournalEntries_EntryID] FOREIGN KEY ([EntryID]) REFERENCES [JournalEntries] ([EntryID]) ON DELETE SET NULL,
    CONSTRAINT [FK_Vouchers_Users_CreatedBy] FOREIGN KEY ([CreatedBy]) REFERENCES [Users] ([UserID])
);
GO

CREATE TABLE [InvoiceDetails] (
    [DetailID] int NOT NULL IDENTITY,
    [ProductId] int NOT NULL,
    [InvoiceID] int NULL,
    [ItemName] nvarchar(200) NULL,
    [Quantity] decimal(18,2) NULL,
    [UnitPrice] decimal(18,2) NULL,
    [TaxAmount] decimal(18,2) NULL,
    [TotalLine] decimal(18,2) NULL,
    CONSTRAINT [PK_InvoiceDetails] PRIMARY KEY ([DetailID]),
    CONSTRAINT [FK_InvoiceDetails_Invoices_InvoiceID] FOREIGN KEY ([InvoiceID]) REFERENCES [Invoices] ([InvoiceID]),
    CONSTRAINT [FK_InvoiceDetails_Products_ProductId] FOREIGN KEY ([ProductId]) REFERENCES [Products] ([ProductId]) ON DELETE CASCADE
);
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'AccountID', N'AccountCode', N'AccountNameAr', N'AccountNameEn', N'AccountType', N'CreatedAt', N'IsActive', N'IsMain', N'ParentAccountID') AND [object_id] = OBJECT_ID(N'[Accounts]'))
    SET IDENTITY_INSERT [Accounts] ON;
INSERT INTO [Accounts] ([AccountID], [AccountCode], [AccountNameAr], [AccountNameEn], [AccountType], [CreatedAt], [IsActive], [IsMain], [ParentAccountID])
VALUES (1, N'1001', N'الصندوق', N'Cash', 1, '2026-07-13T14:13:05.112', CAST(1 AS bit), CAST(1 AS bit), NULL),
(2, N'1002', N'البنك', N'Bank', 1, '2026-07-13T14:13:05.112', CAST(1 AS bit), CAST(1 AS bit), NULL),
(3, N'2001', N'رأس المال', N'Capital', 3, '2026-07-13T14:13:05.112', CAST(1 AS bit), CAST(1 AS bit), NULL),
(4, N'3001', N'المبيعات', N'Sales', 4, '2026-07-13T14:13:05.112', CAST(1 AS bit), CAST(1 AS bit), NULL);
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'AccountID', N'AccountCode', N'AccountNameAr', N'AccountNameEn', N'AccountType', N'CreatedAt', N'IsActive', N'IsMain', N'ParentAccountID') AND [object_id] = OBJECT_ID(N'[Accounts]'))
    SET IDENTITY_INSERT [Accounts] OFF;
GO

IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CompanyName', N'Currency', N'FiscalYearEnd', N'FiscalYearStart') AND [object_id] = OBJECT_ID(N'[CompanySetting]'))
    SET IDENTITY_INSERT [CompanySetting] ON;
INSERT INTO [CompanySetting] ([Id], [CompanyName], [Currency], [FiscalYearEnd], [FiscalYearStart])
VALUES (1, N'شركتي الذكية للبرمجيات', N'SAR', '2026-12-31T00:00:00.0000000', '2026-01-01T00:00:00.0000000');
IF EXISTS (SELECT * FROM [sys].[identity_columns] WHERE [name] IN (N'Id', N'CompanyName', N'Currency', N'FiscalYearEnd', N'FiscalYearStart') AND [object_id] = OBJECT_ID(N'[CompanySetting]'))
    SET IDENTITY_INSERT [CompanySetting] OFF;
GO

CREATE INDEX [IX_AccountMappings_AccountId] ON [AccountMappings] ([AccountId]);
GO

CREATE UNIQUE INDEX [IX_AccountMappings_MovementType] ON [AccountMappings] ([MovementType]);
GO

CREATE UNIQUE INDEX [IX_Accounts_AccountCode] ON [Accounts] ([AccountCode]) WHERE [AccountCode] IS NOT NULL;
GO

CREATE INDEX [IX_Accounts_ParentAccountID] ON [Accounts] ([ParentAccountID]);
GO

CREATE INDEX [IX_Contacts_AccountID] ON [Contacts] ([AccountID]);
GO

CREATE INDEX [IX_InventoryLogs_ProductId] ON [InventoryLogs] ([ProductId]);
GO

CREATE INDEX [IX_InvoiceDetails_InvoiceID] ON [InvoiceDetails] ([InvoiceID]);
GO

CREATE INDEX [IX_InvoiceDetails_ProductId] ON [InvoiceDetails] ([ProductId]);
GO

CREATE INDEX [IX_Invoices_ContactID] ON [Invoices] ([ContactID]);
GO

CREATE INDEX [IX_Invoices_EntryId] ON [Invoices] ([EntryId]);
GO

CREATE UNIQUE INDEX [IX_Invoices_InvoiceNumber] ON [Invoices] ([InvoiceNumber]) WHERE [InvoiceNumber] IS NOT NULL;
GO

CREATE INDEX [IX_Invoices_UserID] ON [Invoices] ([UserID]);
GO

CREATE INDEX [IX_JournalDetails_AccountID] ON [JournalDetails] ([AccountID]);
GO

CREATE INDEX [IX_JournalDetails_EntryID] ON [JournalDetails] ([EntryID]);
GO

CREATE INDEX [IX_ProductUnits_ProductId] ON [ProductUnits] ([ProductId]);
GO

CREATE INDEX [IX_Users_RoleID] ON [Users] ([RoleID]);
GO

CREATE UNIQUE INDEX [IX_Users_Username] ON [Users] ([Username]) WHERE [Username] IS NOT NULL;
GO

CREATE INDEX [IX_Vouchers_CreatedBy] ON [Vouchers] ([CreatedBy]);
GO

CREATE INDEX [IX_Vouchers_EntryID] ON [Vouchers] ([EntryID]);
GO

CREATE INDEX [IX_Vouchers_FromAccountId] ON [Vouchers] ([FromAccountId]);
GO

CREATE INDEX [IX_Vouchers_ToAccountId] ON [Vouchers] ([ToAccountId]);
GO

INSERT INTO [__EFMigrationsHistory] ([MigrationId], [ProductVersion])
VALUES (N'20260713141305_InitialCleanState', N'7.0.20');
GO

COMMIT;
GO

