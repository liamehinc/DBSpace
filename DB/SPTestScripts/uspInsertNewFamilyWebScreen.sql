USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@FamilyID int

EXEC	@return_value = [dbo].[usp_InsertNewFamilyWebScreen]
		@FamilyLastName = N'Werner',
		@Address_Line1 = N'1459 W. Glacier Road',
		@CityName = N'Minikwaga',
		@StateAbbr = N'MN',
		@ZipCode = N'54889',
		@Year_Built = '2010',
		@Owner_id = NULL,
		@is_Owner_Occupied = 1,
		@is_Residential = 1,
		@has_Peeling_Chipping_Paint = 0,
		@is_Rental = 0,
		@HomePhone = 3187521243,
		@HomePhonePriority = 1,
		@WorkPhone = 3187521242,
		@WorkPhonePriority = 2,
		@Language = 1,
		@NumSmokers = 2,
		@Pets = 1,
		@Frequently_Wash_Pets = 1,
		@Petsinandout = 1,
		@FamilyNotes = N'father works in a lead smelting industry',
		@PropertyNotes = N'house is on an old indian burial ground',
		@Travel = 0,
		@Travel_Notes = NULL,
		@Travel_Start_Date = NULL,
		@Travel_End_Date = NULL,
		@OverrideDuplicateProperty = NULL,
		@OverrideDuplicateFamilyPropertyAssociation = NULL,
		@DEBUG = 1,
		@FamilyID = @FamilyID OUTPUT

SELECT	@FamilyID as N'@FamilyID'

SELECT	'Return Value' = @return_value

GO

DECLARE @PhoneNumberID_OUTPUT INT

EXEC [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = 3187580242,
						@PhoneNumberTypeID = 2,
						@DEBUG = 1,
						@PhoneNumberID_OUTPUT = @PhoneNumberID_OUTPUT OUTPUT

			SELECT * from PHoneNumber where PhoneNumberID = @PhoneNumberID_OUTPUT