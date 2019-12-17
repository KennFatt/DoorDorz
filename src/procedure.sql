USE DoorDorz
GO

CREATE PROCEDURE [User.NewUser]
    @FirstName NVARCHAR, -- TODO: Include the sizes.
    @LastName NVARCHAR,
    @IDCardCode NVARCHAR,
    @Email VARCHAR,
    @PhoneNumber VARCHAR,
    @Password NVARCHAR
AS
    DECLARE @UID INT

    INSERT INTO [dbo].[tblUserIdentity] ([FirstName], [LastName], [IDCardCode])
        VALUES (@FirstName, @LastName, @IDCardCode);

    SELECT TOP 1 @UID =
        [IdentityId] FROM [dbo].[tblUserIdentity] ORDER BY [IdentityId] DESC;
    
    INSERT INTO [dbo].[tblUserData] ([UserEmail], [UserPhoneNumber], [UserPassword], [UserIdentityId])
        VALUES (@Email, @PhoneNumber, @Password, @UID)
GO
