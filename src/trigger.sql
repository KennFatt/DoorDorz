USE DoorDorz
GO

-- @Trigger ReviewCreatedEvent
-- This trigger will recognize a new records that has been inserted into the table
-- and then update the value of `tblHotel`.`ReviewScore` automatically.
CREATE TRIGGER [ReviewCreatedEvent] ON [Hotel].[tblHotelReview]
    AFTER INSERT, UPDATE
    AS
    DECLARE @HotelId INT
    DECLARE @NewAverage INT

    SELECT TOP 1 @HotelId = [HotelId]                               -- Getting the @HotelId
        FROM [Hotel].[tblHotelReview]
            ORDER BY [ReviewId] DESC

    SELECT @NewAverage = AVG([Score])                               -- Assign new average into @NewAverage
        FROM [Hotel].[tblHotelReview]

    UPDATE [Hotel].[tblHotel]                                       -- Update the basis table
        SET [ReviewScore] = @NewAverage
            WHERE [HotelId] = @HotelId
GO

-- @Trigger RoomBookedEvent
-- The trigger will automatically handle `tblHotelRooms`.`isAvailable` whenever its taken by any transaction.
CREATE TRIGGER [RoomBookedEvent] ON [dbo].[tblBookingTransaction]
    AFTER INSERT                                                    -- Only after insertion (insertion indicate new transaction being recorded)
    AS
    DECLARE @RoomId INT
    SELECT TOP 1 @RoomId = [RoomId]                                 -- Getting recent RoomId from `tblBookingTransaction`
        FROM [dbo].[tblBookingTransaction]
            ORDER BY [TransactionId] DESC

    UPDATE [Hotel].[tblHotelRooms]                                  -- Fire the update.
        SET [isAvailable] = 0                                       -- Set `isAvailable` to false (0).
            WHERE [RoomId] = @RoomId
GO

-- @Trigger RoomCreatedEvent
-- The trigger would update `LowestPrice` on table `Hotel` by sorting from following table.
CREATE TRIGGER [RoomCreatedEvent] ON [Hotel].[tblHotelRooms]
    AFTER INSERT, UPDATE
    AS
    DECLARE @HotelId INT
    DECLARE @LowestPrice INT

    SELECT TOP 1 @HotelId = [HotelId]                               -- Getting modified `HotelId` as usual
        FROM [Hotel].[tblHotelRooms]
            ORDER BY [RoomId] DESC

    SELECT TOP 1 @LowestPrice = [PricePerNight]                     -- Getting the lowest price 
        FROM [Hotel].[tblHotelRooms]
            WHERE [HotelId] = @HotelId
                ORDER BY [PricePerNight] 
        
    UPDATE [Hotel].[tblHotel]                                       -- Fire the update
        SET [LowestPrice] = @LowestPrice
            WHERE [HotelId] = @HotelId
GO

-- TODO: Kalkulasi total harga pada transaksi berdasarkan checkin checkout
