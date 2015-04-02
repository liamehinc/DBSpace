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
/*
The column [dbo].[Property].[ApartmentNumber] is being dropped, data loss could occur.
*/

IF EXISTS (select top 1 1 from [dbo].[Property])
    RAISERROR (N'Rows were detected. The schema update is terminating because data loss might occur.', 16, 127) WITH NOWAIT

GO
PRINT N'Dropping [dbo].[DF_Property_CreatedDate]...';


GO
ALTER TABLE [dbo].[Property] DROP CONSTRAINT [DF_Property_CreatedDate];


GO
PRINT N'Dropping [dbo].[DF_PersontoEthnicity_CreatedDate]...';


GO
ALTER TABLE [dbo].[PersontoEthnicity] DROP CONSTRAINT [DF_PersontoEthnicity_CreatedDate];


GO
PRINT N'Dropping [dbo].[FK_Remediation_Property]...';


GO
ALTER TABLE [dbo].[Remediation] DROP CONSTRAINT [FK_Remediation_Property];


GO
PRINT N'Dropping [dbo].[FK_AccessAgreement_Property]...';


GO
ALTER TABLE [dbo].[AccessAgreement] DROP CONSTRAINT [FK_AccessAgreement_Property];


GO
PRINT N'Dropping [dbo].[FK_ContractortoProperty_Property]...';


GO
ALTER TABLE [dbo].[ContractortoProperty] DROP CONSTRAINT [FK_ContractortoProperty_Property];


GO
PRINT N'Dropping [dbo].[FK_DaycaretoProperty_Property]...';


GO
ALTER TABLE [dbo].[DaycaretoProperty] DROP CONSTRAINT [FK_DaycaretoProperty_Property];


GO
PRINT N'Dropping [dbo].[FK_EmployertoProperty_Property]...';


GO
ALTER TABLE [dbo].[EmployertoProperty] DROP CONSTRAINT [FK_EmployertoProperty_Property];


GO
PRINT N'Dropping [dbo].[FK_EnvironmentalInvestigation_Property]...';


GO
ALTER TABLE [dbo].[EnvironmentalInvestigation] DROP CONSTRAINT [FK_EnvironmentalInvestigation_Property];


GO
PRINT N'Dropping [dbo].[FK_PersontoProperty_Property]...';


GO
ALTER TABLE [dbo].[PersontoProperty] DROP CONSTRAINT [FK_PersontoProperty_Property];


GO
PRINT N'Dropping [dbo].[FK_PropertyNotes_Property]...';


GO
ALTER TABLE [dbo].[PropertyNotes] DROP CONSTRAINT [FK_PropertyNotes_Property];


GO
PRINT N'Dropping [dbo].[FK_PropertySampletResults_Property]...';


GO
ALTER TABLE [dbo].[PropertySampleResults] DROP CONSTRAINT [FK_PropertySampletResults_Property];


GO
PRINT N'Dropping [dbo].[FK_PropertytoCleanupStatus_Property]...';


GO
ALTER TABLE [dbo].[PropertytoCleanupStatus] DROP CONSTRAINT [FK_PropertytoCleanupStatus_Property];


GO
PRINT N'Dropping [dbo].[FK_Property_PropertytoHouseholdSourcesofLead]...';


GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead] DROP CONSTRAINT [FK_Property_PropertytoHouseholdSourcesofLead];


GO
PRINT N'Dropping [dbo].[FK_PropertytoMedium_Property]...';


GO
ALTER TABLE [dbo].[PropertytoMedium] DROP CONSTRAINT [FK_PropertytoMedium_Property];


GO
PRINT N'Dropping [dbo].[FK_Property_Area]...';


GO
ALTER TABLE [dbo].[Property] DROP CONSTRAINT [FK_Property_Area];


GO
PRINT N'Dropping [dbo].[FK_Property_ConstructionType]...';


GO
ALTER TABLE [dbo].[Property] DROP CONSTRAINT [FK_Property_ConstructionType];


GO
PRINT N'Dropping [dbo].[FK_Property_Person]...';


GO
ALTER TABLE [dbo].[Property] DROP CONSTRAINT [FK_Property_Person];


GO
PRINT N'Dropping [dbo].[FK_PersontoEthnicity_Ethnicity]...';


GO
ALTER TABLE [dbo].[PersontoEthnicity] DROP CONSTRAINT [FK_PersontoEthnicity_Ethnicity];


GO
PRINT N'Dropping [dbo].[FK_PersontoEthnicity_Person]...';


GO
ALTER TABLE [dbo].[PersontoEthnicity] DROP CONSTRAINT [FK_PersontoEthnicity_Person];


GO
PRINT N'Starting rebuilding table [dbo].[Property]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_Property] (
    [PropertyID]                INT           IDENTITY (1, 1) NOT NULL,
    [ConstructionTypeID]        TINYINT       NULL,
    [AreaID]                    INT           NULL,
    [isinHistoricDistrict]      BIT           NULL,
    [isRemodeled]               BIT           NULL,
    [RemodelDate]               DATE          NULL,
    [isinCityLimits]            BIT           NULL,
    [StreetNumber]              VARCHAR (15)  NULL,
    [AddressLine1]              VARCHAR (100) NULL,
    [StreetSuffix]              VARCHAR (20)  NULL,
    [AddressLine2]              VARCHAR (100) NULL,
    [City]                      VARCHAR (50)  NULL,
    [State]                     CHAR (2)      NULL,
    [Zipcode]                   VARCHAR (12)  NULL,
    [OwnerID]                   INT           NULL,
    [isOwnerOccuppied]          BIT           NULL,
    [ReplacedPipesFaucets]      TINYINT       NULL,
    [TotalRemediationCosts]     MONEY         NULL,
    [isResidential]             BIT           NULL,
    [isCurrentlyBeingRemodeled] BIT           NULL,
    [hasPeelingChippingPaint]   BIT           NULL,
    [County]                    VARCHAR (50)  NULL,
    [isRental]                  BIT           NULL,
    [HistoricPropertyID]        SMALLINT      NULL,
    [CreatedDate]               DATETIME      CONSTRAINT [DF_Property_CreatedDate] DEFAULT (getdate()) NULL,
    [ModifiedDate]              DATETIME      NULL,
    [YearBuilt]                 DATE          NULL,
    [Street]                    VARCHAR (50)  NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_Property] PRIMARY KEY CLUSTERED ([PropertyID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[Property])
    BEGIN
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Property] ON;
        INSERT INTO [dbo].[tmp_ms_xx_Property] ([PropertyID], [ConstructionTypeID], [AreaID], [isinHistoricDistrict], [isRemodeled], [RemodelDate], [isinCityLimits], [StreetNumber], [AddressLine1], [StreetSuffix], [City], [State], [Zipcode], [OwnerID], [isOwnerOccuppied], [ReplacedPipesFaucets], [TotalRemediationCosts], [isResidential], [isCurrentlyBeingRemodeled], [hasPeelingChippingPaint], [County], [isRental], [HistoricPropertyID], [CreatedDate], [ModifiedDate], [YearBuilt], [Street])
        SELECT   [PropertyID],
                 [ConstructionTypeID],
                 [AreaID],
                 [isinHistoricDistrict],
                 [isRemodeled],
                 [RemodelDate],
                 [isinCityLimits],
                 [StreetNumber],
                 [AddressLine1],
                 [StreetSuffix],
                 [City],
                 [State],
                 [Zipcode],
                 [OwnerID],
                 [isOwnerOccuppied],
                 [ReplacedPipesFaucets],
                 [TotalRemediationCosts],
                 [isResidential],
                 [isCurrentlyBeingRemodeled],
                 [hasPeelingChippingPaint],
                 [County],
                 [isRental],
                 [HistoricPropertyID],
                 [CreatedDate],
                 [ModifiedDate],
                 [YearBuilt],
                 [Street]
        FROM     [dbo].[Property]
        ORDER BY [PropertyID] ASC;
        SET IDENTITY_INSERT [dbo].[tmp_ms_xx_Property] OFF;
    END

DROP TABLE [dbo].[Property];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_Property]', N'Property';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_Property]', N'PK_Property', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Starting rebuilding table [dbo].[PersontoEthnicity]...';


GO
BEGIN TRANSACTION;

SET TRANSACTION ISOLATION LEVEL SERIALIZABLE;

SET XACT_ABORT ON;

CREATE TABLE [dbo].[tmp_ms_xx_PersontoEthnicity] (
    [PersonID]    INT      NOT NULL,
    [EthnicityID] TINYINT  NOT NULL,
    [CreatedDate] DATETIME CONSTRAINT [DF_PersontoEthnicity_CreatedDate] DEFAULT (getdate()) NULL,
    CONSTRAINT [tmp_ms_xx_constraint_PK_PersontoEthnicity_1] PRIMARY KEY CLUSTERED ([PersonID] ASC, [EthnicityID] ASC)
);

IF EXISTS (SELECT TOP 1 1 
           FROM   [dbo].[PersontoEthnicity])
    BEGIN
        INSERT INTO [dbo].[tmp_ms_xx_PersontoEthnicity] ([PersonID], [EthnicityID], [CreatedDate])
        SELECT   [PersonID],
                 [EthnicityID],
                 [CreatedDate]
        FROM     [dbo].[PersontoEthnicity]
        ORDER BY [PersonID] ASC, [EthnicityID] ASC;
    END

DROP TABLE [dbo].[PersontoEthnicity];

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_PersontoEthnicity]', N'PersontoEthnicity';

EXECUTE sp_rename N'[dbo].[tmp_ms_xx_constraint_PK_PersontoEthnicity_1]', N'PK_PersontoEthnicity_1', N'OBJECT';

COMMIT TRANSACTION;

SET TRANSACTION ISOLATION LEVEL READ COMMITTED;


GO
PRINT N'Creating [dbo].[TempPersontoEthnicity]...';


GO
CREATE TABLE [dbo].[TempPersontoEthnicity] (
    [PersonID]    INT      NOT NULL,
    [EthnicityID] TINYINT  NOT NULL,
    [CreatedDate] DATETIME NULL
);


GO
PRINT N'Creating [dbo].[FK_Remediation_Property]...';


GO
ALTER TABLE [dbo].[Remediation] WITH NOCHECK
    ADD CONSTRAINT [FK_Remediation_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_AccessAgreement_Property]...';


GO
ALTER TABLE [dbo].[AccessAgreement] WITH NOCHECK
    ADD CONSTRAINT [FK_AccessAgreement_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_ContractortoProperty_Property]...';


GO
ALTER TABLE [dbo].[ContractortoProperty] WITH NOCHECK
    ADD CONSTRAINT [FK_ContractortoProperty_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_DaycaretoProperty_Property]...';


GO
ALTER TABLE [dbo].[DaycaretoProperty] WITH NOCHECK
    ADD CONSTRAINT [FK_DaycaretoProperty_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_EmployertoProperty_Property]...';


GO
ALTER TABLE [dbo].[EmployertoProperty] WITH NOCHECK
    ADD CONSTRAINT [FK_EmployertoProperty_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_EnvironmentalInvestigation_Property]...';


GO
ALTER TABLE [dbo].[EnvironmentalInvestigation] WITH NOCHECK
    ADD CONSTRAINT [FK_EnvironmentalInvestigation_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_PersontoProperty_Property]...';


GO
ALTER TABLE [dbo].[PersontoProperty] WITH NOCHECK
    ADD CONSTRAINT [FK_PersontoProperty_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_PropertyNotes_Property]...';


GO
ALTER TABLE [dbo].[PropertyNotes] WITH NOCHECK
    ADD CONSTRAINT [FK_PropertyNotes_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_PropertySampletResults_Property]...';


GO
ALTER TABLE [dbo].[PropertySampleResults] WITH NOCHECK
    ADD CONSTRAINT [FK_PropertySampletResults_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_PropertytoCleanupStatus_Property]...';


GO
ALTER TABLE [dbo].[PropertytoCleanupStatus] WITH NOCHECK
    ADD CONSTRAINT [FK_PropertytoCleanupStatus_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_Property_PropertytoHouseholdSourcesofLead]...';


GO
ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead] WITH NOCHECK
    ADD CONSTRAINT [FK_Property_PropertytoHouseholdSourcesofLead] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_PropertytoMedium_Property]...';


GO
ALTER TABLE [dbo].[PropertytoMedium] WITH NOCHECK
    ADD CONSTRAINT [FK_PropertytoMedium_Property] FOREIGN KEY ([PropertyID]) REFERENCES [dbo].[Property] ([PropertyID]);


GO
PRINT N'Creating [dbo].[FK_Property_Area]...';


GO
ALTER TABLE [dbo].[Property] WITH NOCHECK
    ADD CONSTRAINT [FK_Property_Area] FOREIGN KEY ([AreaID]) REFERENCES [dbo].[Area] ([AreaID]);


GO
PRINT N'Creating [dbo].[FK_Property_ConstructionType]...';


GO
ALTER TABLE [dbo].[Property] WITH NOCHECK
    ADD CONSTRAINT [FK_Property_ConstructionType] FOREIGN KEY ([ConstructionTypeID]) REFERENCES [dbo].[ConstructionType] ([ConstructionTypeID]);


GO
PRINT N'Creating [dbo].[FK_Property_Person]...';


GO
ALTER TABLE [dbo].[Property] WITH NOCHECK
    ADD CONSTRAINT [FK_Property_Person] FOREIGN KEY ([OwnerID]) REFERENCES [dbo].[Person] ([PersonID]);


GO
PRINT N'Creating [dbo].[FK_PersontoEthnicity_Ethnicity]...';


GO
ALTER TABLE [dbo].[PersontoEthnicity] WITH NOCHECK
    ADD CONSTRAINT [FK_PersontoEthnicity_Ethnicity] FOREIGN KEY ([EthnicityID]) REFERENCES [dbo].[Ethnicity] ([EthnicityID]);


GO
PRINT N'Creating [dbo].[FK_PersontoEthnicity_Person]...';


GO
ALTER TABLE [dbo].[PersontoEthnicity] WITH NOCHECK
    ADD CONSTRAINT [FK_PersontoEthnicity_Person] FOREIGN KEY ([PersonID]) REFERENCES [dbo].[Person] ([PersonID]);


GO
PRINT N'Creating [dbo].[trUpdateProperty]...';


GO
create trigger trUpdateProperty on Property AFTER UPDATE
	as
	 begin
	  if @@rowcount = 0
		return
	  if not update(ModifiedDate) update Property set ModifiedDate = getdate() where PropertyID in (select PropertyID from inserted)

	end
GO
PRINT N'Altering [dbo].[usp_InsertPersontoEthnicity]...';


GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoEthnicity records
-- =============================================

ALTER PROCEDURE [dbo].[usp_InsertPersontoEthnicity]   -- usp_InsertPersontoEthnicity
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@EthnicityID int = NULL
	--@StartDate date = NULL,
	--@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		INSERT into PersontoEthnicity( PersonID, EthnicityID ) --, StartDate, EndDate)
				Values ( @PersonID, @EthnicityID ) -- , @StartDate, @EndDate);

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
PRINT N'Creating [dbo].[usp_upEthnicity]...';


GO


-- =============================================
-- Author:		William Thier
-- Create date: 20150327
-- Description:	Stored Procedure to update ethnicity records
-- =============================================
-- DROP PROCEDURE usp_upEthnicity
CREATE PROCEDURE [dbo].[usp_upEthnicity] 
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@New_EthnicityID tinyint = NULL,
	@Current_EthnicityID tinyint = NULL,
	@DEBUG BIT = 0,
	@PersontoEthnicityID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @ErrorMessage NVARCHAR(4000), @spupdateEthnicitysqlStr NVARCHAR(4000);

	-- insert statements for procedure here
	BEGIN TRY
		-- Check if PersonID is valid, if not return
		SELECT @Current_EthnicityID = EthnicityID,@PersontoEthnicityID = PersontoEthnicityID from PersontoEthnicity where PersonID = @PersonID

		IF (@Current_EthnicityID IS NULL)
		BEGIN
			SELECT @ErrorMessage = 'PersonID: ' + cast(@PersonID as varchar) + ' does not have an ethnicity specified, inserting a new record'
			
			EXEC usp_InsertPersontoEthnicity 
					@PersonID = @PersonID, 
					@EthnicityID = @New_EthnicityID,
					@PersontoethnicityID = @PersontoEthnicityID OUTPUT;
			RETURN;
		END
		
		-- BUILD update statement
		SELECT @spupdateEthnicitysqlStr = N'update PersontoEthnicity set EthnicityID = @NewEthnicityID 
					where PersonID = @PersonID AND PersontoEthnicityID = @PersontoEthnicityID'
		
		IF (@DEBUG = 1)
			SELECT @spupdateEthnicitysqlStr, 'New_EthnicityID' = @New_EthnicityID, 'PersonID' = @PersonID
				, 'PersontoEthnicityID' = @PersontoEthnicityID

		EXEC [sp_executesql] @spupdateEthnicitysqlStr
				, N'@NewEthnicityID tinyint, @PersonID int, @PersontoEthnicityID int'
				, @NewEthnicityID = @New_EthnicityID
				, @PersonID = @PersonID
				, @PersontoEthnicityID = @PersontoEthnicityID
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
PRINT N'Creating [dbo].[usp_upOccupation]...';


GO



-- =============================================
-- Author:		William Thier
-- Create date: 20150327
-- Description:	Stored Procedure to update occupation records
-- =============================================
-- DROP PROCEDURE usp_upOccupation
CREATE PROCEDURE [dbo].[usp_upOccupation] 
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@OccupationID tinyint = NULL,
	@Occupation_StartDate date = NULL,
	@Occupation_EndDate date = NULL,
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @ErrorMessage NVARCHAR(4000), @Update bit, @spupdateOccupationsqlStr NVARCHAR(4000);

	-- Assume there is nothing to update
	SET @Update = 0;

	-- insert statements for procedure here
	BEGIN TRY
		IF (@PersonID IS NULL OR @OccupationID IS NULL)
		BEGIN
			RAISERROR('Occupation and Person must be specified',11,50000);
			RETURN;
		END

		IF (NOT EXISTS (SELECT PersonID from PersontoOccupation where PersonID = @PersonID AND OccupationID = @OccupationID))
		BEGIN
			SELECT @ErrorMessage = 'Secified person: ' + cast(@PersonID as varchar) + ' is not associated with occupation: ' 
				+ cast(@OccupationID as varchar) +'. Try creating the assocation with usp_InsertPersontoOccupation';
			RAISERROR(@ErrorMessage,8,50000);
			RETURN;
		END
		
		-- BUILD update statement
		SELECT @spupdateOccupationsqlStr = N'update PersontoOccupation Set PersonID = @PersonID'
		
		IF (@Occupation_StartDate IS NOT NULL)
		BEGIN
			SET @Update = 1;
			SELECT @spupdateOccupationsqlStr = @spupdateOccupationsqlStr + ', StartDate = @StartDate'
		END

		IF (@Occupation_StartDate IS NOT NULL)
		BEGIN
			SET @Update = 1;
			SELECT @spupdateOccupationsqlStr = @spupdateOccupationsqlStr + ', ENDDate = @ENDDate'
		END

		IF (@Update = 1)
		BEGIN
			SELECT @spupdateOccupationsqlStr = @spupdateOccupationsqlStr + ' WHERE PersonID = @PersonID and OccupationID = @OccupationID'

			IF (@DEBUG = 1)
				SELECT @spupdateOccupationsqlStr, 'StartDate' = @Occupation_StartDate, 'EndDate' = @Occupation_EndDate,
					'PersonID' = @PersonID, 'OccupationID' = @OccupationID

			EXEC [sp_executesql] @spupdateOccupationsqlStr
					, N'@OccupationID tinyint, @PersonID int, @StartDate date, @EndDate date'
					, @OccupationID = @OccupationID
					, @PersonID = @PersonID
					, @StartDate = @Occupation_StartDate
					, @EndDate = @Occupation_EndDate
		END
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
PRINT N'Creating [dbo].[usp_upNewClientWebScreen]...';


GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150325
-- Description:	stored procedure to update data 
--              from the Add a new client web page
-- =============================================
CREATE PROCEDURE [dbo].[usp_upNewClientWebScreen]
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL,
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
	@New_GuardianID int = NULL,
	@New_PersonCode smallint = NULL,
	@New_isSmoker bit = NULL,
	@New_isClient bit = NULL,
	@New_isNursing bit = NULL,
	@New_isPregnant bit = NULL,
	@New_EthnicityID tinyint = NULL,
	@New_LanguageID tinyint = NULL,
	@New_PrimaryLanguage bit = 1,
	@New_HobbyID int = NULL,
	@New_OccupationID int = NULL,
	@New_Occupation_StartDate date = NULL,
	@New_Occupation_EndDate date = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	BEGIN
		DECLARE @ErrorLogID int,
				@updatePerson_return_value int,
				@Ethnicity_return_value int,
				@PersontoFamily_return_value int,
				@PersontoLanguage_return_value int,
				@PersontoHobby_return_value int,
				@PersontoOccupation_return_value int,
				@PersontoEthnicity_return_value int;
	
		-- If no family ID was passed in exit
		IF (@Family_ID IS NULL OR @Person_ID IS NULL)
		BEGIN
			RAISERROR ('Family and Person must be supplied', 11, -1);
			RETURN;
		END;

		if (@New_LastName is null)
		BEGIN
			select @New_LastName = Lastname from Family where FamilyID = @Family_ID
		END

		BEGIN TRY  -- update person
			EXEC	@updatePerson_return_value = [dbo].[usp_upPerson]
						@Person_ID = @Person_ID,
						@New_FirstName = @New_FirstName,
						@New_MiddleName = @New_MiddleName,
						@New_LastName = @New_LastName,
						@New_BirthDate = @New_BirthDate,
						@New_Gender = @New_Gender,
						@New_StatusID = @New_StatusID,
						@New_ForeignTravel = @New_ForeignTravel,
						@New_OutofSite = @New_OutofSite,
						@New_EatsForeignFood = @New_EatsForeignFood,
						@New_PatientID = @New_PatientID,
						@New_RetestDate = @New_RetestDate,
						@New_Moved = @New_Moved,
						@New_MovedDate = @New_MovedDate,
						@New_isClosed = @New_isClosed,
						@New_isResolved = @New_isResolved,
						@New_GuardianID = @New_GuardianID,
						@New_PersonCode = @New_PersonCode,
						@New_isSmoker = @New_isSmoker,
						@New_isClient = @New_isClient,
						@New_isNursing = @New_isNursing,
						@New_isPregnant = @New_isPregnant,
						@DEBUG = @DEBUG

			-- Associate person to Ethnicity
			IF ((@New_EthnicityID IS NOT NULL) AND
					(NOT EXISTS (SELECT PersonID from PersontoEthnicity where EthnicityID = @New_EthnicityID and PersonID = @Person_ID)))
				EXEC	@Ethnicity_return_value = [dbo].[usp_InsertPersontoEthnicity]
						@PersonID = @Person_ID,
						@EthnicityID = @New_EthnicityID
			-- CODE FOR FUTURE EXTENSIBILITY OF UPDATING ETHNICITY
			--IF (@New_Ethnicity IS NOT NULL)
			--EXEC	@Ethnicity_return_value = [dbo].[usp_upEthnicity]
			--		@PersonID = @Person_ID,
			--		@New_EthnicityID = @New_EthnicityID,
			--		@DEBUG = @DEBUG,
			--		@PersontoEthnicityID = @New_PersontoEthnicityID OUTPUT

			-- Associate person to family
			-- If the person isn't already associated with that family
			if NOT EXISTS(SELECT PersonID from PersontoFamily where FamilyID = @Family_ID and PersonID = @Person_ID)
			EXEC	@PersontoFamily_return_value = usp_InsertPersontoFamily
					@PersonID = @Person_ID, @FamilyID = @Family_ID, @OUTPUT = @PersontoFamily_return_value OUTPUT;

			-- Associate person to language
			IF ((@New_LanguageID is not NULL) AND
				(NOT EXISTS (SELECT PersonID from PersontoLanguage where LanguageID = @New_LanguageID and PersonID = @Person_ID)))
			EXEC 	@PersontoLanguage_return_value = usp_InsertPersontoLanguage
					@LanguageID = @New_LanguageID, @PersonID = @Person_ID, @isPrimaryLanguage = @New_PrimaryLanguage;

			-- associate person to Hobby
			IF ((@New_HobbyID is not NULL) AND 
				(NOT EXISTS (SELECT PersonID from PersontoHobby where HobbyID = @New_HobbyID and PersonID = @Person_ID)) )
			EXEC	@PersontoHobby_return_value = usp_InsertPersontoHobby
					@HobbyID = @New_HobbyID, @PersonID = @Person_ID;

			-- associate person to occupation
			if ((@New_OccupationID is not NULL))
				IF (NOT EXISTS (SELECT PersonID from PersontoOccupation where OccupationID = @New_OccupationID and PersonID = @Person_ID))
				EXEC	@PersontoOccupation_return_value = [dbo].[usp_InsertPersontoOccupation]
						@PersonID = @Person_ID,
						@OccupationID = @New_OccupationID,
						@StartDate = @New_Occupation_StartDate,
						@EndDate = @New_Occupation_EndDate
			ELSE
				EXEC	@PersontoOccupation_return_value = [dbo].[usp_upOccupation]
						@PersonID = @Person_ID,
						@OccupationID = @New_OccupationID,
						@Occupation_StartDate = @New_Occupation_StartDate,
						@Occupation_EndDate = @New_Occupation_EndDate,
						@DEBUG = @DEBUG;
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
END
GO
PRINT N'Creating [dbo].[Property].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'collection of properties and basic attributes', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Property';


GO
PRINT N'Creating [dbo].[Property].[PropertyID].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'unique identifier for the property object', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'Property', @level2type = N'COLUMN', @level2name = N'PropertyID';


GO
PRINT N'Creating [dbo].[PersontoEthnicity].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'linking table for person and ethnicity', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PersontoEthnicity';


GO
PRINT N'Creating [dbo].[PersontoPerson].[isGuardian].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'isGuardian is 1 if P1 is P2''s guardian', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PersontoPerson', @level2type = N'COLUMN', @level2name = N'isGuardian';


GO
PRINT N'Creating [dbo].[PersontoPerson].[isPrimaryContact].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'isPrimaryContact is 1 if P1 is P2''s primaryContact', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PersontoPerson', @level2type = N'COLUMN', @level2name = N'isPrimaryContact';


GO
PRINT N'Creating [dbo].[PersontoPerson].[RelationshipTypeID].[MS_Description]...';


GO
EXECUTE sp_addextendedproperty @name = N'MS_Description', @value = N'relationshipType is how P1 relates to P2', @level0type = N'SCHEMA', @level0name = N'dbo', @level1type = N'TABLE', @level1name = N'PersontoPerson', @level2type = N'COLUMN', @level2name = N'RelationshipTypeID';


GO
PRINT N'Refreshing [dbo].[usp_InsertProperty]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_InsertProperty]';


GO
PRINT N'Refreshing [dbo].[usp_SLInsertedDataMetaData]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_SLInsertedDataMetaData]';


GO
PRINT N'Refreshing [dbo].[usp_InsertNewClientWebScreen]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_InsertNewClientWebScreen]';


GO
PRINT N'Refreshing [dbo].[usp_InsertNewBloodLeadTestResultsWebScreen]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_InsertNewBloodLeadTestResultsWebScreen]';


GO
PRINT N'Refreshing [dbo].[usp_InsertNewFamilyWebScreen]...';


GO
EXECUTE sp_refreshsqlmodule N'[dbo].[usp_InsertNewFamilyWebScreen]';


GO
PRINT N'Checking existing data against newly created constraints';


GO
USE [$(DatabaseName)];


GO
ALTER TABLE [dbo].[Remediation] WITH CHECK CHECK CONSTRAINT [FK_Remediation_Property];

ALTER TABLE [dbo].[AccessAgreement] WITH CHECK CHECK CONSTRAINT [FK_AccessAgreement_Property];

ALTER TABLE [dbo].[ContractortoProperty] WITH CHECK CHECK CONSTRAINT [FK_ContractortoProperty_Property];

ALTER TABLE [dbo].[DaycaretoProperty] WITH CHECK CHECK CONSTRAINT [FK_DaycaretoProperty_Property];

ALTER TABLE [dbo].[EmployertoProperty] WITH CHECK CHECK CONSTRAINT [FK_EmployertoProperty_Property];

ALTER TABLE [dbo].[EnvironmentalInvestigation] WITH CHECK CHECK CONSTRAINT [FK_EnvironmentalInvestigation_Property];

ALTER TABLE [dbo].[PersontoProperty] WITH CHECK CHECK CONSTRAINT [FK_PersontoProperty_Property];

ALTER TABLE [dbo].[PropertyNotes] WITH CHECK CHECK CONSTRAINT [FK_PropertyNotes_Property];

ALTER TABLE [dbo].[PropertySampleResults] WITH CHECK CHECK CONSTRAINT [FK_PropertySampletResults_Property];

ALTER TABLE [dbo].[PropertytoCleanupStatus] WITH CHECK CHECK CONSTRAINT [FK_PropertytoCleanupStatus_Property];

ALTER TABLE [dbo].[PropertytoHouseholdSourcesofLead] WITH CHECK CHECK CONSTRAINT [FK_Property_PropertytoHouseholdSourcesofLead];

ALTER TABLE [dbo].[PropertytoMedium] WITH CHECK CHECK CONSTRAINT [FK_PropertytoMedium_Property];

ALTER TABLE [dbo].[Property] WITH CHECK CHECK CONSTRAINT [FK_Property_Area];

ALTER TABLE [dbo].[Property] WITH CHECK CHECK CONSTRAINT [FK_Property_ConstructionType];

ALTER TABLE [dbo].[Property] WITH CHECK CHECK CONSTRAINT [FK_Property_Person];

ALTER TABLE [dbo].[PersontoEthnicity] WITH CHECK CHECK CONSTRAINT [FK_PersontoEthnicity_Ethnicity];

ALTER TABLE [dbo].[PersontoEthnicity] WITH CHECK CHECK CONSTRAINT [FK_PersontoEthnicity_Person];


GO
PRINT N'Update complete.';


GO