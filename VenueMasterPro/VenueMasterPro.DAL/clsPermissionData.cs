using System;
using System.Data;
using Microsoft.Data.SqlClient;

namespace VenueMasterPro.DAL
{
    public class clsPermissionData
    {
        public static DataTable GetAllPermissions(bool onlyActive = false)
        {
            DataTable dt = new DataTable();
            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_Permissions_GetAll", connection))
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
                    clsEventLogger.LogError(ex, nameof(GetAllPermissions));
                    throw;
                }
            }
            return dt;
        }

        public static bool GetPermissionByID(int permissionID, ref string permissionName,
            ref string permissionCode, ref string description, ref bool isActive)
        {
            bool isFound = false;
            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_Permissions_GetById", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@PermissionID", SqlDbType.Int).Value = permissionID;

                try
                {
                    connection.Open();
                    using (SqlDataReader reader = command.ExecuteReader())
                    {
                        if (reader.Read())
                        {
                            isFound = true;
                            permissionName = reader["PermissionName"].ToString();
                            permissionCode = reader["PermissionCode"].ToString();
                            description = reader["Description"] != DBNull.Value ? reader["Description"].ToString() : string.Empty;
                            isActive = Convert.ToBoolean(reader["IsActive"]);
                        }
                    }
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(GetPermissionByID));
                    isFound = false;
                }
            }
            return isFound;
        }

        public static int AddNewPermission(string permissionName, string permissionCode, string description, bool isActive)
        {
            int newPermissionID = -1;

            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_Permissions_Insert", connection))
            {
                command.CommandType = CommandType.StoredProcedure;

                command.Parameters.Add("@PermissionName", SqlDbType.NVarChar, 100).Value = permissionName;
                command.Parameters.Add("@PermissionCode", SqlDbType.NVarChar, 100).Value = permissionCode;
                command.Parameters.Add("@Description", SqlDbType.NVarChar, 250).Value =
                    string.IsNullOrWhiteSpace(description) ? (object)DBNull.Value : description.Trim();
                command.Parameters.Add("@IsActive", SqlDbType.Bit).Value = isActive;

                SqlParameter outputIdParam = new SqlParameter("@NewPermissionID", SqlDbType.Int)
                {
                    Direction = ParameterDirection.Output
                };
                command.Parameters.Add(outputIdParam);

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();

                    if (outputIdParam.Value != null && outputIdParam.Value != DBNull.Value)
                        newPermissionID = Convert.ToInt32(outputIdParam.Value);
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(AddNewPermission));
                    throw;
                }
            }
            return newPermissionID;
        }

        public static bool UpdatePermission(int permissionID, string permissionName, string permissionCode, string description, bool isActive)
        {
            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_Permissions_Update", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@PermissionID", SqlDbType.Int).Value = permissionID;
                command.Parameters.Add("@PermissionName", SqlDbType.NVarChar, 100).Value = permissionName;
                command.Parameters.Add("@PermissionCode", SqlDbType.NVarChar, 100).Value = permissionCode;
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
                    clsEventLogger.LogError(ex, nameof(UpdatePermission));
                    throw;
                }
            }
        }

        public static bool DeletePermission(int permissionID)
        {
            using (SqlConnection connection = new SqlConnection(clsDataAccessSettings.ConnectionString))
            using (SqlCommand command = new SqlCommand("sp_Permissions_Delete", connection))
            {
                command.CommandType = CommandType.StoredProcedure;
                command.Parameters.Add("@PermissionID", SqlDbType.Int).Value = permissionID;

                try
                {
                    connection.Open();
                    command.ExecuteNonQuery();
                    return true;
                }
                catch (Exception ex)
                {
                    clsEventLogger.LogError(ex, nameof(DeletePermission));
                    throw;
                }
            }
        }
    }
}