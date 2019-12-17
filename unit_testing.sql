USE DoorDorz
GO

SELECT * FROM [User].[tblUserData]

-- Insert user. [Status: Succeed]
EXECUTE [User.NewUser] 'Kennan', 'Fattah', '19200932012557891', 'me@kennan.xyz', '+6281310712849', 'rahasiaumum'
EXECUTE [User.NewUser] 'Ali', 'Sudrajat', '19200932012559001', 'ali@gmail.com', '+6281392098911', 'hehehaha'
EXECUTE [User.NewUser] 'Bayu', 'K.R', '19200932012588700', 'bayu@gmail.com', '+6281381124670', 'ssttrahasia'

SELECT * FROM [Hotel].[tblHotel]
SELECT * FROM [Hotel].[tblHotelRooms]
SELECT COUNT([RoomId]) AS [Jumlah kamar dari hotel 1] FROM [Hotel].[tblHotelRooms] WHERE [HotelId] = 1

-- Insert new hotel and its room. [Status: Succeed]
EXECUTE [Hotel.NewHotel] 'Liberta Hotel', 4, 'Kemang', 'Jakarta Timur', 'DKI Jakarta', 13720
EXECUTE [Hotel.AddRoom] 1, 'Deluxe', 735000, 'Single', 1
EXECUTE [Hotel.AddRoom] 1, 'Premiere', 950000, 'Single', 0
EXECUTE [Hotel.AddRoom] 1, 'Suite', 1150000, 'Double', 0

EXECUTE [Hotel.NewHotel] 'Amaroossa', 4, 'Senayan', 'Jakarta Pusat', 'DKI Jakarta', 14010
EXECUTE [Hotel.AddRoom] 2, 'Superior', 720000, 'Double', 1
EXECUTE [Hotel.AddRoom] 2, 'Superior', 66712, 'Single', 1
EXECUTE [Hotel.AddRoom] 2, 'Deluxe', 825000, 'Double', 0

EXECUTE [Hotel.NewHotel] 'Amaris', 5, 'Senopati', 'Jakarta Selatan', 'DKI Jakarta', 12980
EXECUTE [Hotel.AddRoom] 3, 'Suite', 2350000, 'Single', 1
EXECUTE [Hotel.AddRoom] 3, 'Deluxe', 1649549, 'Single', 1
EXECUTE [Hotel.AddRoom] 3, 'Premiere', 375890, 'Double', 0

EXECUTE [Hotel.NewHotel] 'Shangri-La', 5, 'Sudirman', 'Jakarta Pusat', 'DKI Jakarta', 11001
EXECUTE [Hotel.AddRoom] 4, 'Suite', 4865000, 'Double', 0
EXECUTE [Hotel.AddRoom] 4, 'Suite', 3905000, 'Double', 1
EXECUTE [Hotel.AddRoom] 4, 'Premiere', 2712335, 'Single', 0

SELECT * FROM [dbo].[tblBookingTransaction]

-- Transaction. [Status: Succeed]
EXECUTE [Transaction.NewTransaction] 1, 4, 10, '2019-12-17 12:00:00', '2019-12-19 12:00:00'
EXECUTE [Transaction.NewTransaction] 2, 4, 11, '2019-12-19 12:00:00', '2019-12-25 13:00:00'
EXECUTE [Transaction.NewTransaction] 3, 3, 8, '2019-12-25 12:00:00', '2019-12-26 13:00:00'
