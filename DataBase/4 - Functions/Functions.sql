
----------Persmissions 

-- √. œ«·… «· Õﬁﬁ ⁄‰œ «·≈÷«›… «·ÃœÌœ…
CREATE FUNCTION dbo.fn_Permissions_IsExistsForInsert
(
    @PermissionCode NVARCHAR(100),
    @PermissionName NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM Permissions WHERE PermissionCode = @PermissionCode OR PermissionName = @PermissionName)
        RETURN 1;
    RETURN 0;
END;
GO

-- ». œ«·… «· Õﬁﬁ ⁄‰œ «· ÕœÌÀ ( ” À‰Ì «·”Ã· «·Õ«·Ì ·ﬂÌ ·«  ⁄ —÷ ⁄·Ï  ⁄œÌ· ‰›” «·’·«ÕÌ…)
CREATE FUNCTION dbo.fn_Permissions_IsExistsForUpdate
(
    @PermissionID INT,
    @PermissionCode NVARCHAR(100),
    @PermissionName NVARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM Permissions 
        WHERE (PermissionCode = @PermissionCode OR PermissionName = @PermissionName)
          AND PermissionID <> @PermissionID
    )
        RETURN 1;
    RETURN 0;
END;
GO



----------------------
