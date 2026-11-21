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