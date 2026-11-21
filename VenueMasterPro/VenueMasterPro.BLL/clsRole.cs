using System.Collections.Generic;
using System.Data;
using VenueMasterPro.DAL;

namespace VenueMasterPro.BLL
{
    public class clsRole
    {
        public enum enMode { AddNew = 0, Update = 1 }
        public enMode Mode { get; set; } = enMode.AddNew;

        public int RoleID { get; set; }
        public string RoleName { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }

        public clsRole()
        {
            RoleID = -1;
            RoleName = string.Empty;
            Description = string.Empty;
            IsActive = true;
            Mode = enMode.AddNew;
        }

        private clsRole(int roleID, string roleName, string description, bool isActive)
        {
            RoleID = roleID;
            RoleName = roleName;
            Description = description;
            IsActive = isActive;
            Mode = enMode.Update;
        }

        public static clsRole Find(int roleID)
        {
            string roleName = string.Empty;
            string description = string.Empty;
            bool isActive = false;

            if (clsRoleData.GetRoleByID(roleID, ref roleName, ref description, ref isActive))
                return new clsRole(roleID, roleName, description, isActive);

            return null;
        }

        private bool _AddNewRole()
        {
            RoleID = clsRoleData.AddNewRole(RoleName, Description, IsActive);
            return (RoleID != -1);
        }

        private bool _UpdateRole()
        {
            return clsRoleData.UpdateRole(RoleID, RoleName, Description, IsActive);
        }

        public bool Save()
        {
            switch (Mode)
            {
                case enMode.AddNew:
                    if (_AddNewRole())
                    {
                        Mode = enMode.Update;
                        return true;
                    }
                    return false;

                case enMode.Update:
                    return _UpdateRole();
            }

            return false;
        }

        public bool SaveWithPermissions(List<int> selectedPermissionIDs)
        {
            if (!Save())
                return false;

            string idsCsv = (selectedPermissionIDs != null && selectedPermissionIDs.Count > 0)
                ? string.Join(",", selectedPermissionIDs)
                : string.Empty;

            return clsRoleData.SyncRolePermissions(RoleID, idsCsv);
        }

        public static DataTable GetAllRoles(bool onlyActive = false)
        {
            return clsRoleData.GetAllRoles(onlyActive);
        }

        public static bool DeleteRole(int roleID)
        {
            return clsRoleData.DeleteRole(roleID);
        }

        public static DataTable GetPermissionsMatrix(int roleID = -1)
        {
            return clsRoleData.GetPermissionsMatrixForRole(roleID);
        }

        public static bool HasPermission(int roleID, string permissionCode)
        {
            if (roleID <= 0 || string.IsNullOrWhiteSpace(permissionCode))
                return false;

            return clsRoleData.RoleHasPermission(roleID, permissionCode);
        }
    }
}