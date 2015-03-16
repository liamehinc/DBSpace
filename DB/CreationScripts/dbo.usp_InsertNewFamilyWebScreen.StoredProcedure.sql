USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertNewFamilyWebScreen]    Script Date: 3/15/2015 6:51:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20141115
-- Description:	stored procedure to insert data from the Add a new family web page
-- =============================================
-- 20150102	Fixed bug with family/property association checking
CREATE PROCEDURE [dbo].[usp_InsertNewFamilyWebScreen]
	-- Add the parameters for the stored procedure here
	@FamilyLastName varchar(50) = NULL, 

	@StreetNum varchar(15) = NULL,    -- REMOVE LINE 
	@StreetName varchar(50) = NULL,   -- REMOVE LINE 
	@StreetSuff varchar(20) = NULL,   -- REMOVE LINE 

	@Address_Line1 varchar(100) = NULL,
	@ApartmentNum varchar(10) = NULL,
	@CityName varchar(50) = 'Leadville',
	@StateAbbr char(2) = 'CO',
	@ZipCode varchar(10) = '80461',
	@Year_Built date = NULL,
	@Owner_id int = NULL,
	@is_Owner_Occupied bit = NULL,
	@is_Residential bit = NULL,
	@has_Peeling_Chipping_Paint bit = NULL,
	@is_Rental bit = NULL,
	@HomePhone bigint = NULL,
	@WorkPhone bigint = NULL,
	@Language tinyint = NULL, 
	@NumSmokers tinyint = NULL,
	@Pets bit = NULL,
	@inandout bit = NULL,
	@FamilyNotes varchar(3000) = NULL,
	@PropertyNotes varchar(3000) = NULL,
	@DEBUG BIT = 0,
	@FamilyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF (@FamilyLastName IS NULL
		-- AND @Address_Line1 IS NULL
		AND @ApartmentNum IS NULL
		AND @HomePhone IS NULL
		AND @WorkPhone IS NULL)
	BEGIN
		RAISERROR ('You must supply at least one of the following: Family name, StreetNumber, Street Name, Street Suffix, Apartment number, Home phone, or Work phone', 11, -1);
		RETURN;
	END;

	BEGIN
		DECLARE @PhoneTypeID tinyint, 
				@Family_return_value int,
				@PropID int, @LID tinyint,
				@PhoneNumberID_OUTPUT int,
				@Homephone_return_value int,
				@Workphone_return_value int,
				@NewFamilyNotesID int,
				@ErrorLogID int;

		BEGIN TRY
			-- Insert the property address if it doesn't already exist
			-- NEED TO RETRIEVE PROPERTY ID IF IT ALREADY EXISTS
			SELECT @PropID = PropertyID from Property where
			
			 ( AddressLine1 = @Address_Line1 
					OR ( StreetSuffix = @StreetSuff AND Street = @StreetName AND StreetNumber = @StreetNum)   -- REMOVE LINE 
					)
													and City = @CityName
													and [State] = @StateAbbr and Zipcode = @ZipCode

			if (@Address_Line1 IS NULL)
				SET @Address_Line1 = concat(@StreetNum, ' ',  @StreetName, ' ', @StreetSuff)
			if ( @PropID is NULL)
			BEGIN -- enter property
				EXEC	[dbo].[usp_InsertProperty] 
						@AddressLine1 = @Address_Line1,
						@City = @CityName,
						@State = @StateAbbr,
						@Zipcode = @ZipCode,
						@New_PropertyNotes = @PropertyNotes,
						@YearBuilt = @Year_Built,

						@Ownerid = @Owner_id,
						@isOwnerOccuppied = @is_Owner_Occupied,
						@isResidential = @is_Residential,
						@hasPeelingChippingPaint = @has_Peeling_Chipping_Paint,
						@isRental = @is_Rental,

						@PropertyID = @PropID OUTPUT;
					END -- enter property
			-- Check if Family is already associated with property, if so, skip insert and return warning:
			if ((select count(PrimarypropertyID) from Family where LastName = @FamilyLastName and PrimaryPropertyID = @PropID) > 0)
			BEGIN
				-- update address in the future??
				RAISERROR ('Family is already associated with that Property', 11, -1);
				RETURN;
			END
			ELSE
			BEGIN
				EXEC	[dbo].[usp_InsertFamily]
						@LastName = @FamilyLastName,
						@NumberofSmokers = @NumSmokers,
						@PrimaryLanguageID = @Language,
						@Pets = @Pets,
						@inandout = @inandout,
						@PrimaryPropertyID = @PropID,
						@Notes = @FamilyNotes,
						@FID = @FamilyID OUTPUT;
			END

			if (@HomePhone is not NULL) 
			BEGIN  -- insert Home Phone
				SELECT @PhoneTypeID = PhoneNumberTypeID from PhoneNumberType where PhoneNumberTypeName = 'Home Phone';
				
				EXEC	@Homephone_return_value = [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @HomePhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@PhoneNumberID_OUTPUT = @PhoneNumberID_OUTPUT OUTPUT
			END  -- insert Home Phone

			if (@WorkPhone is not NULL) 
			BEGIN  -- insert Work Phone
				SELECT @PhoneTypeID = PhoneNumberTypeID from PhoneNumberType where PhoneNumberTypeName = 'Work Phone';

				EXEC	@Workphone_return_value = [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @HomePhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@PhoneNumberID_OUTPUT = @PhoneNumberID_OUTPUT OUTPUT
			END  -- insert Work Phone
		END TRY
		BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Roll back any active or uncommittable transactions before
			-- inserting information in the ErrorLog.
			IF XACT_STATE() <> 0
			BEGIN
				ROLLBACK TRANSACTION;
			END

			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH; 
	END
END


GO
