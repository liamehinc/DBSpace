USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@FamilyID int

EXEC	@return_value = [dbo].[usp_InsertNewFamilyWebScreen]
		@FamilyLastName = N'Clubber',
		@Address_Line1 = N'12 Silverthorne Dr',
		@ApartmentNum = NULL,
		@CityName = N'Leadville',
		@StateAbbr = N'CO',
		@ZipCode = N'80461',
		@Year_Built = '1999',
		@Owner_id = NULL,
		@is_Owner_Occupied = 1,
		@is_Residential = 1,
		@has_Peeling_Chipping_Paint = 1,
		@is_Rental = 0,
		@Language = 1,
		@NumSmokers = 4,
		@Pets = 2,
		@Frequently_Wash_Pets = 0,
		@Petsinandout = 1,
		@FamilyNotes = N'Family notes',
		@PropertyNotes = N'property notes',
		@Travel_Notes = N'traveled to costa rica',
		@Travel_Start_Date = N'20050209',
		@Travel_End_Date = N'20050215',
		@DEBUG = 1,
		@FamilyID = @FamilyID OUTPUT

SELECT	@FamilyID as N'@FamilyID'

SELECT	'Return Value' = @return_value

GO


select * from ErrorLog order by ErrorID desc