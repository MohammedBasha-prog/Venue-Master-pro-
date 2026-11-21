using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace VenueMasterPro.DAL
{
    public class clsRoleData
    {
        public static DataTable GetAllRoles(bool onlyActive = false)
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_Roles_GetAll", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@OnlyActive", SqlDbType.Bit).Value = onlyActive;

                try
                {
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.HasRows)
                            dt.Load(reader);
                    }
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(GetAllRoles));
                    throw;
                }
            }
            return dt;
        }

        public static bool GetRoleByID(int roleID, ref string roleName, ref string description, ref bool isActive)
        {
            bool isFound = false;
            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_Roles_GetById", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@RoleID", SqlDbType.Int).Value = roleID;

                try
                {
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            isFound = true;
                            roleName = reader["RoleName"].ToString();
                            description = reader["Description"] != DBNull.Value ? reader["Description"].ToString() : string.Empty;
                            isActive = Convert.ToBoolean(reader["IsActive"]);
                        }
                    }
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(GetRoleByID));
                    isFound = false;
                }
            }
            return isFound;
        }

        public static int AddNewRole(string roleName, string description, bool isActive)
        {
            int newRoleID = -1;

            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_Roles_Insert", connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@RoleName", SqlDbType.NVarChar, 100).Value = roleName;
                command.Parameters.Add("@Description", SqlDbType.NVarChar, 250).Value =
                    string.IsNullOrWhiteSpace(description) ? (object)DBNull.Value : description.Trim();
                command.Parameters.Add("@IsActive", SqlDbType.Bit).Value = isActive;

                SqlParameter outputIdParam = new SqlParameter("@NewRoleID", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };
                command.Parameters.Add(outputIdParam);

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();

                    if (outputIdParam.Value != null && outputIdParam.Value != DBNull.Value)
                        newRoleID = Convert.ToInt32(outputIdParam.Value);
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(AddNewRole));
                    throw;
                }
            }
            return newRoleID;
        }

        public static bool UpdateRole(int roleID, string roleName, string description, bool isActive)
        {
            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_Roles_Update", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@RoleID", SqlDbType.Int).Value = roleID;
                command.Parameters.Add("@RoleName", SqlDbType.NVarChar, 100).Value = roleName;
                command.Parameters.Add("@Description", SqlDbType.NVarChar, 250).Value =
                    string.IsNullOrWhiteSpace(description) ? (object)DBNull.Value : description.Trim();
                command.Parameters.Add("@IsActive", SqlDbType.Bit).Value = isActive;

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    return true;
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(UpdateRole));
                    throw;
                }
            }
        }

        public static bool DeleteRole(int roleID)
        {
            int rowsAffected = 0;

            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_Roles_Delete", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@RoleID", SqlDbType.Int).Value = roleID;

                try
                {
                    connection.Open();
                    // sp_Roles_Delete يرجع SELECT @Affected AS RowsAffected
                    object result = command.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                        rowsAffected = Convert.ToInt32(result);
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(DeleteRole));
                    throw;
                }
            }
            return rowsAffected > 0;
        }

        // ================= صلاحيات الدور (RolePermissions) =================

        public static DataTable GetPermissionsMatrixForRole(int roleID)
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_RolePermissions_GetByRoleID", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@RoleID", SqlDbType.Int).Value = roleID;

                try
                {
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.HasRows)
                            dt.Load(reader);
                    }
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(GetPermissionsMatrixForRole));
                    throw;
                }
            }
            return dt;
        }

        public static bool SyncRolePermissions(int roleID, string commaSeparatedPermissionIDs)
        {
            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_RolePermissions_SyncForRole", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@RoleID", SqlDbType.Int).Value = roleID;
                command.Parameters.Add("@PermissionIDs", SqlDbType.NVarChar, -1).Value =
                    string.IsNullOrWhiteSpace(commaSeparatedPermissionIDs) ? (object)DBNull.Value : commaSeparatedPermissionIDs.Trim();

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    return true;
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(SyncRolePermissions));
                    throw;
                }
            }
        }

        public static bool RoleHasPermission(int roleID, string permissionCode)
        {
            bool hasPermission = false;

            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("SELECT dbo.fn_RoleHasPermission(@RoleID, @PermissionCode)", connection))
            {
                command.CommandType = CommandType.Text;
                command.Parameters.Add("@RoleID", SqlDbType.Int).Value = roleID;
                command.Parameters.Add("@PermissionCode", SqlDbType.NVarChar, 100).Value = permissionCode;

                try
                {
                    connection.Open();
                    object result = command.ExecuteScalar();
                    if (result != null && result != DBNull.Value)
                        hasPermission = Convert.ToBoolean(result);
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(RoleHasPermission));
                    throw;
                }
            }
            return hasPermission;
        }
    }
}