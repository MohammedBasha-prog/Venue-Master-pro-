
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


-- roles and rolesPermission tables 

-- 1. Scalar Function ·· Õﬁﬁ „‰ «„ ·«ﬂ «·œÊ— ·’·«ÕÌ… „⁄Ì‰…
CREATE OR ALTER FUNCTION [dbo].[fn_RoleHasPermission]
(
    @RoleID INT,
    @PermissionCode VARCHAR(100)
)
RETURNS BIT
AS
BEGIN
    DECLARE @HasPerm BIT = 0;

    IF EXISTS (
        SELECT 1
        FROM [dbo].[RolePermissions] RP
        INNER JOIN [dbo].[Permissions] P ON RP.PermissionID = P.PermissionID
        INNER JOIN [dbo].[Roles] R ON RP.RoleID = R.RoleID
        WHERE RP.RoleID = @RoleID
          AND P.PermissionCode = @PermissionCode
          AND P.IsActive = 1
          AND R.IsActive = 1
    )
        SET @HasPerm = 1;

    RETURN @HasPerm;
END
GO