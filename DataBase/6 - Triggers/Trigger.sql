CREATE TRIGGER trg_Permissions_Audit
ON Permissions
AFTER INSERT, UPDATE
AS
BEGIN
    SET NOCOUNT ON;
    
    --  ”ÃÌ· «·≈÷«›…  ·ﬁ«∆Ì«
    IF EXISTS (SELECT 1 FROM inserted) AND NOT EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO AuditLogs (UserID, TableName, RecordID, ActionType, NewValues, Notes)
        SELECT 1, 'Permissions', CAST(i.PermissionID AS NVARCHAR(100)), 'INSERT',
               CONCAT('Name: ', i.PermissionName, ' | Code: ', i.PermissionCode),
               N'≈÷«›… ’·«ÕÌ… ÃœÌœ…'
        FROM inserted i;
    END

    --  ”ÃÌ· «· ⁄œÌ·  ·ﬁ«∆Ì«
    IF EXISTS (SELECT 1 FROM inserted) AND EXISTS (SELECT 1 FROM deleted)
    BEGIN
        INSERT INTO AuditLogs (UserID, TableName, RecordID, ActionType, OldValues, NewValues, Notes)
        SELECT 1, 'Permissions', CAST(i.PermissionID AS NVARCHAR(100)), 'UPDATE',
               CONCAT('Name: ', d.PermissionName, ' | Code: ', d.PermissionCode),
               CONCAT('Name: ', i.PermissionName, ' | Code: ', i.PermissionCode),
               N' ⁄œÌ· »Ì«‰«  ’·«ÕÌ…'
        FROM inserted i
        INNER JOIN deleted d ON i.PermissionID = d.PermissionID;
    END
END;
GO




-- 3. Trigger «· œﬁÌﬁ «·√„‰Ì ⁄·Ï ÃœÊ· Roles
CREATE OR ALTER TRIGGER [dbo].[trg_Roles_Audit]
ON [dbo].[Roles]
AFTER INSERT, UPDATE, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentUserID INT = ISNULL(TRY_CAST(SESSION_CONTEXT(N'CurrentUserID') AS INT), 1);

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE UserID = @CurrentUserID)
        RETURN;

    IF EXISTS (SELECT * FROM inserted) AND EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO [dbo].[AuditLogs] (UserID, TableName, RecordID, ActionType, OldValues, NewValues)
        SELECT 
            @CurrentUserID, 'Roles', CAST(i.RoleID AS VARCHAR(100)), 'UPDATE',
            CONCAT(N'RoleName: ', d.RoleName, N' | IsActive: ', d.IsActive),
            CONCAT(N'RoleName: ', i.RoleName, N' | IsActive: ', i.IsActive)
        FROM inserted i
        INNER JOIN deleted d ON i.RoleID = d.RoleID;
    END
    ELSE IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO [dbo].[AuditLogs] (UserID, TableName, RecordID, ActionType, NewValues)
        SELECT 
            @CurrentUserID, 'Roles', CAST(RoleID AS VARCHAR(100)), 'INSERT',
            CONCAT(N'RoleName: ', RoleName, N' | IsActive: ', IsActive)
        FROM inserted;
    END
    ELSE
    BEGIN
        INSERT INTO [dbo].[AuditLogs] (UserID, TableName, RecordID, ActionType, OldValues)
        SELECT 
            @CurrentUserID, 'Roles', CAST(RoleID AS VARCHAR(100)), 'DELETE',
            CONCAT(N'RoleName: ', RoleName)
        FROM deleted;
    END
END
GO

-- 4. Trigger «· œﬁÌﬁ «·√„‰Ì ⁄·Ï ÃœÊ· RolePermissions
CREATE OR ALTER TRIGGER [dbo].[trg_RolePermissions_Audit]
ON [dbo].[RolePermissions]
AFTER INSERT, DELETE
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @CurrentUserID INT = ISNULL(TRY_CAST(SESSION_CONTEXT(N'CurrentUserID') AS INT), 1);

    IF NOT EXISTS (SELECT 1 FROM [dbo].[Users] WHERE UserID = @CurrentUserID)
        RETURN;

    IF EXISTS (SELECT * FROM inserted)
    BEGIN
        INSERT INTO [dbo].[AuditLogs] (UserID, TableName, RecordID, ActionType, NewValues)
        SELECT 
            @CurrentUserID, 'RolePermissions', CAST(RolePermissionID AS VARCHAR(100)), 'INSERT',
            CONCAT(N'RoleID: ', RoleID, N' | PermissionID: ', PermissionID)
        FROM inserted;
    END

    IF EXISTS (SELECT * FROM deleted)
    BEGIN
        INSERT INTO [dbo].[AuditLogs] (UserID, TableName, RecordID, ActionType, OldValues)
        SELECT 
            @CurrentUserID, 'RolePermissions', CAST(RolePermissionID AS VARCHAR(100)), 'DELETE',
            CONCAT(N'RoleID: ', RoleID, N' | PermissionID: ', PermissionID)
        FROM deleted;
    END
END
GO