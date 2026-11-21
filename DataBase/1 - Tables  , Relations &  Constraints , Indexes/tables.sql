-- ============================================================================
-- ‰Ÿ«„ ≈œ«—… «·ﬁ«⁄«  Ê«·„‰«”»«  - Venue Master Pro
-- «·‰”Œ… «·‰Â«∆Ì… «·‘«„·… (Enterprise-Grade) »œÊ‰  ⁄·Ìﬁ« 
-- ============================================================================

CREATE DATABASE VenueMasterProDB;
GO

USE VenueMasterProDB;
GO

-- ============================================================================
-- «·ﬁ”„ «·√Ê·: ≈‰‘«¡ «·Ãœ«Ê· «·√”«”Ì… Ê«·„” ﬁ·… (Master & Catalog Tables)
-- ============================================================================

CREATE TABLE Roles (
    RoleID INT IDENTITY(1,1) PRIMARY KEY,
    RoleName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE Permissions (
    PermissionID INT IDENTITY(1,1) PRIMARY KEY,
    PermissionName NVARCHAR(100) NOT NULL UNIQUE,
    PermissionCode VARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL,
    IsActive BIT NOT NULL DEFAULT 1
);

CREATE TABLE Employees (
    EmployeeID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    SecondName NVARCHAR(50) NOT NULL,
    ThirdName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NOT NULL,
    JobTitle NVARCHAR(100) NOT NULL,
    Department NVARCHAR(100) NOT NULL,
    Phone VARCHAR(20) NOT NULL,
    BaseSalary DECIMAL(18,2) NOT NULL DEFAULT 0,
    HireDate DATE NOT NULL DEFAULT GETDATE(),
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT CHK_Employees_BaseSalary CHECK (BaseSalary >= 0)
);

CREATE TABLE Customers (
    CustomerID INT IDENTITY(1,1) PRIMARY KEY,
    FirstName NVARCHAR(50) NOT NULL,
    SecondName NVARCHAR(50) NOT NULL,
    ThirdName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NOT NULL,
    IdentityNumber VARCHAR(50) NULL,
    Phone VARCHAR(20) NOT NULL,
    Address NVARCHAR(255) NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE()
);

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

CREATE TABLE EventTypes (
    EventTypeID INT IDENTITY(1,1) PRIMARY KEY,
    TypeName NVARCHAR(100) NOT NULL UNIQUE,
    Description NVARCHAR(MAX) NULL
);

CREATE TABLE BookingStatuses (
    StatusID INT IDENTITY(1,1) PRIMARY KEY,
    StatusName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(MAX) NULL
);

CREATE TABLE DecorationStyles (
    DecorationStyleID INT IDENTITY(1,1) PRIMARY KEY,
    StyleName NVARCHAR(100) NOT NULL UNIQUE,
    DefaultPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    Description NVARCHAR(MAX) NULL,
    CONSTRAINT CHK_DecorationStyles_Price CHECK (DefaultPrice >= 0)
);

CREATE TABLE Assets (
    AssetID INT IDENTITY(1,1) PRIMARY KEY,
    AssetName NVARCHAR(100) NOT NULL,
    TotalQuantity INT NOT NULL,
    Notes NVARCHAR(MAX) NULL,
    CONSTRAINT CHK_Assets_TotalQuantity CHECK (TotalQuantity >= 0)
);

CREATE TABLE Services (
    ServiceID INT IDENTITY(1,1) PRIMARY KEY,
    ServiceName NVARCHAR(100) NOT NULL,
    DefaultPrice DECIMAL(18,2) NOT NULL,
    IsAvailable BIT NOT NULL DEFAULT 1,
    CONSTRAINT CHK_Services_DefaultPrice CHECK (DefaultPrice >= 0)
);

CREATE TABLE PaymentTypes (
    PaymentTypeID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentTypeName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL
);

CREATE TABLE PaymentMethods (
    PaymentMethodID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentMethodName NVARCHAR(50) NOT NULL UNIQUE,
    Description NVARCHAR(255) NULL
);


-- ============================================================================
-- «·ﬁ”„ «·À«‰Ì: ≈‰‘«¡ «·Ãœ«Ê· «·„⁄ „œ… Ê«· ‘€Ì·Ì… (Transactional Tables)
-- ============================================================================

CREATE TABLE Users (
    UserID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL UNIQUE,
    Username VARCHAR(50) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    RoleID INT NOT NULL,
    IsActive BIT NOT NULL DEFAULT 1,
    CONSTRAINT FK_Users_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID) ON DELETE CASCADE,
    CONSTRAINT FK_Users_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID)
);

CREATE TABLE RolePermissions (
    RolePermissionID INT IDENTITY(1,1) PRIMARY KEY,
    RoleID INT NOT NULL,
    PermissionID INT NOT NULL,
    GrantedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    CONSTRAINT FK_RolePermissions_Roles FOREIGN KEY (RoleID) REFERENCES Roles(RoleID) ON DELETE CASCADE,
    CONSTRAINT FK_RolePermissions_Permissions FOREIGN KEY (PermissionID) REFERENCES Permissions(PermissionID) ON DELETE CASCADE,
    CONSTRAINT UQ_Role_Permission UNIQUE (RoleID, PermissionID)
);

CREATE TABLE UserLoginLogs (
    LoginLogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    LoginDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    LogoutDate DATETIME2 NULL,
    IsSuccessful BIT NOT NULL,
    IPAddress VARCHAR(50) NULL,
    DeviceName NVARCHAR(150) NULL,
    Notes NVARCHAR(255) NULL,
    CONSTRAINT FK_UserLoginLogs_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT CHK_UserLoginLogs_Dates CHECK (LogoutDate IS NULL OR LogoutDate >= LoginDate)
);

CREATE TABLE Bookings (
    BookingID INT IDENTITY(1,1) PRIMARY KEY,
    CustomerID INT NOT NULL,
    HallID INT NOT NULL,
    CreatedByUserID INT NOT NULL,
    EventTypeID INT NOT NULL,
    StatusID INT NOT NULL,
    
    EventDate DATE NOT NULL,
    StartTime TIME NOT NULL,
    EndTime TIME NOT NULL,
    TotalHours DECIMAL(18,2) NOT NULL,
    HourlyRate DECIMAL(18,2) NOT NULL,
    
    RentalSubtotal DECIMAL(18,2) NOT NULL,
    DecorationSubtotal DECIMAL(18,2) NOT NULL DEFAULT 0,
    ServicesSubtotal DECIMAL(18,2) NOT NULL DEFAULT 0,
    
    InsuranceAmount DECIMAL(18,2) NULL DEFAULT 0,
    InsuranceRefundedAmount DECIMAL(18,2) NULL DEFAULT 0,
    InsuranceStatus VARCHAR(50) NULL DEFAULT 'NotRequired',
    
    CompensationTotal DECIMAL(18,2) NOT NULL DEFAULT 0,
    TotalAmount DECIMAL(18,2) NOT NULL,
    
    Notes NVARCHAR(MAX) NULL,
    CreatedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    
    CONSTRAINT FK_Bookings_Customers FOREIGN KEY (CustomerID) REFERENCES Customers(CustomerID),
    CONSTRAINT FK_Bookings_Halls FOREIGN KEY (HallID) REFERENCES Halls(HallID),
    CONSTRAINT FK_Bookings_Users FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Bookings_EventTypes FOREIGN KEY (EventTypeID) REFERENCES EventTypes(EventTypeID),
    CONSTRAINT FK_Bookings_BookingStatuses FOREIGN KEY (StatusID) REFERENCES BookingStatuses(StatusID),
    
    CONSTRAINT CHK_Bookings_TotalHours CHECK (TotalHours > 0),
    CONSTRAINT CHK_Bookings_HourlyRate CHECK (HourlyRate >= 0),
    CONSTRAINT CHK_Bookings_Subtotals CHECK (
        RentalSubtotal >= 0 AND 
        DecorationSubtotal >= 0 AND 
        ServicesSubtotal >= 0 AND 
        CompensationTotal >= 0 AND 
        TotalAmount >= 0
    ),
    CONSTRAINT CHK_Bookings_Insurance CHECK (
        (InsuranceAmount IS NULL OR InsuranceAmount >= 0) AND 
        (InsuranceRefundedAmount IS NULL OR InsuranceRefundedAmount >= 0) AND
        (InsuranceRefundedAmount <= InsuranceAmount)
    ),
    CONSTRAINT CHK_Bookings_InsuranceStatus CHECK (
        InsuranceStatus IN (
            'NotRequired', 'Held', 'PartiallyUsed', 'FullyUsed', 
            'PartiallyRefunded', 'FullyRefunded', 'Forfeited'
        )
    )
);

CREATE TABLE BookingDecorations (
    BookingDecorationID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    DecorationStyleID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    UnitPrice DECIMAL(18,2) NOT NULL,
    SubTotal AS (CAST(Quantity AS DECIMAL(18,2)) * UnitPrice) PERSISTED,
    CONSTRAINT FK_BookingDecorations_Bookings FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    CONSTRAINT FK_BookingDecorations_Styles FOREIGN KEY (DecorationStyleID) REFERENCES DecorationStyles(DecorationStyleID),
    CONSTRAINT CHK_BookingDecorations_QtyPrice CHECK (Quantity > 0 AND UnitPrice >= 0)
);

CREATE TABLE BookingCollaterals (
    CollateralID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    CollateralType NVARCHAR(50) NOT NULL,
    Description NVARCHAR(MAX) NOT NULL,
    EstimatedValue DECIMAL(18,2) NULL,
    IdentificationNumber VARCHAR(100) NULL,
    Weight DECIMAL(18,3) NULL,
    WeightUnit VARCHAR(20) NULL,
    Purity VARCHAR(50) NULL,
    ReceivedByEmployeeID INT NOT NULL,
    ReceivedDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    ReturnedByEmployeeID INT NULL,
    ReturnedDate DATETIME2 NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'Held',
    Notes NVARCHAR(MAX) NULL,
    CONSTRAINT FK_BookingCollaterals_Bookings FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    CONSTRAINT FK_BookingCollaterals_RecEmp FOREIGN KEY (ReceivedByEmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT FK_BookingCollaterals_RetEmp FOREIGN KEY (ReturnedByEmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT CHK_BookingCollaterals_Status CHECK (Status IN ('Held', 'Returned', 'Confiscated')),
    CONSTRAINT CHK_BookingCollaterals_Dates CHECK (ReturnedDate IS NULL OR ReturnedDate >= ReceivedDate),
    CONSTRAINT CHK_BookingCollaterals_Values CHECK (
        (EstimatedValue IS NULL OR EstimatedValue >= 0) AND 
        (Weight IS NULL OR Weight > 0)
    )
);

CREATE TABLE BookingAssets (
    BookingAssetID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    AssetID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    UnitPrice DECIMAL(18,2) NOT NULL DEFAULT 0,
    SubTotal AS (CAST(Quantity AS DECIMAL(18,2)) * UnitPrice) PERSISTED,
    CONSTRAINT FK_BookingAssets_Bookings FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    CONSTRAINT FK_BookingAssets_Assets FOREIGN KEY (AssetID) REFERENCES Assets(AssetID),
    CONSTRAINT CHK_BookingAssets_QtyPrice CHECK (Quantity > 0 AND UnitPrice >= 0)
);

CREATE TABLE BookingServices (
    BookingServiceID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    ServiceID INT NOT NULL,
    Quantity INT NOT NULL DEFAULT 1,
    UnitPrice DECIMAL(18,2) NOT NULL,
    SubTotal AS (CAST(Quantity AS DECIMAL(18,2)) * UnitPrice) PERSISTED,
    CONSTRAINT FK_BookingServices_Bookings FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    CONSTRAINT FK_BookingServices_Services FOREIGN KEY (ServiceID) REFERENCES Services(ServiceID),
    CONSTRAINT CHK_BookingServices_QtyPrice CHECK (Quantity > 0 AND UnitPrice >= 0)
);

CREATE TABLE DamageLogs (
    DamageID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    AssetID INT NOT NULL,
    QuantityDamaged INT NOT NULL,
    CompensationCost DECIMAL(18,2) NOT NULL,
    ReportedByUserID INT NOT NULL,
    Notes NVARCHAR(MAX) NULL,
    CONSTRAINT FK_DamageLogs_Bookings FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    CONSTRAINT FK_DamageLogs_Assets FOREIGN KEY (AssetID) REFERENCES Assets(AssetID),
    CONSTRAINT FK_DamageLogs_Users FOREIGN KEY (ReportedByUserID) REFERENCES Users(UserID),
    CONSTRAINT CHK_DamageLogs_QtyCost CHECK (QuantityDamaged > 0 AND CompensationCost >= 0)
);

CREATE TABLE Payments (
    PaymentID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    ReceivedByUserID INT NOT NULL,
    PaymentTypeID INT NOT NULL,
    PaymentMethodID INT NOT NULL,
    AmountPaid DECIMAL(18,2) NOT NULL,
    PaymentDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    ReferenceNumber VARCHAR(100) NULL,
    Notes NVARCHAR(MAX) NULL,
    CONSTRAINT FK_Payments_Bookings FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    CONSTRAINT FK_Payments_Users FOREIGN KEY (ReceivedByUserID) REFERENCES Users(UserID),
    CONSTRAINT FK_Payments_PaymentTypes FOREIGN KEY (PaymentTypeID) REFERENCES PaymentTypes(PaymentTypeID),
    CONSTRAINT FK_Payments_PaymentMethods FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID),
    CONSTRAINT CHK_Payments_AmountPaid CHECK (AmountPaid > 0)
);

CREATE TABLE PaymentRefunds (
    RefundID INT IDENTITY(1,1) PRIMARY KEY,
    PaymentID INT NOT NULL,
    BookingID INT NOT NULL,
    RefundedByUserID INT NOT NULL,
    AmountRefunded DECIMAL(18,2) NOT NULL,
    RefundDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    PaymentMethodID INT NOT NULL,
    Notes NVARCHAR(MAX) NULL,
    CONSTRAINT FK_PaymentRefunds_Payments FOREIGN KEY (PaymentID) REFERENCES Payments(PaymentID),
    CONSTRAINT FK_PaymentRefunds_Bookings FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    CONSTRAINT FK_PaymentRefunds_Users FOREIGN KEY (RefundedByUserID) REFERENCES Users(UserID),
    CONSTRAINT FK_PaymentRefunds_PaymentMethods FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID),
    CONSTRAINT CHK_PaymentRefunds_Amount CHECK (AmountRefunded > 0)
);

CREATE TABLE InsuranceRefunds (
    InsuranceRefundID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    RefundedByUserID INT NOT NULL,
    AmountRefunded DECIMAL(18,2) NOT NULL,
    RefundDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    PaymentMethodID INT NOT NULL,
    Notes NVARCHAR(MAX) NULL,
    CONSTRAINT FK_InsuranceRefunds_Bookings FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID),
    CONSTRAINT FK_InsuranceRefunds_Users FOREIGN KEY (RefundedByUserID) REFERENCES Users(UserID),
    CONSTRAINT FK_InsuranceRefunds_PaymentMethods FOREIGN KEY (PaymentMethodID) REFERENCES PaymentMethods(PaymentMethodID),
    CONSTRAINT CHK_InsuranceRefunds_Amount CHECK (AmountRefunded > 0)
);

CREATE TABLE EmployeeTransactions (
    TransactionID INT IDENTITY(1,1) PRIMARY KEY,
    EmployeeID INT NOT NULL,
    Amount DECIMAL(18,2) NOT NULL,
    TransactionType VARCHAR(50) NOT NULL,
    TransactionDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    Notes NVARCHAR(MAX) NULL,
    CreatedByUserID INT NOT NULL,
    CONSTRAINT FK_EmployeeTransactions_Employees FOREIGN KEY (EmployeeID) REFERENCES Employees(EmployeeID),
    CONSTRAINT FK_EmployeeTransactions_Users FOREIGN KEY (CreatedByUserID) REFERENCES Users(UserID),
    CONSTRAINT CHK_EmployeeTransactions_Type CHECK (TransactionType IN ('Salary', 'Advance', 'Bonus', 'Deduction')),
    CONSTRAINT CHK_EmployeeTransactions_Amount CHECK (Amount <> 0)
);

CREATE TABLE AuditLogs (
    AuditLogID INT IDENTITY(1,1) PRIMARY KEY,
    UserID INT NOT NULL,
    TableName VARCHAR(100) NOT NULL,
    RecordID VARCHAR(100) NOT NULL,
    ActionType VARCHAR(50) NOT NULL,
    OldValues NVARCHAR(MAX) NULL,
    NewValues NVARCHAR(MAX) NULL,
    ActionDate DATETIME2 NOT NULL DEFAULT GETDATE(),
    IPAddress VARCHAR(50) NULL,
    Notes NVARCHAR(MAX) NULL,
    CONSTRAINT FK_AuditLogs_Users FOREIGN KEY (UserID) REFERENCES Users(UserID),
    CONSTRAINT CHK_AuditLogs_ActionType CHECK (ActionType IN ('INSERT', 'UPDATE', 'DELETE'))
);

CREATE TABLE BookingReminders (
    ReminderID INT IDENTITY(1,1) PRIMARY KEY,
    BookingID INT NOT NULL,
    ReminderType VARCHAR(50) NOT NULL DEFAULT 'OneWeekBefore',
    ScheduledDate DATE NOT NULL,
    Status VARCHAR(50) NOT NULL DEFAULT 'Pending',
    MessageText NVARCHAR(MAX) NULL,
    SentDate DATETIME2 NULL,
    CONSTRAINT FK_BookingReminders_Bookings FOREIGN KEY (BookingID) REFERENCES Bookings(BookingID) ON DELETE CASCADE,
    CONSTRAINT CHK_BookingReminders_Status CHECK (Status IN ('Pending', 'Sent', 'Failed', 'Cancelled'))
);
GO

-- ============================================================================
-- «·ﬁ”„ «·À«·À: ≈‰‘«¡ «·›Â«—” · ”—Ì⁄ «·√œ«¡ (Performance Indexes)
-- ============================================================================

CREATE INDEX IX_Customers_Phone ON Customers(Phone);
CREATE INDEX IX_Customers_IdentityNumber ON Customers(IdentityNumber) WHERE IdentityNumber IS NOT NULL;
CREATE INDEX IX_Customers_FullName ON Customers(FirstName, LastName);

CREATE INDEX IX_Bookings_EventDate_HallID ON Bookings(EventDate, HallID);
CREATE INDEX IX_Bookings_CustomerID ON Bookings(CustomerID);
CREATE INDEX IX_Bookings_StatusID ON Bookings(StatusID);

CREATE INDEX IX_BookingDecorations_BookingID ON BookingDecorations(BookingID);
CREATE INDEX IX_BookingAssets_BookingID ON BookingAssets(BookingID);
CREATE INDEX IX_BookingServices_BookingID ON BookingServices(BookingID);
CREATE INDEX IX_BookingCollaterals_BookingID_Status ON BookingCollaterals(BookingID, Status);
CREATE INDEX IX_DamageLogs_BookingID ON DamageLogs(BookingID);

CREATE INDEX IX_Payments_BookingID_Date ON Payments(BookingID, PaymentDate);
CREATE INDEX IX_PaymentRefunds_BookingID ON PaymentRefunds(BookingID);
CREATE INDEX IX_InsuranceRefunds_BookingID ON InsuranceRefunds(BookingID);
CREATE INDEX IX_EmployeeTransactions_EmpID_Date ON EmployeeTransactions(EmployeeID, TransactionDate);

CREATE INDEX IX_BookingReminders_ScheduledDate_Status ON BookingReminders(ScheduledDate, Status);
CREATE INDEX IX_AuditLogs_TableName_RecordID ON AuditLogs(TableName, RecordID);
CREATE INDEX IX_UserLoginLogs_UserID_LoginDate ON UserLoginLogs(UserID, LoginDate);
GO