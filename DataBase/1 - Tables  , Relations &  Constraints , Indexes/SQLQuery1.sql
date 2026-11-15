-- ============================================================================
-- ‰Ÿ«„ ≈œ«—… «·ﬁ«⁄«  Ê«·„‰«”»«  - Venue Master Pro
-- «·”ﬂ—»  «·ﬂ«„· ·≈‰‘«¡ ﬁ«⁄œ… «·»Ì«‰« ° «·Ãœ«Ê·° «·⁄·«ﬁ« ° «·ﬁÌÊœ° Ê«·›Â«—”
-- «·‰”Œ… «·„ÕœÀ… Ê«·„⁄ „œ… (v1.0)
-- ============================================================================

--CREATE DATABASE VenueMasterProDB;
GO

USE VenueMasterProDB;


-- ============================================================================
-- «·ﬁ”„ «·√Ê·: ≈‰‘«¡ «·Ãœ«Ê· «·√”«”Ì… Ê«·„” ﬁ·… (Master & Catalog Tables)
-- ============================================================================

-- 1. «·√œÊ«— «·ÊŸÌ›Ì…

CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

-- 2. «·’·«ÕÌ«  «· ›’Ì·Ì…
CREATE TABLE Permissions (
    PermissionID INT IDENTITY(1,1) PRIMARY KEY,
    PermissionName NVARCHAR(100) NOT NULL UNIQUE,
    PermissionCode VARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);


-- 3. «·„ÊŸ›Ê‰ Ê«·⁄„«·
CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    SecondName NVARCHAR(50) NOT NULL,
    ThirdName NVARCHAR(50) NULL, --  „ Ã⁄·Â «Œ Ì«—Ì (NULL)
    LastName NVARCHAR(50) NOT NULL,
    JobTitle NVARCHAR(100) NOT NULL,
    Department NVARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    BaseSalary DECIMAL(18,2) NOT NULL DEFAULT 0,
    HireDate DATE NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT CHK_Employees_BaseSalary CHECK (BaseSalary >= 0)
);

-- 4. «·⁄„·«¡
CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    SecondName NVARCHAR(50) NOT NULL,
    ThirdName NVARCHAR(50) NULL, --  „ Ã⁄·Â «Œ Ì«—Ì (NULL)
    LastName NVARCHAR(50) NOT NULL,
    IdentityNumber VARCHAR(50) NULL,
    Phone VARCHAR(20) NOT NULL,
    Address NVARCHAR(255) NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE()
);
-- 5. «·ﬁ«⁄« 
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


-- 6. √‰Ê«⁄ «·„‰«”»« 
CREATE TABLE EventTypes (
    EventTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(MAX) NULL
);

-- 7. Õ«·«  «·ÕÃ“
CREATE TABLE BookingStatuses (
    StatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(MAX) NULL
);


-- 8. √‰„«ÿ «·›—‘ Ê«· ‰”Ìﬁ «·⁄«„… Ê«·ﬂÊ‘
CREATE TABLE DecorationStyles (
    DecorationStyleID INT IDENTITY(1,1) PRIMARY KEY,
    StyleName NVARCHAR(100) NOT NULL UNIQUE,
    DefaultPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    Description NVARCHAR(MAX) NULL,
    CONSTRAINT CHK_DecorationStyles_Cost CHECK (AdditionalCost >= 0)
);



-- ==========================================
-- 9. «·√’Ê· Ê«· ÃÂÌ“«  (Assets)
-- ==========================================
CREATE TABLE Assets (
    AssetID INT IDENTITY(1,1) PRIMARY KEY,      -- «·„› «Õ «·√”«”Ì ··√’·
    AssetName NVARCHAR(100) NOT NULL,           -- «”„ «·√’· (ﬂ—«”Ì° ÿ«Ê·« ° „›«—‘° „œ«ﬂÌ...)
    TotalQuantity INT NOT NULL,                 -- «·ﬂ„Ì… «·ﬂ·Ì… «·„ «Õ… ›Ì „” Êœ⁄ «·ﬁ«⁄…
    Notes NVARCHAR(MAX) NULL,                   -- „·«ÕŸ«  ÕÊ· Õ«·… «·„Œ“Ê‰
    CONSTRAINT CHK_Assets_TotalQuantity CHECK (TotalQuantity >= 0)
);

-- ==========================================
-- 10. «·Œœ„«  «·≈÷«›Ì… (Services)
-- ==========================================
CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,    -- «·„› «Õ «·√”«”Ì ··Œœ„…
    ServiceName NVARCHAR(100) NOT NULL,         -- «”„ «·Œœ„… (œÌ ÃÌ° ÷Ì«›…°  ’ÊÌ—...)
    DefaultPrice DECIMAL(18,2) NOT NULL,        -- «·”⁄— «·«› —«÷Ì «·„⁄ „œ
    IsAvailable BIT NOT NULL DEFAULT 1,         -- Â· «·Œœ„… „ «Õ… ··ÿ·» Õ«·Ì«ø
    CONSTRAINT CHK_Services_DefaultPrice CHECK (DefaultPrice >= 0)
);

-- ==========================================
-- 11. √‰Ê«⁄ «·œ›⁄«  «·„«·Ì… (PaymentTypes)
-- ==========================================
CREATE TABLE PaymentTypes (
    PaymentTypeID INT IDENTITY(1,1) PRIMARY KEY, -- «·„› «Õ «·√”«”Ì
    PaymentTypeName NVARCHAR(50) NOT NULL UNIQUE, -- «”„ «·‰Ê⁄ (⁄—»Ê‰° œ›⁄… ÕÃ“°  ”ÊÌ…  ·›Ì« ...)
    Description NVARCHAR(255) NULL              -- ‘—Õ  ›’Ì·Ì
);

-- ==========================================
-- 12. ÿ—ﬁ «·œ›⁄ (PaymentMethods)
-- ==========================================
CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY, -- «·„› «Õ «·√”«”Ì
    PaymentMethodName NVARCHAR(50) NOT NULL UNIQUE, -- «”„ «·ÿ—Ìﬁ… (‰ﬁœ« ﬂ«‘°  ÕÊÌ· »‰ﬂÌ...)
    Description NVARCHAR(255) NULL              -- „·«ÕŸ« 
);