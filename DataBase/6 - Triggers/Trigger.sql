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