Create procedure sp_Permissions_Insert 
   @PermissionName  nvarchar (100) ,
   @PermissionCode nvarchar(100) ,
   @Descripation nvarchar(250) ,
   @IsActive bit =1 ,
   @NewPermissionID int output 
   as 
   begin
         SET NOCOUNT ON;
    IF dbo.fn_Permissions_IsExistsForInsert(@PermissionCode, @PermissionName) = 1
    BEGIN
        RAISERROR(N'ﬂÊœ «·’·«ÕÌ… √Ê «·«”„ „ÊÃÊœ „”»ﬁ«!', 16, 1);
        RETURN;
    END

	insert into Permissions (PermissionName , PermissionCode ,Description,IsActive)
	values (@PermissionName, @PermissionName ,@Descripation ,@IsActive)

	set @NewPermissionID = SCOPE_IDENTITY();
end;

go


-- ». ≈Ã—«¡ «· ÕœÌÀ
CREATE PROCEDURE sp_Permissions_Update
    @PermissionID INT,
    @PermissionName NVARCHAR(100),
    @PermissionCode NVARCHAR(100),
    @Description NVARCHAR(255) = NULL,
    @IsActive BIT

	as 
	begin 
	     set Nocount on ;
		 IF dbo.fn_Permissions_IsExistsForUpdate(@PermissionID, @PermissionCode, @PermissionName) = 1
    BEGIN
        RAISERROR(N'ﬂÊœ «·’·«ÕÌ… √Ê «·«”„ „” Œœ„ ·’·«ÕÌ… √Œ—Ï!', 16, 1);
        RETURN;
    END

	update Permissions
	set PermissionName = @PermissionName ,
	    PermissionCode = @PermissionCode ,
		Description = @Description ,
		IsActive  = @IsActive
	where PermissionName = @PermissionID ;
end ;

go


-- Ã. ≈Ã—«¡ «·Õ–› (√Ê «· ⁄ÿÌ· «·¬„‰)
CREATE PROCEDURE sp_Permissions_Delete
     @PermissionID int 
as 
begin 
     set nocount on ;

	 if exists (select 1 from RolePermissions where PermissionID = @PermissionID)
	      update Permissions Set IsActive = 0 where PermissionID = @PermissionID;
	 else
	      Delete from Permissions where PermissionID = @PermissionID ;
end ;


go

-- œ. ≈Ã—«¡ «·Ã·» »—ﬁ„ «·‹ ID
CREATE PROCEDURE sp_Permissions_GetById
    @PermissionID INT 
as 
begin 
     set nocount on ;
	 select * from Permissions where PermissionID = @PermissionID;
end ;


go 

--Ã—«¡ „Œ“¯‰ ÌÃ·» »Ì«‰«  «·’·«ÕÌ«  „‰ vw_PermissionsDetails „⁄ ≈Œ›«¡ —”«∆· ⁄œœ «·’›Ê›∫ ›Ì—Ã⁄ «·‰‘ÿ… ›ﬁÿ (IsActive = 1)
--≈–« ﬂ«‰ @OnlyActive = 1° Ê«·Ã„Ì⁄ «› —«÷Ì« (0).

-- Â‹. ≈Ã—«¡ Ã·» «·ﬂ· („‰ «·‹ View „»«‘—…)
CREATE PROCEDURE sp_Permissions_GetAll
    @OnlyActive BIT = 0

as 
begin 
     set nocount on;
	 if @OnlyActive = 1 
	      select * from vw_PermissionsDetails where IsActive = 1;
		else 
		  select * from vw_PermissionsDetails ;
end ;

go
