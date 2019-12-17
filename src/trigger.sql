USE DoorDorz
GO

-- @Trigger ReviewCreatedEvent
-- This trigger will recognize a new records that has been inserted into the table
-- and then update the value of `tblHotel`.`ReviewScore` automatically.
CREATE TRIGGER [ReviewCreatedEvent] ON [dbo].[tblHotelReview]
    AFTER INSERT, UPDATE
    AS
    DECLARE @HotelId INT
    DECLARE @NewAverage INT

    SELECT TOP 1 @HotelId =                                         -- Getting the @HotelId
        [HotelId]
    FROM
        [dbo].[tblHotelReview]
    ORDER BY
        [ReviewId] DESC

    SELECT @NewAverage =                                            -- Assign new average into @NewAverage
        AVG([Score])
    FROM
        [dbo].[tblHotelReview]

    UPDATE [dbo].[tblHotel]                                         -- Update the basis table
        SET [ReviewScore] = @NewAverage
        WHERE [HotelId] = @HotelId
GO

-- @Trigger RoomBookedEvent
-- The trigger will automatically handle `tblHotelRooms`.`isAvailable` whenever its taken by any transaction.
CREATE TRIGGER [RoomBookedEvent] ON [dbo].[tblBookingTransaction]
    AFTER INSERT                                                    -- Only after insertion (insertion indicate new transaction being recorded)
    AS
    DECLARE @RoomId INT
    SELECT TOP 1 @RoomId =                                          -- Getting recent RoomId from `tblBookingTransaction`
        [RoomId]
    FROM
        [dbo].[tblBookingTransaction]
    ORDER BY
        [TransactionId] DESC

    UPDATE [dbo].[tblHotelRooms]                                    -- Fire the update.
        SET [isAvailable] = 0                                       -- Set `isAvailable` to false (0).
        WHERE [RoomId] = @RoomId
GO

-- @Trigger RoomCreatedEvent
-- The trigger would update `LowestPrice` on table `Hotel` by sorting from following table.
CREATE TRIGGER [RoomCreatedEvent] ON [dbo].[tblHotelRooms]
    AFTER INSERT, UPDATE
    AS
    DECLARE @HotelId INT
    DECLARE @LowestPrice INT

    SELECT TOP 1 @HotelId =                                         -- Getting modified `HotelId` as usual
        [HotelId]
    FROM
        [dbo].[tblHotelRooms]
    ORDER BY
        [RoomId] DESC

    SELECT TOP 1 @LowestPrice =                                     -- Getting the lowest price 
        [PricePerNight]
    FROM
        [dbo].[tblHotelRooms]
    WHERE
        [HotelId] = @HotelId
    ORDER BY
        [PricePerNight] 
        
    UPDATE [dbo].[tblHotel]                                         -- Fire the update
        SET [LowestPrice] = @LowestPrice
        WHERE [HotelId] = @HotelId
GO
