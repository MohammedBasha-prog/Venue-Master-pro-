CREATE VIEW vw_PermissionsDetails
AS
SELECT 
    p.PermissionID,
    p.PermissionName,
    p.PermissionCode,
    p.Description,
    p.IsActive,
    CASE WHEN p.IsActive = 1 THEN N'ункс' ELSE N'укис' END AS StatusText,
    COUNT(rp.RoleID) AS AssignedRolesCount
FROM Permissions p
LEFT JOIN RolePermissions rp ON p.PermissionID = rp.PermissionID
GROUP BY p.PermissionID, p.PermissionName, p.PermissionCode, p.Description, p.IsActive;
GO





------------------- roles 
CREATE VIEW [dbo].[vw_RolesDetails]
AS
SELECT 
    R.RoleID,
    R.RoleName,
    R.Description,
    R.IsActive,
    CASE WHEN R.IsActive = 1 THEN N'ункс' ELSE N'укис' END AS StatusText,
    (SELECT COUNT(*) FROM [dbo].[RolePermissions] RP WHERE RP.RoleID = R.RoleID) AS PermissionsCount,
    (SELECT COUNT(*) FROM [dbo].[Users] U WHERE U.RoleID = R.RoleID) AS UsersCount
FROM [dbo].[Roles] R;
GO