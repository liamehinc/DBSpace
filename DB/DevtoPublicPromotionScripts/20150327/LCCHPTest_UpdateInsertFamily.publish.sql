﻿/*
Deployment script for LCCHPTest

This code was generated by a tool.
Changes to this file may cause incorrect behavior and will be lost if
the code is regenerated.
*/

GO
SET ANSI_NULLS, ANSI_PADDING, ANSI_WARNINGS, ARITHABORT, CONCAT_NULL_YIELDS_NULL, QUOTED_IDENTIFIER ON;

SET NUMERIC_ROUNDABORT OFF;


GO
:setvar DatabaseName "LCCHPTest"
:setvar DefaultFilePrefix "LCCHPTest"
:setvar DefaultDataPath "D:\MSSQL\Data\"
:setvar DefaultLogPath "D:\MSSQL\Log\"

GO
:on error exit
GO
/*
Detect SQLCMD mode and disable script execution if SQLCMD mode is not supported.
To re-enable the script after enabling SQLCMD mode, execute the following:
SET NOEXEC OFF; 
*/
:setvar __IsSqlCmdEnabled "True"
GO
IF N'$(__IsSqlCmdEnabled)' NOT LIKE N'True'
    BEGIN
        PRINT N'SQLCMD mode must be enabled to successfully execute this script.';
        SET NOEXEC ON;
    END


GO
USE [$(DatabaseName)];


GO
PRINT N'Altering [dbo].[Family]...';


GO
ALTER TABLE [dbo].[Family]
    ADD [ForeignTravel] BIT NULL;
GO

EXEC sp_rename 'Family.inandout', 'Petsinandout';

GO
PRINT N'Altering [dbo].[usp_InsertFamily]...';


GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140205
-- Description:	Stored Procedure to insert new Family information
-- =============================================

ALTER PROCEDURE [dbo].[usp_InsertFamily]  
	-- Add the parameters for the stored procedure here
	@LastName varchar(50) = NULL,
	@NumberofSmokers tinyint = 0,
	@PrimaryLanguageID tinyint = 1,
	@Notes varchar(3000) = NULL,
	@ForeignTravel bit = NULL,
	@New_Travel_Notes varchar(3000) = NULL,
	@Travel_Start_Date date = NULL,
	@Travel_End_Date date = NULL,
	@Pets tinyint = NULL,
	@Petsinandout bit = NULL,
	@PrimaryPropertyID int = NULL,
	@FrequentlyWashPets bit = NULL,
	@FID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ErrorLogID int, @FamilyNotesReturnValue int, @InsertedFamilyNotesID int
			, @TravelNotesReturnValue int, @InsertedTravelNotesID int;

	BEGIN TRY -- insert Family
		BEGIN TRANSACTION InsertFamilyTransaction
			INSERT into Family ( LastName,  NumberofSmokers,  PrimaryLanguageID, Pets, Petsinandout
						, PrimaryPropertyID, FrequentlyWashPets, ForeignTravel) 
						Values (@LastName, @NumberofSmokers, @PrimaryLanguageID, @Pets, @Petsinandout
						, @PrimaryPropertyID, @FrequentlyWashPets, @ForeignTravel)
			SET @FID = SCOPE_IDENTITY();  -- uncomment to return primary key of inserted values

			IF (@Notes IS NOT NULL)
				EXEC	@FamilyNotesReturnValue = [dbo].[usp_InsertFamilyNotes]
													@Family_ID = @FID,
													@Notes = @Notes,
													@InsertedNotesID = @InsertedFamilyNotesID OUTPUT
	
			IF (@New_Travel_Notes IS NOT NULL)
				EXEC	@TravelNotesReturnValue = [dbo].[usp_InsertTravelNotes]
						@Family_ID = @FID,
						@Travel_Notes = @New_Travel_Notes,
						@Start_Date = @Travel_Start_Date,
						@End_Date = @Travel_End_Date,
						@InsertedNotesID = @InsertedTravelNotesID OUTPUT

		COMMIT TRANSACTION InsertFamilyTransaction
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
		RETURN ERROR_NUMBER();
	END CATCH; 
END
GO
PRINT N'Altering [dbo].[usp_SLInsertedDataSimplified]...';


GO

-- =============================================
-- Author:		William Thier
-- Create date: 20130509
-- Description:	
-- =============================================
ALTER PROCEDURE [dbo].[usp_SLInsertedDataSimplified] 
	-- Add the parameters for the stored procedure here
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000),
			@Recompile BIT = 1, @ErrorLogID int
			, @DEBUG BIT = 0;

    -- Insert statements for procedure here
	BEGIN TRY
	SELECT [P].[PersonID] 
		, 'P2FPersonID' = [P2F].[PersonID]
		, 'FamilyLastName' = [F].[Lastname]
		, [F].[FamilyID]
		, 'P2FFamilyID' = [P2F].[FamilyID]
		, [P].[LastName]
		, [P].[MiddleName]
		, [P].[FirstName]
		, [P].[BirthDate]
		, [P].[Gender]
		--, 'StreetAddress' = cast([Prop].[StreetNumber] as varchar)
		--	+ ' '+ cast([Prop].[Street] as varchar) + ' ' 
		--	+ cast([Prop].[StreetSuffix] as varchar)
		--, [Prop].[ApartmentNumber]
		--, [Prop].[City]
		--, [Prop].[State]
		--, [Prop].[Zipcode]
		--, 'PrimaryPhoneNumber' = [Ph].[PhoneNumber]
		--, [L].[LanguageName]
		, [F].[NumberofSmokers]
		, [F].[Pets]
		, [F].[Petsinandout]
		, [FN].[Notes]

	FROM [Person] AS [P]
	FULL OUTER JOIN [PersontoFamily] as [P2F] on [P].[PersonID] = [P2F].[PersonID]
	FULL OUTER JOIN [Family] AS [F] on [F].[FamilyID] = [P2F].[FamilyID]
	FULL OUTER JOIN [FamilyNotes] AS [FN] on [F].[FamilyID] = [FN].[FamilyID]
--	FULL OUTER JOIN [PersontoProperty] as [P2P] on [P].PersonID = [P2P].[PersonID]
--	FULL OUTER JOIN [Property] as [Prop] on [Prop].[PropertyID] = [F].[PrimaryPropertyID]
	-- where [P2F].FamilyID is NULL
	--  People to families: 3470

	
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
GO
PRINT N'Altering [dbo].[usp_InsertPerson]...';


GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to insert new people records
-- =============================================
-- DROP PROCEDURE usp_InsertPerson
ALTER PROCEDURE [dbo].[usp_InsertPerson]   -- usp_InsertPerson "Bonifacic",'James','Marco','19750205','M'
	-- Add the parameters for the stored procedure here
	@FirstName varchar(50) = NULL,
	@MiddleName varchar(50) = NULL,
	@LastName varchar(50) = NULL, 
	@BirthDate date = NULL,
	@Gender char(1) = NULL,
	@StatusID smallint = NULL,
	@ForeignTravel bit = NULL,
	@OutofSite bit = NULL,
	@EatsForeignFood bit = NULL,
	@PatientID smallint = NULL,
	@RetestDate datetime = NULL,
	@Moved bit = NULL,
	@MovedDate date = NULL,
	@isClosed bit = 0,
	@isResolved bit = 0,
	@New_Notes varchar(3000) = NULL,
	@GuardianID int = NULL,
	@isSmoker bit = NULL,
	@isClient bit = 1,
	@isNursing bit = 0,
	@isPregnant bit = 0,
	@OverrideDuplicate bit = 0,
	@PID int OUTPUT 
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;

	-- set default retest date if none specified
	IF @RetestDate is null
		SET @RetestDate = DATEADD(yy,1,GetDate());
	
	Select @PID = PersonID from Person where Lastname = @LastName and FirstName = @FirstName AND BirthDate = @BirthDate;
	IF (@PID IS NOT NULL AND @OverrideDuplicate = 0)
	BEGIN
		DECLARE @ErrorString VARCHAR(3000);
		SET @ErrorString ='Person appears to be a duplicate of personID: ' + cast(@PID as varchar(256))
		RAISERROR (@ErrorString, 11, -1);
		RETURN;
	END	

    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into person ( LastName,  FirstName,  MiddleName,  BirthDate,  Gender,  StatusID, 
							  ForeignTravel,  OutofSite,  EatsForeignFood,  PatientID,  RetestDate, 
							  Moved,  MovedDate,  isClosed,  isResolved,  GuardianID,  isSmoker, 
							  isClient, isNursing, isPregnant) 
					 Values (@LastName, @FirstName, @MiddleName, @BirthDate, @Gender, @StatusID,
							 @ForeignTravel, @OutofSite, @EatsForeignFood, @PatientID, @RetestDate,
							 @Moved, @MovedDate, @isClosed, @isResolved,  @GuardianID, @isSmoker, 
							 @isClient, @isNursing, @isPregnant);
		SET @PID = SCOPE_IDENTITY();

		IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonNotes]
								@Person_ID = @PID,
								@Notes = @New_Notes,
								@InsertedNotesID = @NotesID OUTPUT
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
GO
PRINT N'Altering [dbo].[usp_InsertPersontoPerson]...';


GO



-- =============================================
-- Author:		William Thier
-- Create date: 20150323
-- Description:	Stored Procedure to insert 
--              new PersontoPerson records how 
--              they are related
-- =============================================

ALTER PROCEDURE [dbo].[usp_InsertPersontoPerson]   -- usp_InsertPersontoPerson
	-- Add the parameters for the stored procedure here
	@Person1ID int = NULL,
	@Person2ID smallint = NULL,
	@RelationshipType int = NULL,
	@isGuardian bit = NULL, -- True if P1 is guardian of P2
	@isPrimaryContact bit = NULL
	--@EndDate date = NULL,
	--@GroupID varchar(20) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoPerson( Person1ID, Person2ID, RelationshipTypeID, isGuardian, isPrimaryContact ) 
					 Values ( @Person1ID, @Person2ID, @RelationShipType, @isGuardian, @isPrimaryContact )
		 
		 -- Switch isGuardian information to update reciprocal relationship
		 --IF (@isGuardian = 1) SET @isGuardian = 0;
		 --ELSE SET @isGuardian = 1;
		 
		 --INSERT into PersontoPerson (Person1ID, Person2ID, isGuardian) values (@Person2ID, @Person1ID, @isGuardian)

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
GO
PRINT N'Altering [dbo].[usp_InsertProperty]...';


GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new property records
-- =============================================

ALTER PROCEDURE [dbo].[usp_InsertProperty]   -- usp_InsertProperty 
	-- Add the parameters for the stored procedure here
	@ConstructionTypeID tinyint = NULL,
	@AreaID int = NULL,
	@isinHistoricDistrict bit = NULL, 
	@isRemodeled bit = NULL,
	@RemodelDate date = NULL,
	@isinCityLimits bit = NULL,
	-- @StreetNumber smallint = NULL,
	@AddressLine1 varchar(100) = NULL,
	-- @StreetSuffix varchar(20) = NULL,
	@AddressLine2 varchar(100) = NULL,
	@City varchar(50) = NULL,
	@State char(2) = NULL,
	@Zipcode varchar(12) = NULL,
	@YearBuilt date = NULL,
	@Ownerid int = NULL,
	@isOwnerOccuppied bit = NULL,
	@ReplacedPipesFaucets tinyint = 0,
	@TotalRemediationCosts money = NULL,
	@New_PropertyNotes varchar(3000) = NULL,
	@isResidential bit = NULL,
	@isCurrentlyBeingRemodeled bit = NULL,
	@hasPeelingChippingPaint bit = NULL,
	@County varchar(50) = NULL,
	@isRental bit = NULL,
	@OverRideDuplicate bit = 0,
	@PropertyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;
    -- Insert statements for procedure here


	BEGIN TRY
		SELECT @PropertyID =
				--replace(AddressLine1,'.','') = replace(@AddressLine1,'.','') and City = @City 
				--and [State] = @State and Zipcode = @ZipCode
				[dbo].udf_DoesPropertyExist (
						@AddressLine1,
						@City,
						@State,
						@ZipCode
						)

		if (@PropertyID iS NOT NULL AND @OverrideDuplicate = 0)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString = 'Property Address ' + @AddressLine1 + ', ' + @City + ', ' + @State + ', ' + @ZipCode
			                   + ' '  + ' appears to be a duplicate of: ' + cast(@PropertyID as varchar(30));
			RAISERROR (@ErrorString, 11, -1);
--			RAISERROR('@PropertyID exists: @AddressLine1, @City, @State, @ZipCode', 11, -1);
			RETURN;
		END
		 INSERT into property (ConstructionTypeID, AreaID, isinHistoricDistrict, isRemodeled, RemodelDate, 
							  isinCityLimits, AddressLine1, AddressLine2, City, [State], Zipcode,
							  YearBuilt, OwnerID, isOwnerOccuppied, ReplacedPipesFaucets, TotalRemediationCosts,
							  isResidential, isCurrentlyBeingRemodeled, hasPeelingChippingPaint, County, isRental) 
					 Values ( @ConstructionTypeID, @AreaID, @isinHistoricDistrict, @isRemodeled, @RemodelDate, 
							  @isinCityLimits, @AddressLine1, @AddressLine2, @City, @State, @Zipcode,
							  @YearBuilt, @OwnerID, @isOwnerOccuppied, @ReplacedPipesFaucets, @TotalRemediationCosts,
							  @isResidential, @isCurrentlyBeingRemodeled, @hasPeelingChippingPaint, @County, @isRental);
		SET @PropertyID = SCOPE_IDENTITY();

		IF (@New_PropertyNotes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPropertyNotes]
								@Property_ID = @PropertyID,
								@Notes = @New_PropertyNotes,
								@InsertedNotesID = @NotesID OUTPUT
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
GO
PRINT N'Altering [dbo].[usp_upPerson]...';


GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to up new people records
-- =============================================
-- DROP PROCEDURE usp_upPerson
ALTER PROCEDURE [dbo].[usp_upPerson]  
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@New_FirstName varchar(50) = NULL,
	@New_MiddleName varchar(50) = NULL,
	@New_LastName varchar(50) = NULL, 
	@New_BirthDate date = NULL,
	@New_Gender char(1) = NULL,
	@New_StatusID smallint = NULL,
	@New_ForeignTravel bit = NULL,
	@New_OutofSite bit = NULL,
	@New_EatsForeignFood bit = NULL,
	@New_PatientID smallint = NULL,
	@New_RetestDate date = NULL,
	@New_Moved bit = NULL,
	@New_MovedDate date = NULL,
	@New_isClosed bit = 0,
	@New_isResolved bit = 0,
	@New_Notes varchar(3000) = NULL,
	@New_GuardianID int = NULL,
	@New_PersonCode smallint = NULL,
	@New_isSmoker bit = NULL,
	@New_isClient bit = NULL,
	@New_isNursing bit = NULL,
	@New_isPregnant bit = NULL,
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @spupdatePersonsqlStr NVARCHAR(4000);

    -- insert statements for procedure here
	BEGIN TRY
		-- Check if PersonID is valid, if not return
		IF NOT EXISTS (SELECT PersonID from Person where PersonID = @Person_ID)
		BEGIN
			RAISERROR(15000, -1,-1,'usp_upPerson');
		END
		
		-- BUILD update statement
		IF (@New_LastName IS NULL)
			SELECT @New_LastName = LastName from Person where PersonID = @Person_ID;
	
		SELECT @spupdatePersonsqlStr = N'update Person set Lastname = @LastName'

		IF (@New_FirstName IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', FirstName = @Firstname'

		IF (@New_MiddleName IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', MiddleName = @MiddleName'

		IF (@New_BirthDate IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', BirthDate = @BirthDate'

		IF (@New_Gender IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', Gender = @Gender'

		IF (@New_StatusID IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', StatusID = @StatusID'

		IF (@New_ForeignTravel IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', ForeignTravel = @ForeignTravel'

		IF (@New_OutofSite IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', OutofSite = @OutofSite'

		IF (@New_EatsForeignFood IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', EatsForeignFood = @EatsForeignFood'

		IF (@New_PatientID IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', PatientID = @PatientID'

		IF (@New_RetestDate IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', RetestDate = @RetestDate'

		IF (@New_Moved IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', Moved = @Moved'

		IF (@New_MovedDate IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', MovedDate = @MovedDate'

		IF (@New_isClosed IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isClosed = @isClosed'

		IF (@New_isResolved IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isResolved = @isResolved'
			
		IF (@New_GuardianID IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', GuardianID = @GuardianID'
			
		IF (@New_PersonCode IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', PersonCode = @PersonCode'

		IF (@New_isSmoker IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isSmoker = @isSmoker'

		IF (@New_isClient IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isClient = @isClient'

		IF (@New_isNursing IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isNursing = @isNursing'

		IF (@New_isPregnant IS NOT NULL)
			SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N', isPregnant = @isPregnant'

		-- make sure to only update record for specified person
		SELECT @spupdatePersonsqlStr = @spupdatePersonsqlStr + N' WHERE PersonID = @PersonID'

		IF (@DEBUG = 1)
			SELECT @spupdatePersonsqlStr, LastName = @New_LastName, FirstName = @New_FirstName, MiddleName = @New_MiddleName
					, BirthDate = @New_BirthDate, Gender = @New_Gender, StatusID = @New_StatusID, ForeignTravel = @New_ForeignTravel
					, OutofSite = @New_OutofSite, EatsForeignFood = @New_EatsForeignFood, PatientID = @New_PatientID, RetestDate = @New_RetestDate
					, Moved = @New_Moved, MovedDate = @New_MovedDate, isClosed = @New_isClosed, isResolved = @New_isResolved
					, GuardianID = @New_GuardianID, PersonCode = @New_PersonCode, isSmoker = @New_isSmoker, isClient = @New_isClient
					, isNursing = @New_isNursing, isPregnant = @New_isPregnant, PersonID = @Person_ID

		EXEC [sp_executesql] @spupdatePersonsqlStr
				, N'@LastName VARCHAR(50), @FirstName VARCHAR(50), @MiddleName VARCHAR(50), @BirthDate date, @Gender char(1)
				, @StatusID smallint, @ForeignTravel BIT, @OutofSite bit, @EatsForeignFood bit, @PatientID smallint, @RetestDate date
				, @Moved bit, @MovedDate date, @isClosed bit, @isResolved bit, @GuardianID int, @PersonCode smallint, @isSmoker bit
				, @isClient bit, @isNursing bit, @isPregnant bit, @PersonID int'
				, @LastName = @New_LastName
				, @FirstName = @New_FirstName
				, @MiddleName = @New_MiddleName
				, @BirthDate = @New_BirthDate
				, @Gender = @New_Gender
				, @StatusID = @New_StatusID
				, @ForeignTravel = @New_ForeignTravel
				, @OutofSite = @New_OutofSite
				, @EatsForeignFood = @New_EatsForeignFood
				, @PatientID = @New_PatientID
				, @RetestDate = @New_RetestDate
				, @Moved = @New_Moved
				, @MovedDate = @New_MovedDate
				, @isClosed = @New_isClosed
				, @isResolved = @New_isResolved
				, @GuardianID = @New_GuardianID
				, @PersonCode = @New_PersonCode
				, @isSmoker = @New_isSmoker
				, @isClient = @New_isClient
				, @isNursing = @New_isNursing
				, @isPregnant = @New_isPregnant
				, @PersonID = @Person_ID

			IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonNotes]
								@Person_ID = @Person_ID,
								@Notes = @New_Notes,
								@InsertedNotesID = @NotesID OUTPUT
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
GO
PRINT N'Altering [dbo].[usp_InsertNewClientWebScreen]...';


GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141115
-- Description:	stored procedure to insert data from the Add a new client web page
-- =============================================
ALTER PROCEDURE [dbo].[usp_InsertNewClientWebScreen]
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL, 
	@First_Name varchar(50) = NULL,
	@Middle_Name varchar(50) = NULL,
	@Last_Name varchar(50) = NULL,
	@Birth_Date date = NULL,
	@Gender_ char(1) = NULL,
	@Language_ID tinyint = NULL,
	@Ethnicity_ID int = NULL,
	@Moved_ bit = NULL,
	@Travel bit = NULL, --ForeignTravel  REMOVE AFTE MOVING TO ADDNewFamilyWebScreen
	@Travel_Notes varchar(3000) = NULL,  -- REMOVE AFTE MOVING TO ADDNewFamilyWebScreen
	@Out_of_Site bit = NULL, 
	@Hobby_ID smallint = NULL,
	@Hobby_Notes varchar(3000) = NULL,
	@Child_Notes varchar(3000) = NULL,
	@Release_Notes varchar(3000) = NULL,
	@is_Smoker bit = NULL,
	@Occupation_ID smallint = NULL,
	@Occupation_Start_Date date = NULL,
	@OverrideDuplicatePerson bit = 0,
	@is_Client bit = 1,
	@is_Nursing bit = NULL,
	@is_Pregnant bit = NULL,
	@ClientID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
		DECLARE @ErrorLogID int,
				@Ethnicity_return_value int,
				@PersontoFamily_return_value int,
				@PersontoLanguage_return_value int,
				@PersontoHobby_return_value int,
				@PersontoOccupation_return_value int,
				@PersontoEthnicity_return_value int;
	
		-- If no family ID was passed in exit
		IF (@Family_ID IS NULL)
		BEGIN
			RAISERROR ('Family name must be supplied', 11, -1);
			RETURN;
		END;

		-- If the family doesn't exist, return an error
		IF ((select FamilyID from family where FamilyID = @Family_ID) is NULL)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString = 'Unable to associate non-existent family. Family does not exist.'
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END
	
		if (@Last_Name is null)
		BEGIN
			select @Last_Name = Lastname from Family where FamilyID = @Family_ID
		END

		BEGIN TRY  -- insert new person
			EXEC	[dbo].[usp_InsertPerson]
					@FirstName = @First_Name,
					@MiddleName = @Middle_Name,
					@LastName = @Last_Name,
					@BirthDate = @Birth_Date,
					@Gender = @Gender_,
					@Moved = @Moved_,
					@ForeignTravel = @Travel,
					@OutofSite = @Out_of_Site,
					@New_Notes = @Child_Notes,
					@isSmoker = @is_Smoker,
					@isClient = @is_Client,
					@isNursing = @is_Nursing,
					@isPregnant = @is_Pregnant,
					@OverrideDuplicate = @OverrideDuplicatePerson,
					@PID = @CLientID OUTPUT;

			-- Associate person to Ethnicity
			IF (@Ethnicity_ID IS NOT NULL)
			EXEC	@Ethnicity_return_value = [dbo].[usp_InsertPersontoEthnicity]
					@PersonID = @ClientID,
					@EthnicityID = @Ethnicity_ID

			-- Associate person to family
			if (@Family_ID is not NULL)
			EXEC	@PersontoFamily_return_value = usp_InsertPersontoFamily
					@PersonID = @ClientID, @FamilyID = @Family_ID, @OUTPUT = @PersontoFamily_return_value OUTPUT;

			-- Associate person to language
			if (@Language_ID is not NULL)
			EXEC 	@PersontoLanguage_return_value = usp_InsertPersontoLanguage
					@LanguageID = @Language_ID, @PersonID = @ClientID, @isPrimaryLanguage = 1;

			-- associate person to Hobby
			if (@Hobby_ID is not NULL)
			EXEC	@PersontoHobby_return_value = usp_InsertPersontoHobby
					@HobbyID = @Hobby_ID, @PersonID = @ClientID;

			-- associate person to occupation
			if (@Occupation_ID is not NULL)
			EXEC	@PersontoOccupation_return_value = [dbo].[usp_InsertPersontoOccupation]
					@PersonID = @ClientID,
					@OccupationID = @Occupation_ID
		END TRY
		BEGIN CATCH -- insert person
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
		END CATCH; -- insert new person
	END

	IF (@Family_ID is not NULL AND @PersontoFamily_return_value <> 0) 
	BEGIN
		RAISERROR ('Error associating person to family', 11, -1);
		RETURN;
	END
	
	IF (@Hobby_ID is not NULL AND @PersontoHobby_return_value <> 0)
	BEGIN
		RAISERROR ('Error associating person to Hobby', 11, -1);
		RETURN;
	END
	
	IF (@Language_ID is not NULL AND @PersontoLanguage_return_value <> 0) 
	BEGIN
		RAISERROR ('Error associating person to language', 11, -1);
		RETURN;
	END
	
	IF (@Occupation_ID is not NULL and @PersontoOccupation_return_value <> 0)
	BEGIN
		RAISERROR ('Error associating person to occupation', 11, -1);
		RETURN;
	END
END
GO
PRINT N'Altering [dbo].[usp_InsertNewFamilyWebScreen]...';


GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20141115
-- Description:	stored procedure to insert data from the Add a new family web page
-- =============================================
-- 20150102	Fixed bug with family/property association checking
ALTER PROCEDURE [dbo].[usp_InsertNewFamilyWebScreen]
	-- Add the parameters for the stored procedure here
	@FamilyLastName varchar(50) = NULL, 
	@Address_Line1 varchar(100) = NULL,
	@Address_Line2 varchar(100) = NULL,
	@CityName varchar(50) = NULL,
	@StateAbbr char(2) = NULL,
	@ZipCode varchar(10) = NULL,
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
	@Pets tinyint = NULL,
	@Frequently_Wash_Pets bit = NULL,
	@Petsinandout bit = NULL,
	@FamilyNotes varchar(3000) = NULL,
	@PropertyNotes varchar(3000) = NULL,
	@Travel bit = NULL,
	@Travel_Notes varchar(3000) = NULL,
	@Travel_Start_Date varchar(3000) = NULL,
	@Travel_End_Date varchar(3000) = NULL,
	@OverrideDuplicateProperty bit = 0,
	@OverrideDuplicateFamilyPropertyAssociation bit = 0,
	@DEBUG BIT = 0,
	@FamilyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	IF (@FamilyLastName IS NULL
		AND @Address_Line1 IS NULL
		AND @Address_Line2 IS NULL
		AND @HomePhone IS NULL
		AND @WorkPhone IS NULL)
	BEGIN
		RAISERROR ('You must supply at least one of the following: Family name, StreetNumber, Street Name, Street Suffix, Apartment number, Home phone, or Work phone', 11, -1);
		RETURN;
	END;

	BEGIN
		DECLARE @return_value int,
				@PhoneTypeID tinyint, 
				@Family_return_value int,
				@PropID int, @LID tinyint,
				@PhoneNumberID_OUTPUT int,
				@Homephone_return_value int,
				@Workphone_return_value int,
				@NewFamilyNotesID int,
				@TravelNotesReturnValue int,
				@ErrorLogID int;

		BEGIN TRY
			-- Insert the property address if it doesn't already exist
			-- NEED TO RETRIEVE PROPERTY ID IF IT ALREADY EXISTS
			SELECT @PropID = PropertyID from Property where
					replace(AddressLine1,'.','') = replace(@Address_Line1,'.','') and City = @CityName 
					and [State] = @StateAbbr and Zipcode = @ZipCode

			--if (@is_Owner_Occupied = 1) 
			--	select @Owner_id = IDENT_CURRENT('Family')+1

			if ( @PropID is NULL)
			BEGIN -- enter property
				EXEC	[dbo].[usp_InsertProperty] 
						@AddressLine1 = @Address_Line1,
						@AddressLine2 = @Address_Line2,
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
						@OverrideDuplicate = @OverrideDuplicateProperty,
						@PropertyID = @PropID OUTPUT;
					END -- enter property
			-- Check if Family is already associated with property, if so, skip insert and return warning:
			if ((select count(PrimarypropertyID) from Family where LastName = @FamilyLastName and PrimaryPropertyID = @PropID) > 0)
			BEGIN
				if ( @OverrideDuplicateFamilyPropertyAssociation = 1)
				BEGIN
					-- update address in the future??
					RAISERROR ('Family is already associated with that Property', 11, -1);
					RETURN;
				END
-- 				SET @return_value =  
			END
			ELSE
			BEGIN
				EXEC	[dbo].[usp_InsertFamily]
						@LastName = @FamilyLastName,
						@NumberofSmokers = @NumSmokers,
						@PrimaryLanguageID = @Language,
						@Notes = @FamilyNotes,
						@ForeignTravel = @Travel,
						@New_Travel_Notes = @Travel_Notes,
						@Travel_Start_Date = @Travel_Start_Date,
						@Travel_End_Date = @Travel_End_Date,
						@Pets = @Pets,
						@Petsinandout = @Petsinandout,
						@FrequentlyWashPets = @Frequently_Wash_Pets,
						@PrimaryPropertyID = @PropID,
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
PRINT N'Creating [dbo].[Family].[ForeignTravel].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'does the family travel to foreign countries', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Family', @level2type = N'COLUMN', @level2name = N'ForeignTravel';


GO
PRINT N'Refreshing [dbo].[usp_InsertHistoricFamily]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_InsertHistoricFamily]';


GO
PRINT N'Refreshing [dbo].[usp_SLInsertedDataMetaData]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_SLInsertedDataMetaData]';


GO
PRINT N'Refreshing [dbo].[usp_upFamily]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_upFamily]';


GO
PRINT N'Refreshing [dbo].[usp_InsertNewBloodLeadTestResultsWebScreen]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_InsertNewBloodLeadTestResultsWebScreen]';


GO
PRINT N'Refreshing [dbo].[usp_upNewClientWebScreen]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_upNewClientWebScreen]';


GO
PRINT N'Update complete.';


GO