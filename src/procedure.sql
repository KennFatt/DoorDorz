USE DoorDorz
GO

CREATE PROCEDURE [User.NewUser]
    @FirstName      NVARCHAR(50),
    @LastName       NVARCHAR(50),
    @IDCardCode     NVARCHAR(16),
    @Email          VARCHAR(255),
    @PhoneNumber    VARCHAR(16),
    @Password       NVARCHAR(16)
AS
    INSERT INTO [User].[tblUserData] ([FirstName], [LastName], [IDCardCode], [UserEmail], [UserPhoneNumber], [UserPassword])
        VALUES (@FirstName, @LastName, @IDCardCode, @Email, @PhoneNumber, @Password)
GO

CREATE PROCEDURE [Hotel.NewHotel]
    @HotelName NVARCHAR(255),
    @StarRating TINYINT,

    @Street NVARCHAR(255),
    @City NVARCHAR(255),
    @Province NVARCHAR(255),
    @ZipCode INT
AS
    DECLARE @LocationId INT

    INSERT INTO [Hotel].[tblHotelLocation] ([Street], [City], [Province], [ZipCode])
        VALUES (@Street, @City, @Province, @ZipCode);

    SELECT TOP 1 @LocationId =
        [LocationId] FROM [Hotel].[tblHotelLocation] ORDER BY [LocationId] DESC;

    INSERT INTO [Hotel].[tblHotel] ([HotelName], [StarRating], [HotelLocation])
        VALUES (@HotelName, @StarRating, @LocationId);
GO

CREATE PROCEDURE [Hotel.AddRoom]
    @HotelId INT,
    @RoomType VARCHAR(255),
    @PricePerNight INT,
    @BedOption VARCHAR(10),
    @isSmokingRoom BIT
AS
    INSERT INTO [Hotel].[tblHotelRooms] ([HotelId], [RoomType], [PricePerNight], [BedOption], [isSmokingRoom])
        VALUES (@HotelId, @RoomType, @PricePerNight, @BedOption, @isSmokingRoom);
GO

CREATE PROCEDURE [Transaction.NewTransaction]
    @UserId INT,
    @HotelId INT,
    @RoomId INT,
    @CheckIn SMALLDATETIME,
    @CheckOut SMALLDATETIME
AS
    INSERT INTO [dbo].[tblBookingTransaction] ([UserId], [HotelId], [RoomId], [CheckIn], [CheckOut])
        VALUES (@UserId, @HotelId, @RoomId, @CheckIn, @CheckOut)
GO
