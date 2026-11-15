-- ============================================================================
-- äÙÇã ÅÏÇÑÉ ÇáÞÇÚÇÊ æÇáãäÇÓÈÇÊ - Venue Master Pro
-- ÇáÓßÑÈÊ ÇáßÇãá áÅäÔÇÁ ÞÇÚÏÉ ÇáÈíÇäÇÊ¡ ÇáÌÏÇæá¡ ÇáÚáÇÞÇÊ¡ ÇáÞíæÏ¡ æÇáÝåÇÑÓ
-- ÇáäÓÎÉ ÇáãÍÏËÉ æÇáãÚÊãÏÉ (v1.0)
-- ============================================================================

--CREATE DATABASE VenueMasterProDB;
GO

USE VenueMasterProDB;


-- ============================================================================
-- ÇáÞÓã ÇáÃæá: ÅäÔÇÁ ÇáÌÏÇæá ÇáÃÓÇÓíÉ æÇáãÓÊÞáÉ (Master & Catalog Tables)
-- ============================================================================

-- 1. ÇáÃÏæÇÑ ÇáæÙíÝíÉ

CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

-- 2. ÇáÕáÇÍíÇÊ ÇáÊÝÕíáíÉ
CREATE TABLE Permissions (
    PermissionID INT IDENTITY(1,1) PRIMARY KEY,
    PermissionName NVARCHAR(100) NOT NULL UNIQUE,
    PermissionCode VARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);


-- 3. ÇáãæÙÝæä æÇáÚãÇá
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    SecondName NVARCHAR(50) NOT NULL,
    ThirdName NVARCHAR(50) NULL, -- Êã ÌÚáå ÇÎÊíÇÑí (NULL)
    LastName NVARCHAR(50) NOT NULL,
    JobTitle NVARCHAR(100) NOT NULL,
    Department NVARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    BaseSalary DECIMAL(18,2) NOT NULL DEFAULT 0,
    HireDate DATE NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT CHK_Employees_BaseSalary CHECK (BaseSalary >= 0)
);

-- 4. ÇáÚãáÇÁ
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    SecondName NVARCHAR(50) NOT NULL,
    ThirdName NVARCHAR(50) NULL, -- Êã ÌÚáå ÇÎÊíÇÑí (NULL)
    LastName NVARCHAR(50) NOT NULL,
    IdentityNumber VARCHAR(50) NULL,
    Phone VARCHAR(20) NOT NULL,
    Address NVARCHAR(255) NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE()
);
-- 5. ÇáÞÇÚÇÊ
CREATE TABLE Halls (
    HallID INT IDENTITY(1,1) PRIMARY KEY,
    HallName NVARCHAR(100) NOT NULL,
    Capacity INT NOT NULL,
    DefaultHourlyRate DECIMAL(18,2) NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    Description NVARCHAR(MAX) NULL,
    CONSTRAINT CHK_Halls_Capacity CHECK (Capacity > 0),
    CONSTRAINT CHK_Halls_HourlyRate CHECK (DefaultHourlyRate >= 0)
);


-- 6. ÃäæÇÚ ÇáãäÇÓÈÇÊ
CREATE TABLE EventTypes (
    EventTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(MAX) NULL
);

-- 7. ÍÇáÇÊ ÇáÍÌÒ
CREATE TABLE BookingStatuses (
    StatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(MAX) NULL
);


-- 8. ÃäãÇØ ÇáÝÑÔ æÇáÊäÓíÞ ÇáÚÇãÉ æÇáßæÔ
CREATE TABLE DecorationStyles (
    DecorationStyleID INT IDENTITY(1,1) PRIMARY KEY,
    StyleName NVARCHAR(100) NOT NULL UNIQUE,
    DefaultPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    Description NVARCHAR(MAX) NULL,
    CONSTRAINT CHK_DecorationStyles_Cost CHECK (AdditionalCost >= 0)
);



