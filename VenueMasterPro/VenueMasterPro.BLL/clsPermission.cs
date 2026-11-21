using System;
using System.Data;
using VenueMasterPro.DAL;

namespace VenueMasterPro.BLL
{
    public class clsPermission
    {
        public enum enMode { AddNew = 0, Update = 1 }
        public enMode Mode { get; set; } = enMode.AddNew;

        public int PermissionID { get; set; }
        public string PermissionName { get; set; }
        public string PermissionCode { get; set; }
        public string Description { get; set; }
        public bool IsActive { get; set; }

        // Constructor افتراضي لوضع الإضافة الجديدة
        public clsPermission()
        {
            PermissionID = -1;
            PermissionName = string.Empty;
            PermissionCode = string.Empty;
            Description = string.Empty;
            IsActive = true;
            Mode = enMode.AddNew;
        }

        // Constructor خاص لوضع التحديث بعد الجلب من قاعدة البيانات
        private clsPermission(int permissionID, string permissionName, string permissionCode, string description, bool isActive)
        {
            PermissionID = permissionID;
            PermissionName = permissionName;
            PermissionCode = permissionCode;
            Description = description;
            IsActive = isActive;
            Mode = enMode.Update;
        }

        private bool _AddNewPermission()
        {
            this.PermissionID = clsPermissionData.AddNewPermission(
                this.PermissionName,
                this.PermissionCode,
                this.Description,
                this.IsActive);

            return (this.PermissionID != -1);
        }

        private bool _UpdatePermission()
        {
            return clsPermissionData.UpdatePermission(
                this.PermissionID,
                this.PermissionName,
                this.PermissionCode,
                this.Description,
                this.IsActive);
        }

        public static clsPermission Find(int permissionID)
        {
            if (permissionID <= 0) return null;

            string permissionName = string.Empty;
            string permissionCode = string.Empty;
            string description = string.Empty;
            bool isActive = false;

            if (clsPermissionData.GetPermissionByID(permissionID, ref permissionName, ref permissionCode, ref description, ref isActive))
            {
                return new clsPermission(permissionID, permissionName, permissionCode, description, isActive);
            }

            return null;
        }

        public bool Save()
        {
            // التحقق من قواعد العمل الأساسية قبل الوصول لقاعدة البيانات
            if (string.IsNullOrWhiteSpace(PermissionName))
                throw new ArgumentException("اسم الصلاحية حقل إجباري.");

            if (string.IsNullOrWhiteSpace(PermissionCode))
                throw new ArgumentException("كود الصلاحية حقل إجباري.");

            switch (Mode)
            {
                case enMode.AddNew:
                    if (_AddNewPermission())
                    {
                        Mode = enMode.Update;
                        return true;
                    }
                    return false;

                case enMode.Update:
                    return _UpdatePermission();

                default:
                    return false;
            }
        }

        public static bool DeletePermission(int permissionID)
        {
            if (permissionID <= 0) return false;
            return clsPermissionData.DeletePermission(permissionID);
        }

        public static DataTable GetAllPermissions(bool onlyActive = false)
        {
            return clsPermissionData.GetAllPermissions(onlyActive);
        }
    }
}