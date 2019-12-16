-- Debug
SELECT [name] FROM sys.databases
-- Main Query, step by step.
USE master
GO

-- Create new database master.
IF NOT EXISTS (
    SELECT [name]
        FROM sys.databases
        WHERE [name] = N'DoorDorz'
)
CREATE DATABASE DoorDorz
GO

USE DoorDorz
GO

-- Users section.
-- Create new table `tblUserIdentity`
IF OBJECT_ID('[dbo].[tblUserIdentity]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblUserIdentity]
GO

CREATE TABLE [dbo].[tblUserIdentity]
(
    [IdentityId]    INT NOT NULL IDENTITY(1, 1),        -- Primary Key
    [FirstName]     NVARCHAR(50) NOT NULL,
    [LastName]      NVARCHAR(50) NOT NULL,
    [IDCardCode]    VARCHAR(16) NOT NULL,               -- Unique
    CONSTRAINT PK_UserIdentity PRIMARY KEY (IdentityId),
    CONSTRAINT UK_UserIdentity UNIQUE (IDCardCode)
);
GO

-- Create new table `tblUserData`
IF OBJECT_ID('[dbo].[tblUserData]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblUserData]
GO

CREATE TABLE [dbo].[tblUserData]
(
    [UserId]            INT NOT NULL IDENTITY(1, 1),    -- Primary Key
    [UserEmail]         VARCHAR(255) NOT NULL,          -- Unique
    [UserPhoneNumber]   VARCHAR(16) NOT NULL,           -- Unique
    [UserPassword]      NVARCHAR(16) NOT NULL,
    [UserIdentityId]    INT NOT NULL,                   -- Foreign Key. Reference -> tblUserIdentity.IdentityId
    CONSTRAINT PK_UserData PRIMARY KEY (UserId),
    CONSTRAINT FK_UserData FOREIGN KEY (UserIdentityId) REFERENCES [dbo].[tblUserIdentity](IdentityId),
    CONSTRAINT UK_UserData UNIQUE (UserEmail, UserPhoneNumber)
);
GO
-- End of Users section.

-- Hotel information section.
-- Create new table `tblHotelLocation`
IF OBJECT_ID('[dbo].[tblHotelLocation]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblHotelLocation]
GO

CREATE TABLE [dbo].[tblHotelLocation]
(
    [LocationId]    INT NOT NULL IDENTITY(1, 1),        -- Primary Key
    [Street]        NVARCHAR(255) NOT NULL,
    [City]          NVARCHAR(255) NOT NULL,
    [Province]      NVARCHAR(255) NOT NULL,
    [ZipCode]       INT NOT NULL,
    CONSTRAINT PK_HotelLocation PRIMARY KEY (LocationId)
);
GO

-- Create new table `tblHotel`
IF OBJECT_ID('[dbo].[tblHotel]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblHotel]
GO

CREATE TABLE [dbo].[tblHotel]
(
    [HotelId]       INT NOT NULL IDENTITY(1, 1),        -- Primary Key
    [HotelName]     NVARCHAR(255) NOT NULL,             -- Unique
    [HotelLocation] INT NOT NULL,                       -- Foreign Key. Reference -> tblHotelLocation.LocationId
    [StarRating]    INT NOT NULL DEFAULT (4),
    [ReviewScore]   FLOAT NOT NULL DEFAULT (0.0),
    [LowestPrice]   INT NOT NULL DEFAULT (0),
    CONSTRAINT PK_Hotel PRIMARY KEY (HotelId),
    CONSTRAINT FK_Hotel FOREIGN KEY (HotelLocation) REFERENCES [dbo].[tblHotelLocation](LocationId),
    CONSTRAINT UK_Hotel UNIQUE (HotelName)
);
GO

-- Create new table `tblHotelReview`
IF OBJECT_ID('[dbo].[tblHotelReview]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblHotelReview]
GO

CREATE TABLE [dbo].[tblHotelReview]
(
    [ReviewId]  INT NOT NULL IDENTITY(1, 1),            -- Primary Key
    [UserId]    INT NOT NULL,                           -- Foreign Key. Reference -> tblUserData.UserId
    [HotelId]   INT NOT NULL,                           -- Foreign Key. Reference -> tblHotel.HotelId
    [Score]     TINYINT NOT NULL DEFAULT (1),
    CONSTRAINT PK_HotelReview PRIMARY KEY (ReviewId),
    CONSTRAINT FK_HotelReviewUser FOREIGN KEY (UserId) REFERENCES [dbo].[tblUserData](UserId),
    CONSTRAINT FK_HotelReviewHotel FOREIGN KEY (HotelId) REFERENCES [dbo].[tblHotel](HotelId)
);
GO

-- Create new table `tblHotelFacilities`
IF OBJECT_ID('[dbo].[tblHotelFacilities]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblHotelFacilities]
GO

CREATE TABLE [dbo].[tblHotelFacilities]
(
    [FacilityId]    INT NOT NULL IDENTITY(1, 1),        -- Primary Key
    [HotelId]       INT NOT NULL,                       -- Foreign Key. Reference -> tblHotel.HotelId
    [FacilityName]  VARCHAR(18) NOT NULL,               -- Unique
    CONSTRAINT PK_HotelFacilities PRIMARY KEY (FacilityId),
    CONSTRAINT FK_HotelFacilities FOREIGN KEY (HotelId) REFERENCES [dbo].[tblHotel](HotelId),
    CONSTRAINT UK_HotelFacilities UNIQUE (FacilityName)
);
GO

-- Create new table `tblHotelRooms`
IF OBJECT_ID('[dbo].[tblHotelRooms]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblHotelRooms]
GO

CREATE TABLE [dbo].[tblHotelRooms]
(
    [RoomId]        INT NOT NULL IDENTITY(1, 1),        -- Primary Key
    [HotelId]       INT NOT NULL,                       -- Foreign Key. Reference -> tblHotel.HotelId
    [RoomType]      VARCHAR(255) NOT NULL DEFAULT ('Superior'),
    [PricePerNight] INT NOT NULL,
    [BedOption]     VARCHAR(10) NOT NULL,
    [isSmokingRoom] BIT NOT NULL DEFAULT (0),
    [isAvailable]   BIT NOT NULL DEFAULT (0),
    CONSTRAINT PK_HotelRooms PRIMARY KEY (RoomId),
    CONSTRAINT FK_HotelRooms FOREIGN KEY (HotelId) REFERENCES [dbo].[tblHotel](HotelId)
);
GO
-- End of Hotel information section.

-- Transaction section.
-- Create new table `tblBookingTransaction`
IF OBJECT_ID('[dbo].[tblBookingTransaction]', 'U') IS NOT NULL
    DROP TABLE [dbo].[tblBookingTransaction]
GO

CREATE TABLE [dbo].[tblBookingTransaction]
(
    [TransactionId] INT NOT NULL IDENTITY(1, 1),        -- Primary Key
    [UserId]        INT NOT NULL,                       -- Foreign Key. Reference -> tblUserData.UserId
    [HotelId]       INT NOT NULL,                       -- Foreign Key. Reference -> tblHotel.HotelId
    [RoomId]        INT NOT NULL,                       -- Foreign Key. Reference -> tblHotelRooms.RoomId
    [Duration]      INT NOT NULL DEFAULT (1),           -- Duration in days.
    [CheckIn]       SMALLDATETIME NOT NULL,             -- smalldatetime: YYYY-MM-DD hh:mm:ss
    [CheckOut]      SMALLDATETIME NOT NULL,
    [BookingId]     VARCHAR(255) NOT NULL               -- Unique. Format: #DDB00000N, Whereas N represented as a transactionId. Use trigger to do this one (or function).
    CONSTRAINT PK_BT PRIMARY KEY (TransactionId),
    CONSTRAINT FK_BTUser FOREIGN KEY (UserId) REFERENCES [dbo].[tblUserData](UserId),
    CONSTRAINT FK_BTHotel FOREIGN KEY (HotelId) REFERENCES [dbo].[tblHotel](HotelId),
    CONSTRAINT FK_BTRoom FOREIGN KEY (RoomId) REFERENCES [dbo].[tblHotelRooms](RoomId),
    CONSTRAINT UK_BT UNIQUE (BookingId)
);
GO
