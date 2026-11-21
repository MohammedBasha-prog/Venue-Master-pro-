-- =============================================
-- 1. ÇáÅÌÑÇÁÇÊ ÇáãÎÒäÉ áÌÏæá Permissions
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_Permissions_Insert]
    @PermissionName NVARCHAR(100),
    @PermissionCode NVARCHAR(100),
    @Description    NVARCHAR(250) = NULL,
    @IsActive       BIT = 1,
    @NewPermissionID INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @NewPermissionID = -1;

    BEGIN TRY
        IF dbo.fn_Permissions_IsExistsForInsert(@PermissionCode, @PermissionName) = 1
        BEGIN
            RAISERROR(N'ßæÏ ÇáÕáÇÍíÉ Ãæ ÇáÇÓã ãæÌæÏ ãÓÈÞÇð!', 16, 1);
            RETURN;
        END

        INSERT INTO [dbo].[Permissions] (PermissionName, PermissionCode, Description, IsActive)
        VALUES (@PermissionName, @PermissionCode, @Description, @IsActive);

        SET @NewPermissionID = SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_Permissions_Update]
    @PermissionID   INT,
    @PermissionName NVARCHAR(100),
    @PermissionCode NVARCHAR(100),
    @Description    NVARCHAR(250) = NULL,
    @IsActive       BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF dbo.fn_Permissions_IsExistsForUpdate(@PermissionID, @PermissionCode, @PermissionName) = 1
        BEGIN
            RAISERROR(N'ßæÏ ÇáÕáÇÍíÉ Ãæ ÇáÇÓã ãÓÊÎÏã áÕáÇÍíÉ ÃÎÑì!', 16, 1);
            RETURN;
        END

        UPDATE [dbo].[Permissions]
        SET PermissionName = @PermissionName,
            PermissionCode = @PermissionCode,
            Description    = @Description,
            IsActive       = @IsActive
        WHERE PermissionID = @PermissionID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_Permissions_Delete]
    @PermissionID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM [dbo].[RolePermissions] WHERE PermissionID = @PermissionID)
            UPDATE [dbo].[Permissions] SET IsActive = 0 WHERE PermissionID = @PermissionID;
        ELSE
            DELETE FROM [dbo].[Permissions] WHERE PermissionID = @PermissionID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_Permissions_GetById]
    @PermissionID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT * FROM [dbo].[Permissions] WHERE PermissionID = @PermissionID;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_Permissions_GetAll]
    @OnlyActive BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM [dbo].[vw_PermissionsDetails]
    WHERE (@OnlyActive = 0 OR IsActive = 1)
    ORDER BY PermissionID ASC;
END
GO

-- =============================================
-- 2. ÇáÅÌÑÇÁÇÊ ÇáãÎÒäÉ áÌÏæá Roles
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_Roles_GetAll]
    @OnlyActive BIT = 0
AS
BEGIN
    SET NOCOUNT ON;
    SELECT *
    FROM [dbo].[vw_RolesDetails]
    WHERE (@OnlyActive = 0 OR IsActive = 1)
    ORDER BY RoleID ASC;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_Roles_GetById]
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;
    SELECT RoleID, RoleName, Description, IsActive
    FROM [dbo].[Roles]
    WHERE RoleID = @RoleID;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_Roles_Insert]
    @RoleName    NVARCHAR(100),
    @Description NVARCHAR(250) = NULL,
    @IsActive    BIT = 1,
    @NewRoleID   INT OUTPUT
AS
BEGIN
    SET NOCOUNT ON;
    SET @NewRoleID = -1;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE RoleName = @RoleName)
        BEGIN
            RAISERROR(N'ÇÓã ÇáÏæÑ ÇáæÙíÝí ãÓÌá ãÓÈÞÇð Ýí ÇáäÙÇã.', 16, 1);
            RETURN;
        END

        INSERT INTO [dbo].[Roles] (RoleName, Description, IsActive)
        VALUES (@RoleName, @Description, @IsActive);

        SET @NewRoleID = SCOPE_IDENTITY();
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_Roles_Update]
    @RoleID      INT,
    @RoleName    NVARCHAR(100),
    @Description NVARCHAR(250) = NULL,
    @IsActive    BIT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        IF EXISTS (SELECT 1 FROM [dbo].[Roles] WHERE RoleName = @RoleName AND RoleID <> @RoleID)
        BEGIN
            RAISERROR(N'ÇÓã ÇáÏæÑ ÇáæÙíÝí ãÓÊÎÏã áÏæÑ ÂÎÑ.', 16, 1);
            RETURN;
        END

        UPDATE [dbo].[Roles]
        SET RoleName    = @RoleName,
            Description = @Description,
            IsActive    = @IsActive
        WHERE RoleID = @RoleID;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_Roles_Delete]
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF EXISTS (SELECT 1 FROM [dbo].[Users] WHERE RoleID = @RoleID)
        BEGIN
            ROLLBACK TRANSACTION;
            SELECT CAST(0 AS INT) AS RowsAffected;
            RETURN;
        END

        DELETE FROM [dbo].[RolePermissions] WHERE RoleID = @RoleID;

        DELETE FROM [dbo].[Roles] WHERE RoleID = @RoleID;
        DECLARE @Affected INT = @@ROWCOUNT;

        COMMIT TRANSACTION;

        SET NOCOUNT OFF;
        SELECT @Affected AS RowsAffected;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO

-- =============================================
-- 3. ÇáÅÌÑÇÁÇÊ ÇáãÎÒäÉ áÌÏæá RolePermissions
-- =============================================
CREATE OR ALTER PROCEDURE [dbo].[sp_RolePermissions_GetByRoleID]
    @RoleID INT
AS
BEGIN
    SET NOCOUNT ON;

    SELECT 
        P.PermissionID,
        P.PermissionName,
        P.PermissionCode,
        CAST(CASE WHEN RP.RolePermissionID IS NOT NULL THEN 1 ELSE 0 END AS BIT) AS IsSelected
    FROM [dbo].[Permissions] P
    LEFT JOIN [dbo].[RolePermissions] RP 
        ON P.PermissionID = RP.PermissionID AND RP.RoleID = @RoleID
    WHERE P.IsActive = 1
    ORDER BY P.PermissionID ASC;
END
GO

CREATE OR ALTER PROCEDURE [dbo].[sp_RolePermissions_SyncForRole]
    @RoleID        INT,
    @PermissionIDs NVARCHAR(MAX)
AS
BEGIN
    SET NOCOUNT ON;

    BEGIN TRY
        BEGIN TRANSACTION;

        IF @PermissionIDs IS NULL OR LTRIM(RTRIM(@PermissionIDs)) = N''
        BEGIN
            DELETE FROM [dbo].[RolePermissions] WHERE RoleID = @RoleID;
        END
        ELSE
        BEGIN
            DELETE FROM [dbo].[RolePermissions]
            WHERE RoleID = @RoleID
              AND PermissionID NOT IN (
                  SELECT TRY_CAST(LTRIM(RTRIM(value)) AS INT)
                  FROM STRING_SPLIT(@PermissionIDs, ',')
                  WHERE TRY_CAST(LTRIM(RTRIM(value)) AS INT) IS NOT NULL
              );

            INSERT INTO [dbo].[RolePermissions] (RoleID, PermissionID)
            SELECT DISTINCT @RoleID, TRY_CAST(LTRIM(RTRIM(S.value)) AS INT)
            FROM STRING_SPLIT(@PermissionIDs, ',') S
            WHERE TRY_CAST(LTRIM(RTRIM(S.value)) AS INT) IS NOT NULL
              AND NOT EXISTS (
                  SELECT 1
                  FROM [dbo].[RolePermissions] RP
                  WHERE RP.RoleID = @RoleID
                    AND RP.PermissionID = TRY_CAST(LTRIM(RTRIM(S.value)) AS INT)
              );
        END

        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        THROW;
    END CATCH
END
GO