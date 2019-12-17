USE DoorDorz
GO

-- Bed Option rule.
CREATE RULE [BedOptionsRule]
    AS @BedOption IN ('Single', 'Double')
GO

CREATE RULE [RoomTypesRule]
    AS @RoomType IN ('Superior', 'Deluxe', 'Premiere', 'Suite')
GO

sp_bindrule 'BedOptionsRule', 'tblHotelRooms.BedOption', NULL;
GO

sp_bindrule 'RoomTypesRule', 'tblHotelRooms.BedOption', NULL;
GO
