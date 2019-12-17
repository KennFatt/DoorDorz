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

-- Schema
CREATE SCHEMA [User]
GO

CREATE SCHEMA [Hotel]
GO

-- Users section.
-- Create new table `tblUserData`
IF OBJECT_ID('[User].[tblUserData]', 'U') IS NOT NULL
    DROP TABLE [User].[tblUserData]
GO

CREATE TABLE [User].[tblUserData]
(
    [UserId]            INT NOT NULL IDENTITY(1, 1),    -- Primary Key
    [UserEmail]         VARCHAR(255) NOT NULL,          -- Unique
    [UserPhoneNumber]   VARCHAR(16) NOT NULL,           -- Unique
    [UserPassword]      NVARCHAR(16) NOT NULL,
    [FirstName]         NVARCHAR(50) NOT NULL,
    [LastName]          NVARCHAR(50) NOT NULL,
    [IDCardCode]        VARCHAR(16) NOT NULL,           -- Unique
    CONSTRAINT PK_UserData PRIMARY KEY (UserId),
    CONSTRAINT UK_UserData UNIQUE (UserEmail, UserPhoneNumber, IDCardCode)
);
GO
-- End of Users section.

-- Hotel information section.
-- Create new table `tblHotelLocation`
IF OBJECT_ID('[Hotel].[tblHotelLocation]', 'U') IS NOT NULL
    DROP TABLE [Hotel].[tblHotelLocation]
GO

CREATE TABLE [Hotel].[tblHotelLocation]
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
IF OBJECT_ID('[Hotel].[tblHotel]', 'U') IS NOT NULL
    DROP TABLE [Hotel].[tblHotel]
GO

CREATE TABLE [Hotel].[tblHotel]
(
    [HotelId]       INT NOT NULL IDENTITY(1, 1),        -- Primary Key
    [HotelName]     NVARCHAR(255) NOT NULL,             -- Unique
    [HotelLocation] INT NOT NULL,                       -- Foreign Key. Reference -> tblHotelLocation.LocationId
    [StarRating]    TINYINT NOT NULL DEFAULT (4),
    [ReviewScore]   FLOAT NOT NULL DEFAULT (0.0),
    [LowestPrice]   INT NOT NULL DEFAULT (0),
    CONSTRAINT PK_Hotel PRIMARY KEY (HotelId),
    CONSTRAINT FK_Hotel FOREIGN KEY (HotelLocation) REFERENCES [Hotel].[tblHotelLocation](LocationId),
    CONSTRAINT UK_Hotel UNIQUE (HotelName)
);
GO

-- Create new table `tblHotelReview`
IF OBJECT_ID('[Hotel].[tblHotelReview]', 'U') IS NOT NULL
    DROP TABLE [Hotel].[tblHotelReview]
GO

CREATE TABLE [Hotel].[tblHotelReview]
(
    [ReviewId]  INT NOT NULL IDENTITY(1, 1),            -- Primary Key
    [UserId]    INT NOT NULL,                           -- Foreign Key. Reference -> tblUserData.UserId
    [HotelId]   INT NOT NULL,                           -- Foreign Key. Reference -> tblHotel.HotelId
    [Score]     TINYINT NOT NULL DEFAULT (1),
    CONSTRAINT PK_HotelReview PRIMARY KEY (ReviewId),
    CONSTRAINT FK_HotelReviewUser FOREIGN KEY (UserId) REFERENCES [User].[tblUserData](UserId),
    CONSTRAINT FK_HotelReviewHotel FOREIGN KEY (HotelId) REFERENCES [Hotel].[tblHotel](HotelId)
);
GO

-- Create new table `tblHotelFacilities`
IF OBJECT_ID('[Hotel].[tblHotelFacilities]', 'U') IS NOT NULL
    DROP TABLE [Hotel].[tblHotelFacilities]
GO

CREATE TABLE [Hotel].[tblHotelFacilities]
(
    [FacilityId]    INT NOT NULL IDENTITY(1, 1),        -- Primary Key
    [HotelId]       INT NOT NULL,                       -- Foreign Key. Reference -> tblHotel.HotelId
    [FacilityName]  VARCHAR(18) NOT NULL,               -- Unique
    CONSTRAINT PK_HotelFacilities PRIMARY KEY (FacilityId),
    CONSTRAINT FK_HotelFacilities FOREIGN KEY (HotelId) REFERENCES [Hotel].[tblHotel](HotelId)
);
GO

-- Create new table `tblHotelRooms`
IF OBJECT_ID('[Hotel].[tblHotelRooms]', 'U') IS NOT NULL
    DROP TABLE [Hotel].[tblHotelRooms]
GO

CREATE TABLE [Hotel].[tblHotelRooms]
(
    [RoomId]        INT NOT NULL IDENTITY(1, 1),        -- Primary Key
    [HotelId]       INT NOT NULL,                       -- Foreign Key. Reference -> tblHotel.HotelId
    [RoomType]      VARCHAR(255) NOT NULL DEFAULT ('Superior'),
    [PricePerNight] INT NOT NULL,
    [BedOption]     VARCHAR(10) NOT NULL,
    [isSmokingRoom] BIT NOT NULL DEFAULT (0),
    [isAvailable]   BIT NOT NULL DEFAULT (1),
    CONSTRAINT PK_HotelRooms PRIMARY KEY (RoomId),
    CONSTRAINT FK_HotelRooms FOREIGN KEY (HotelId) REFERENCES [Hotel].[tblHotel](HotelId)
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
    [CheckIn]       SMALLDATETIME NOT NULL,             -- smalldatetime: YYYY-MM-DD hh:mm:ss
    [CheckOut]      SMALLDATETIME NOT NULL,
    [TotalPrice]    INT NOT NULL,
    [BookingId]     AS '#DDB' + RIGHT(1000000 + transactionId, 5)
    -- Unique. Format: #DDB00000N, Whereas N represented as a transactionId. Use trigger to do this one (or function).
    -- References:
    -- https://social.msdn.microsoft.com/Forums/sqlserver/en-US/0eaa0bfb-82bc-4390-9852-056fa389c1df/concat-with-autoincrement-column?forum=transactsql
    -- https://www.techonthenet.com/sql_server/functions/right.php
    CONSTRAINT PK_BT PRIMARY KEY (TransactionId),
    CONSTRAINT FK_BTUser FOREIGN KEY (UserId) REFERENCES [User].[tblUserData](UserId),
    CONSTRAINT FK_BTHotel FOREIGN KEY (HotelId) REFERENCES [Hotel].[tblHotel](HotelId),
    CONSTRAINT FK_BTRoom FOREIGN KEY (RoomId) REFERENCES [Hotel].[tblHotelRooms](RoomId),
    CONSTRAINT UK_BT UNIQUE (BookingId)
);
GO
