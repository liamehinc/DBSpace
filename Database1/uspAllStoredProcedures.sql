USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[TransProc]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE PROCEDURE [dbo].[TransProc] @PriKey INT, @CharCol CHAR(3) AS
BEGIN TRANSACTION InProc
INSERT INTO TestTrans VALUES (@PriKey, @CharCol)
INSERT INTO TestTrans VALUES (@PriKey + 1, @CharCol)
COMMIT TRANSACTION InProc;

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertAccessAgreement]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new 
--				AccessAgreement records
-- =============================================
-- HISTORY
-- 12/13/2014	modified procedure to accept OUTPUT parameters

CREATE PROCEDURE [dbo].[usp_InsertAccessAgreement]   -- usp_InsertAccessAgreement 
	-- Add the parameters for the stored procedure here
	@AccessPurposeID int = NULL,
	@Notes varchar(3000) = NULL,
	@AccessAgreementFile varbinary(max) = NULL,
	@PropertyID int = NULL,
	@InsertedAccessAgreementID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into AccessAgreement (AccessPurposeID, AccessAgreementFile, PropertyID) 
					 Values ( @AccessPurposeID, @AccessAgreementFile, @PropertyID);
		SELECT @InsertedAccessAgreementID = SCOPE_IDENTITY();

		IF (@NOTES IS NOT NULL)
		BEGIN TRY 
			INSERT into AccessAgreementNotes (AccessAgreementID, Notes)
					Values (@InsertedAccessAgreementID, @Notes)
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
		END CATCH;
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
/****** Object:  StoredProcedure [dbo].[usp_InsertAccessPurpose]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new AccessPurpose records
-- =============================================
-- HISTORY
-- 12/13/2014	modified procedure to accept OUTPUT parameters

CREATE PROCEDURE [dbo].[usp_InsertAccessPurpose]   -- usp_InsertAccessPurpose 
	-- Add the parameters for the stored procedure here
	@AccessPurposeName varchar(50) = NULL,
	@AccessPurposeDescription varchar(250) = NULL,
	@AccessPurposeID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into AccessPurpose ( AccessPurposeName, AccessPurposeDescription)
					 Values ( @AccessPurposeName, @AccessPurposeDescription);
		SELECT @AccessPurposeID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertArea]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Area records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertArea]   -- usp_InsertArea 
	-- Add the parameters for the stored procedure here
	@AreaDescription varchar(250) = NULL,
	@AreaName varchar(50) = NULL,
	@NewAreaID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;

    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Area ( AreaDescription, AreaName)
					 Values ( @AreaDescription, @AreaName);
		SELECT @NewAreaID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertBloodTestResults]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new BloodTestResults records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertBloodTestResults]   -- usp_InsertBloodTestResults 
	-- Add the parameters for the stored procedure here
	@isBaseline bit = NULL,
	@PersonID int = NULL,
	@SampleDate date = NULL,
	@LabSubmissionDate date = NULL,
	@LeadValue numeric(9,4) = NULL,
	@LeadValueCategoryID tinyint = NULL,
	@HemoglobinValue numeric(9,4) = NULL,
	@HemoglobinValueCategoryID tinyint = NULL, -- lookup in the database
	@HematocritValueCategoryID tinyint = NULL, -- lookup in the database
	@LabID int = NULL,
	@BloodTestCosts money = NULL,
	@sampleTypeID tinyint = NULL,
	@New_Notes varchar(3000) = NULL,
	@TakenAfterPropertyRemediationCompleted bit = NULL,
	@BloodTestResultID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ExistsPersonID int -- does the person have a record in BloodTestResults table
			, @ErrorLogID int, @NotesID int;
	-- Handle Null sampleDate?
	-- Handle Null LabSubmissionDate?

	-- check if the person exists
	IF NOT EXISTS (select PersonID from Person where PersonID = @PersonID)
	BEGIN
		RAISERROR ('Person does not exist. Cannot create a BloodtestResult record', 11, -1);
		RETURN;
	END

	-- check if the person has a record in BloodTestResults Table
	select @ExistsPersonID = PersonID from BloodTestResults

    -- Insert statements for procedure here
	BEGIN TRY
		-- Determine if this person already has an entry in BloodTestResults and set isBaseline appropriately.
		IF ( @isBaseline is NULL ) -- nothing passed in for baseline
		BEGIN
			IF  ( @ExistsPersonID is not NULL )
			BEGIN
				SET @isBaseline = 0;
			END
			ELSE -- the person has no entry in BloodTestResults, this is a baseline entry
			BEGIN
				SET @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 0 ) -- this should not be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPersonID is NULL)  -- the person does not have an entry in BloodTestResults, this is a baseline entry
			BEGIN
				Set @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 1 ) -- this should be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPersonID is not NULL)  -- the person already has an entry in BloodTestResults, this isn't a baseline entry
			BEGIN
				Set @isBaseline = 0;
			END
		END 

		 INSERT into BloodTestResults ( isBaseline, PersonID, SampleDate, LabSubmissionDate, LeadValue, LeadValueCategoryID,
		                                HemoglobinValue, HemoglobinValueCategoryID, HematocritValueCategoryID, LabID,
										BloodTestCosts, SampleTypeID, TakenAfterPropertyRemediationCompleted)
					 Values ( @isBaseline, @PersonID, @SampleDate, @LabSubmissionDate, @LeadValue, @LeadValueCategoryID,
		                      @HemoglobinValue, @HemoglobinValueCategoryID, @HematocritValueCategoryID, @LabID,
							  @BloodTestCosts, @SampleTypeID, @TakenAfterPropertyRemediationCompleted);
		SELECT @BloodTestResultID = SCOPE_IDENTITY();

		IF (@New_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertBloodTestResultsNotes]
							@BloodtestResults_ID = @BloodTestResultID,
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
/****** Object:  StoredProcedure [dbo].[usp_InsertBloodTestResultsNotes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert BloodTestResults notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertBloodTestResultsNotes] 
	-- Add the parameters for the stored procedure here
	@BloodTestResults_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update BloodTestResults information
		INSERT INTO BloodTestResultsNotes (BloodTestResultsID, Notes) 
				values (@BloodTestResults_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertCleanupStatus]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new CleanupStatus records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertCleanupStatus]   -- usp_InsertCleanupStatus 
	-- Add the parameters for the stored procedure here
	@CleanupStatusDescription varchar(200) = NULL,
	@CleanupStatusName varchar(25) = NULL,
	@NewCleanupStatusID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into CleanupStatus ( CleanupStatusDescription, CleanupStatusName)
					 Values ( @CleanupStatusDescription, @CleanupStatusName);
		SELECT @NewCleanupStatusID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertConstructionType]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ConstructionType records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertConstructionType]   -- usp_InsertConstructionType 
	-- Add the parameters for the stored procedure here
	@ConstructionTypeDescription varchar(250) = NULL,
	@ConstructionTypeName varchar(50) = NULL,
	@NewConstructionTypeID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ConstructionType ( ConstructionTypeDescription, ConstructionTypeName)
					 Values ( @ConstructionTypeDescription, @ConstructionTypeName);
		SELECT @NewConstructionTypeID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertContractor]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Contractor records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertContractor]   -- usp_InsertContractor 
	-- Add the parameters for the stored procedure here
	@ContractorDescription varchar(250) = NULL,
	@ContractorName varchar(50) = NULL,
	@NewContractorID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Contractor ( ContractorDescription, ContractorName)
					 Values ( @ContractorDescription, @ContractorName);
		SELECT @NewContractorID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertContractortoProperty]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ContractortoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertContractortoProperty]   -- usp_InsertContractortoProperty 
	-- Add the parameters for the stored procedure here
	@ContractorID int = NULL,
	@PropertyID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ContractortoProperty ( ContractorID, PropertyID, StartDate, EndDate)
					 Values ( @ContractorID, @PropertyID, @StartDate, @EndDate);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertContractortoRemediation]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ContractortoRemediation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertContractortoRemediation]   -- usp_InsertContractortoRemediation 
	-- Add the parameters for the stored procedure here
	@ContractorID int = NULL,
	@RemediationID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@isSubContractor bit = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ContractortoRemediation ( ContractorID, RemediationID, StartDate, EndDate, isSubContractor)
					 Values ( @ContractorID, @RemediationID, @StartDate, @EndDate, @isSubContractor);
		SELECT SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertContractortoRemediationActionPlan]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ContractortoRemediationPlan records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertContractortoRemediationActionPlan]   -- usp_InsertContractortoRemediationPlan 
	-- Add the parameters for the stored procedure here
	@ContractorID int = NULL,
	@RemediationActionPlanID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@isSubContractor bit = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ContractortoRemediationActionPlan ( ContractorID, RemediationActionPlanID, StartDate, EndDate, isSubContractor)
					 Values ( @ContractorID, @RemediationActionPlanID, @StartDate, @EndDate, @isSubContractor);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertCountry]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Country records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertCountry]   -- usp_InsertCountry 
	-- Add the parameters for the stored procedure here
	@CountryName varchar(50) = NULL,
	@NewCountryID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Country ( CountryName)
					 Values ( @CountryName);
		SELECT @NewCountryID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertDaycare]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Daycare records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertDaycare]   -- usp_InsertDaycare 
	-- Add the parameters for the stored procedure here
	@DaycareName varchar(50) = NULL,
	@DaycareDescription varchar(200) = NULL,
	@newDayCareID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Daycare ( DaycareName, DaycareDescription )
					 Values ( @DaycareName, @DaycareDescription );
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
/****** Object:  StoredProcedure [dbo].[usp_InsertDaycarePrimaryContact]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new DaycarePrimaryContact records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertDaycarePrimaryContact]   -- usp_InsertDaycarePrimaryContact 
	-- Add the parameters for the stored procedure here
	@DaycareID int = NULL,
	@PersonID int = NULL,
	@ContactPriority tinyint = NULL,
	@PrimaryPhoneNumberID int = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into DaycarePrimaryContact ( DayCareID, PersonID, ContactPriority, PrimaryPhoneNumberID )
					 Values ( @DayCareID, @PersonID, @ContactPriority, @PrimaryPhoneNumberID );
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
/****** Object:  StoredProcedure [dbo].[usp_InsertDaycaretoProperty]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new DaycaretoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertDaycaretoProperty]   -- usp_InsertDaycaretoProperty 
	-- Add the parameters for the stored procedure here
	@DaycareID int = NULL,
	@PropertyID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into DaycaretoProperty ( DaycareID, PropertyID, StartDate, EndDate)
					 Values ( @DaycareID, @PropertyID, @StartDate, @EndDate);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertEmployer]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Employer records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertEmployer]   -- usp_InsertEmployer 
	-- Add the parameters for the stored procedure here
	@EmployerName VARCHAR(50) = NULL,
	@NewEmployerID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Employer ( EmployerName )
					 Values ( @EmployerName );
		SELECT @NewEmployerID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertEmployertoProperty]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new EmployertoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertEmployertoProperty]   -- usp_InsertEmployertoProperty 
	-- Add the parameters for the stored procedure here
	@EmployerID int = NULL,
	@PropertyID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into EmployertoProperty ( EmployerID, PropertyID, StartDate, EndDate)
					 Values ( @EmployerID, @PropertyID, @StartDate, @EndDate);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertEnvironmentalInvestigation]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new EnvironmentalInvestigation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertEnvironmentalInvestigation]   -- usp_InsertEnvironmentalInvestigation 
	-- Add the parameters for the stored procedure here
	@ConductEnvironmentalInvestigation bit = NULL,
	@ConductEnvironmentalInvestigationDecisionDate date = NULL,
	@Cost money = NULL,
	@EnvironmentalInvestigationDate date = NULL,
	@PropertyID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@NewEnvironmentalInvestigation int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into EnvironmentalInvestigation ( ConductEnvironmentalInvestigation, ConductEnvironmentalInvestigationDecisionDate,
		                                          Cost, EnvironmentalInvestigationDate, PropertyID, StartDate, EndDate )
					 Values ( @ConductEnvironmentalInvestigation, @ConductEnvironmentalInvestigationDecisionDate,
		                      @Cost, @EnvironmentalInvestigationDate, @PropertyID, @StartDate, @EndDate  );
		SELECT @NewEnvironmentalInvestigation = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertEthnicity]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Ethnicity records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertEthnicity]   -- usp_InsertEthnicity 
	-- Add the parameters for the stored procedure here
	@Ethnicity varchar(50) = NULL,
	@NewEthnicityID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Ethnicity ( Ethnicity )
					 Values ( @Ethnicity );
		SELECT @NewEthnicityID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertFamily]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140205
-- Description:	Stored Procedure to insert new Family information
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertFamily]  
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
/****** Object:  StoredProcedure [dbo].[usp_InsertFamilyNotes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150214
-- Description:	stored procedure to insert family notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertFamilyNotes] 
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Family information
		INSERT INTO FamilyNotes (FamilyID, Notes) 
				values (@Family_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER();
	END CATCH; 
END
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertFamilytoPhoneNumber]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO




-- =============================================
-- Author:		William Thier
-- Create date: 20150404
-- Description:	Stored Procedure to insert new 
--				FamilytoPhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertFamilytoPhoneNumber]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL,
	@PhoneNumberID int = NULL,
	@NumberPriority tinyint = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into FamilytoPhoneNumber( FamilyID, PhoneNumberID, NumberPriority)
					 Values ( @FamilyID, @PhoneNumberID, @NumberPriority )
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
/****** Object:  StoredProcedure [dbo].[usp_InsertForeignFood]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ForeignFood records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertForeignFood]   -- usp_InsertForeignFood 
	-- Add the parameters for the stored procedure here
	@ForeignFoodName varchar(50) = NULL,
	@ForeignFoodDescription varchar(256) = NULL,
	@NewForeignFoodID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ForeignFood ( ForeignFoodName, ForeignFoodDescription )
					 Values ( @ForeignFoodName, @ForeignFoodDescription );
		SELECT @NewForeignFoodID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertForeignFoodtoCountry]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new ForeignFoodtoCountry records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertForeignFoodtoCountry]   -- usp_InsertForeignFoodtoCountry 
	-- Add the parameters for the stored procedure here
	@ForeignFoodID int = NULL,
	@CountryID tinyint = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into ForeignFoodtoCountry ( ForeignFoodID, CountryID ) --, StartDate, EndDate)
					 Values ( @ForeignFoodID, @CountryID ) -- , @StartDate, @EndDate);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertGiftCard]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new GiftCard records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertGiftCard]   -- usp_InsertGiftCard 
	-- Add the parameters for the stored procedure here
	@GiftCardValue money = NULL,
	@IssueDate date = NULL,
	@PersonID int = NULL,
	@NewGiftCardID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here

	BEGIN TRY
		IF EXISTS (SELECT PersonID from Person where PersonID = @PersonID) print 'Person exists'
		 INSERT into GiftCard ( GiftCardValue, IssueDate, PersonID )
					 Values ( @GiftCardValue, @IssueDate, @PersonID );
		SELECT @NewGiftCardID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertHistoricFamily]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140205
-- Description:	Stored Procedure to insert Family names from existing database
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertHistoricFamily]  
	-- Add the parameters for the stored procedure here
	@LastName varchar(50),
	@NumberofSmokers tinyint = 0,
	@PrimaryLanguageID tinyint = 1,
	@Notes varchar(3000) = NULL,
	@Pets bit = 0,
	@inandout bit = NULL,
	@HistoricFID  smallint = NULL,
	@PrimaryPropertyID int,
	@FID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @DBNAME NVARCHAR(128), @ErrorLogID int;
	SET @DBNAME = DB_NAME();

	BEGIN TRY -- insert Family
		INSERT into Family ( LastName,  NumberofSmokers,  PrimaryLanguageID,  Notes, Pets, inandout
		            , HistoricFamilyID, PrimaryPropertyID) 
		            Values (@LastName, @NumberofSmokers, @PrimaryLanguageID, @Notes, @Pets, @inandout
					, @HistoricFID, @PrimaryPropertyID)
		SET @FID = SCOPE_IDENTITY();  -- uncomment to return primary key of inserted values
	END TRY -- insert Family
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
/****** Object:  StoredProcedure [dbo].[usp_InsertHobby]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Hobby records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertHobby]   -- usp_InsertHobby 
	-- Add the parameters for the stored procedure here
	@HobbyName varchar(50) = NULL,
	@HobbyDescription varchar(256) = NULL,
	@LeadExposure bit = NULL,
	@NewHobbyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Hobby ( HobbyName, HobbyDescription, LeadExposure )
					 Values ( @HobbyName, @HobbyDescription, @LeadExposure );
		SELECT @NewHobbyID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertHomeRemedies]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new HomeRemedies records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertHomeRemedies]   -- usp_InsertHomeRemedies 
	-- Add the parameters for the stored procedure here
	@HomeRemedyName varchar(50) = NULL,
	@HomeRemedyDescription varchar(256) = NULL,
	@NewHomeRemedyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into HomeRemedy ( HomeRemedyName, HomeRemedyDescription )
					 Values ( @HomeRemedyName, @HomeRemedyDescription );
		SELECT @NewHomeRemedyID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertHouseholdSourcesofLead]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new HouseholdSourcesofLead records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertHouseholdSourcesofLead]   -- usp_InsertHouseholdSourcesofLead 
	-- Add the parameters for the stored procedure here
	@HouseholdItemName varchar(50) = NULL,
	@HouseholdItemDescription varchar(512) = NULL,
	@NewHouseholdItemID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into HouseholdSourcesofLead ( HouseholdItemName, HouseholdItemDescription )
					 Values ( @HouseholdItemName, @HouseholdItemDescription );
		SELECT @NewHouseholdItemID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertInsuranceProvider]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new InsuranceProvider records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertInsuranceProvider]   -- usp_InsertInsuranceProvider 
	-- Add the parameters for the stored procedure here
	@InsuranceProviderName varchar(50) = NULL,
	@NewInsuranceProviderID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into InsuranceProvider ( InsuranceProviderName ) --, HouseholdItemDescription )
					 Values ( @InsuranceProviderName ) -- , @HouseholdItemDescription );
		SELECT @NewInsuranceProviderID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertLab]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Lab records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertLab]   -- usp_InsertLab 
	-- Add the parameters for the stored procedure here
	@LabName varchar(50) = NULL,
	@LabDescription varchar(250) = NULL,
	@New_Lab_Notes varchar(3000) = NULL,
	@NewLabID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Lab ( LabName, LabDescription )
					 Values ( @LabName, @LabDescription );
		SELECT @NewLabID = SCOPE_IDENTITY();

		IF (@New_Lab_Notes IS NOT NULL)
		EXEC	[dbo].[usp_InsertLabNotes]
							@Lab_ID = @NewLabID,
							@Notes = @New_Lab_Notes,
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
/****** Object:  StoredProcedure [dbo].[usp_InsertLabNotes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert Lab notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertLabNotes] 
	-- Add the parameters for the stored procedure here
	@Lab_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Lab information
		INSERT INTO LabNotes (LabID, Notes) 
				values (@Lab_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertLanguage]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to insert new Languages
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertLanguage]   -- usp_InsertLanguage "Italian"
	-- Add the parameters for the stored procedure here
	@LanguageName varchar(50),
	@LANGUAGEID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @DBNAME NVARCHAR(128), @ErrorLogID int;
	SET @DBNAME = DB_NAME();

	BEGIN TRY
	     if Exists (select LanguageName from language where LanguageName = @LanguageName) 
		 BEGIN
		 RAISERROR
			(N'The language: %s already exists.',
			11, -- Severity.
			1, -- State.
			@LanguageName);
		 END
	
		INSERT into Language (LanguageName) Values (upper(@LanguageName))
		SET @LANGUAGEID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertMedium]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Medium records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertMedium]   -- usp_InsertMedium 
	-- Add the parameters for the stored procedure here
	@MediumName varchar(50) = NULL,
	@MediumDescription varchar(250) = NULL,
	@TriggerLevel int = NULL,
	@TriggerLevelUnitsID smallint = NULL,
	@NewMediumID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Medium ( MediumName, MediumDescription, TriggerLevel, TriggerLevelUnitsID )
					 Values ( @MediumName, @MediumDescription, @TriggerLevel, @TriggerLevelUnitsID );
		SELECT @NewMediumID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertMediumSampleResults]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new MediumSampleResults records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertMediumSampleResults]   -- usp_InsertMediumSampleResults 
	-- Add the parameters for the stored procedure here
	@MediumID int = NULL,
	@MediumSampleValue numeric(9,4) = NULL,
	@UnitsID smallint = NULL,
	@SampleLevelCategoryID tinyint = NULL,
	@MediumSampleDate date = getdate,
	@LabID int = NULL,
	@LabSubmissionDate date = getdate,
	@Notes varchar(3000) = NULL,
	@IsAboveTriggerLevel bit = NULL,
	@NewMediumSampleResultsID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @TriggerlevelUnitsID smallint, @TriggerLevel numeric(9,4);
    -- Insert statements for procedure here
	-- See if Value is above Trigger Level - initially assume units are identical
	-- Determine Trigger level units and Trigger Level
	Select @TriggerLevel = M.TriggerLevel , @TriggerLevelUnitsID = M.TriggerLevelUnitsID FROM MediumSampleresults AS MSR 
		JOIN Medium as M on M.MediumID = MSR.MediumID 
		JOIN Units AS TLU on M.TriggerLevelUnitsID = TLU.UnitsID;

	-- IF the units are the same, 
	IF (@UnitsID = @TriggerlevelUnitsID )
	BEGIN
		print 'units are identical comparing values'
		IF ( @MediumSampleValue < @TriggerLevel ) 
			SET @IsAboveTriggerLevel = 0;
		ELSE 
			SET @IsAboveTriggerLevel = 1;
	END
	ELSE  
		print 'consider converting values to the same units'


	BEGIN TRY
		 INSERT into MediumSampleResults ( MediumID, MediumSampleValue, UnitsID, SampleLevelCategoryID, MediumSampleDate, LabID,
		                                   LabSubmissionDate, Notes, IsAboveTriggerLevel )
					 Values ( @MediumID, @MediumSampleValue, @UnitsID, @SampleLevelCategoryID, @MediumSampleDate, @LabID,
		                      @LabSubmissionDate, @Notes, @IsAboveTriggerLevel );
		SELECT @NewMediumSampleResultsID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertNewBloodLeadTestResultsWebScreen]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141217
-- Description:	stored procedure to insert data retrieved from 
--				the Blood Lead Test Results web screen
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertNewBloodLeadTestResultsWebScreen] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL, 
	@Sample_Date date = NULL,
	@Lab_Date date = Null,
	@Blood_Lead_Result numeric(9,4)= NULL, -- Is this Lead value?
	@Flag INT = 365, -- flag follow up date
	@Test_Type tinyint = NULL, -- SampleTypeID need to determine if/how new testTypes are created
	@Lab varchar(50) = NULL,  -- is this necessary i think the lab should be selected from a drop down with the option to add a new lab and an id should be passed?
	@Lab_ID int = NULL,
	@Child_Status_Code smallint = NULL, -- StatusID need to determine if/how new statusCodes are created
	@Child_Status_Date date = NULL,
	@Hemoglobin_Value numeric(9,4) = NULL,
	@DEBUG bit = 0,
	@Blood_Test_Results_ID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @BloodTestResult_return_value int, @RetestDate_return_value int
			,@Retest_Date date, @ChildStatusCode_return_value int, @ErrorLogID int;

	-- set default date if necessary 
	IF (@Sample_Date is null) 
	BEGIN
		set @Sample_Date = GetDate();
		RAISERROR ('Need to specify the SampleDate, setting to today by default', 5, 0);
	END
	
	IF (@Person_ID IS NULL)
	BEGIN
		RAISERROR ('Client name must be supplied', 11, -1);
		RETURN;
	END;
	BEGIN TRY
		EXEC	@BloodTestResult_return_value = [dbo].[usp_InsertBloodTestResults]
				@isBaseline = NULL,
				@PersonID = @Person_ID,
				@SampleDate = @Sample_Date,
				@LabSubmissionDate = @Lab_Date,
				@LeadValue = @Blood_Lead_Result,
				@LeadValueCategoryID = NULL,
				@HemoglobinValue = @Hemoglobin_Value,
				@HemoglobinValueCategoryID = NULL,
				@HematocritValueCategoryID = NULL,
				@LabID = @Lab_ID,
				@BloodTestCosts = NULL,
				@sampleTypeID = @Test_Type,
				@New_Notes = NULL,
				@TakenAfterPropertyRemediationCompleted = NULL,
				@BloodTestResultID = @Blood_Test_Results_ID OUTPUT

		IF (@Child_Status_Code IS NOT NULL)
		BEGIN
			IF (@Child_Status_Date IS NULL)
				SELECT @Child_Status_Date = GetDate();
			IF @DEBUG = 1
				SELECT '@ChildStatusCode_return_value = [dbo].[usp_InsertPersontoStatus] @PersonID = @Person_ID, @StatusID = @Child_Status_Code, @StatusDate = @Child_Status_Date' 
							,@Person_ID , @Child_Status_Code, @Child_Status_Date

			EXEC	@ChildStatusCode_return_value = [dbo].[usp_InsertPersontoStatus]
					@PersonID = @Person_ID,
					@StatusID = @Child_Status_Code,
					@StatusDate = @Child_Status_Date
		END

		-- set the retest date based on integer value passed in as Flag
		SET @Retest_Date = DATEADD(dd,@Flag,@Sample_Date);

		-- update Person table with the new retest date
		EXEC	@RetestDate_return_value = [dbo].[usp_upPerson]
				@Person_ID = @Person_ID,
				@New_RetestDate = @Retest_Date;
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
/****** Object:  StoredProcedure [dbo].[usp_InsertNewClientWebScreen]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141115
-- Description:	stored procedure to insert data from the Add a new client web page
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertNewClientWebScreen]
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
					@Release_Notes = @Hobby_Notes,  --- CHANGE TO @PersonRelease_Notes
					@Travel_Notes = @Travel_Notes,
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
/****** Object:  StoredProcedure [dbo].[usp_InsertNewFamilyWebScreen]    Script Date: 4/13/2015 11:30:48 PM ******/
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
	@HomePhonePriority tinyint = NULL,
	@WorkPhone bigint = NULL,
	@WorkPhonePriority tinyint = NULL,
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
				@Homephone_return_value int,
				@Workphone_return_value int,
				@NewFamilyNotesID int,
				@TravelNotesReturnValue int,
				@ErrorLogID int;

		BEGIN TRY
			-- Insert the property address if it doesn't already exist
			-- NEED TO RETRIEVE PROPERTY ID IF IT ALREADY EXISTS
			SELECT @PropID = PropertyID from Property where
					(dbo.RemoveSpecialChars(AddressLine1) = dbo.RemoveSpecialChars(@Address_Line1))
					AND (dbo.RemoveSpecialChars(AddressLine2) = dbo.RemoveSpecialChars(@Address_Line2))
					AND (City = @CityName )
					and ([State] = @StateAbbr and Zipcode = @ZipCode)

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
				DECLARE @HomePhoneNumberID_OUTPUT bigint;

				SELECT @PhoneTypeID = PhoneNumberTypeID from PhoneNumberType where PhoneNumberTypeName = 'Home Phone';
				
				IF (@DEBUG = 1)
					SELECT 'EXEC	[dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @HomePhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@DEBUG = @DEBUG,
						@PhoneNumberID_OUTPUT = @HomePhoneNumberID_OUTPUT OUTPUT', @HomePhone, @PhoneTypeID, @DEBUG

				EXEC	@Homephone_return_value = [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @HomePhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@DEBUG = @DEBUG,
						@PhoneNumberID_OUTPUT = @HomePhoneNumberID_OUTPUT OUTPUT
				
				IF (@DEBUG = 1)
					SELECT 'EXEC	[dbo].[usp_InsertFamilytoPhoneNumber] 
						@FamilyID = @FamilyID,
						@NumberPriority = @HomePhonePriority,
						@PhoneNumberID = @HomePhoneNumberID_OUTPUT,
						@DEBUG = @DEBUG', @FamilyID, @WorkPhonePriority, @DEBUG
				
				EXEC	[dbo].[usp_InsertFamilytoPhoneNumber] 
						@FamilyID = @FamilyID,
						@NumberPriority = @HomePhonePriority,
						@PhoneNumberID = @HomePhoneNumberID_OUTPUT,
						@DEBUG = @DEBUG
			END  -- insert Home Phone

			if (@WorkPhone is not NULL) 
			BEGIN  -- insert Work Phone
				DECLARE @WorkPhoneNumberID_OUTPUT bigint;

				SELECT @PhoneTypeID = PhoneNumberTypeID from PhoneNumberType where PhoneNumberTypeName = 'Work Phone';

				IF (@DEBUG = 1)
					SELECT 'EXEC	[dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @WorkPhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@DEBUG = @DEBUG,
						@PhoneNumberID_OUTPUT = @WorkPhoneNumberID_OUTPUT OUTPUT', @WorkPhone, @PhoneTypeID, @DEBUG

				EXEC	@Workphone_return_value = [dbo].[usp_InsertPhoneNumber]
						@PhoneNumber = @WorkPhone,
						@PhoneNumberTypeID = @PhoneTypeID,
						@DEBUG = @DEBUG,
						@PhoneNumberID_OUTPUT = @WorkPhoneNumberID_OUTPUT OUTPUT

				IF (@DEBUG = 1)
					SELECT 'EXEC	[dbo].[usp_InsertFamilytoPhoneNumber] 
						@FamilyID = @FamilyID,
						@NumberPriority = @WorkPhonePriority,
						@PhoneNumberID = @WorkPhoneNumberID_OUTPUT,
						@DEBUG = @DEBUG', @FamilyID, @WorkPhonePriority, @WorkPhoneNumberID_OUTPUT, @DEBUG

				EXEC	[dbo].[usp_InsertFamilytoPhoneNumber] 
						@FamilyID = @FamilyID,
						@NumberPriority = @WorkPhonePriority,
						@PhoneNumberID = @WorkPhoneNumberID_OUTPUT,
						@DEBUG = @DEBUG
						
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
/****** Object:  StoredProcedure [dbo].[usp_InsertNewQuestionnaireWebScreen]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20141208
-- Description:	stored procedure to insert data 
--              from the Lead Research Subject Questionnaire web page
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertNewQuestionnaireWebScreen]
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@QuestionnaireDate date = NULL,
	@PaintPeeling bit = NULL,
	@PaintDate date = NULL, 
	@VisitRemodel bit = NULL,
	@RemodelDate date = NULL, 
	@Vitamins bit = NULL,
	@HandWash bit = NULL,
	@Bottle bit = NULL,
	@Nursing bit = NULL,
	@Pacifier bit = NULL,
	@BitesNails bit = NULL,
	@EatsOutdoors bit = NULL, 
	@NonFoodInMouth bit = NULL,
	@EatsNonFood bit = NULL,
	@SucksThumb bit = NULL,
	@Mouthing bit = NULL,
	@Daycare bit = NULL,
	@DayCareNotes varchar(3000) = NULL,
	@Source int = NULL,
	@QuestionnaireNotes varchar(3000) = NULL,
	@Questionnaire_return_value int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int; 

	BEGIN TRY
		-- set default date if necessary 
		IF (@QuestionnaireDate is null) 
		BEGIN
			print 'Need to specify QuestionnaireDate, setting to today by defualt';
			set @QuestionnaireDate = GetDate();
		END

		IF (@Person_ID IS NULL)
		BEGIN
			RAISERROR ('Client name must be supplied', 11, -1);
			RETURN;
		END;

		-- Client ID must already exist in the database
		IF ( (select PersonID from person where personID = @Person_ID ) is NULL)
		BEGIN
			RAISERROR ('Specified ClientID does not exist', 11, -1);
			RETURN;
		END

	
		EXEC	[dbo].[usp_InsertQuestionnaire]
				@PersonID = @Person_ID,
				@QuestionnaireDate = @QuestionnaireDate,
				@Source = NULL,
				@VisitRemodeledProperty = @VisitRemodel,
				@RemodelPropertyDate = @RemodelDate,
				@isExposedtoPeelingPaint = NULL,
				@isTakingVitamins = @Vitamins,
				@isNursing = @Nursing,
				@isUsingPacifier = @Pacifier,
				@isUsingBottle = @Bottle,
				@BitesNails = @BitesNails,
				@NonFoodEating = @EatsNonFood,
				@NonFoodinMouth = @NonFoodInMouth,
				@EatOutside = @EatsOutdoors,
				@Suckling = NULL,
				@FrequentHandWashing = @HandWash,
				@Daycare = @Daycare,
				@New_Notes = @QuestionnaireNotes,
				@QuestionnaireID = @Questionnaire_return_value OUTPUT 
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
/****** Object:  StoredProcedure [dbo].[usp_InsertOccupation]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Occupation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertOccupation]   -- usp_InsertOccupation 
	-- Add the parameters for the stored procedure here
	@OccupationName varchar(50) = NULL,
	@OccupationDescription varchar(256) = NULL,
	@LeadExposure bit = NULL,
	@NewOccupationID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Occupation ( OccupationName, OccupationDescription, LeadExposure )
					 Values ( @OccupationName, @OccupationDescription, @LeadExposure );
		SELECT @NewOccupationID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPerson]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to insert new people records
-- =============================================
-- DROP PROCEDURE usp_InsertPerson
CREATE PROCEDURE [dbo].[usp_InsertPerson]   -- usp_InsertPerson "Bonifacic",'James','Marco','19750205','M'
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
	@Release_Notes varchar(3000) = NULL,
	@Travel_Notes varchar(3000) = NULL,
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

		IF (@Release_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonReleaseNotes]
							@Person_ID = @PID,
							@Notes = @Release_Notes,
							@InsertedNotesID = @NotesID OUTPUT

		IF (@Travel_Notes IS NOT NULL)
			EXEC	[dbo].[usp_InsertPersonTravelNotes]
							@Person_ID = @PID,
							@Notes = @Travel_Notes,
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersonNotes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert Person notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPersonNotes] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Person information
		INSERT INTO PersonNotes (PersonID, Notes) 
				values (@Person_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersonReleaseNotes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert PersonRelease notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPersonReleaseNotes] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update PersonRelease information
		INSERT INTO PersonReleaseNotes (PersonID, Notes) 
				values (@Person_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END


GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoAccessAgreement]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoAccessAgreement records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoAccessAgreement]   -- usp_InsertPersontoAccessAgreement
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@AccessAgreementID int = NULL,
	@AccessAgreementDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoAccessAgreement( PersonID, AccessAgreementID, AccessAgreementDate) --, EndDate)
					 Values ( @PersonID, @AccessAgreementID, @AccessAgreementDate ) -- , @EndDate);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoDaycare]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoDaycare records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoDaycare]   -- usp_InsertPersontoDaycare
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DaycareID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DaycareNotes varchar(3000) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoDaycare( PersonID, DaycareID, StartDate, EndDate)
					 Values ( @PersonID, @DaycareID, @StartDate, @EndDate);
		--SELECT SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoEmployer]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoEmployer records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoEmployer]   -- usp_InsertPersontoEmployer
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@EmployerID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoEmployer( PersonID, EmployerID, StartDate, EndDate)
					 Values ( @PersonID, @EmployerID, @StartDate, @EndDate);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoEthnicity]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoEthnicity records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoEthnicity]   -- usp_InsertPersontoEthnicity
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
		-- only provide support for association with a single ethnicity as per initial scope
		IF EXISTS (Select PersonID from PersontoEthnicity where PersonID = @PersonID)
			update PersontoEthnicity set EthnicityID = @EthnicityID where PersonID = @PersonID;
		ELSE
			INSERT into PersontoEthnicity( PersonID, EthnicityID )
					Values ( @PersonID, @EthnicityID )

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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoFamily]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoFamily records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoFamily]   -- usp_InsertPersontoFamily
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@FamilyID int = NULL,
	@OUTPUT int OUTPUT
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
		 INSERT into PersontoFamily( PersonID, FamilyID ) --, StartDate, EndDate)
					 Values ( @PersonID, @FamilyID ) -- , @StartDate, @EndDate);
		SELECT @OUTPUT = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoForeignFood]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoForeignFood records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoForeignFood]   -- usp_InsertPersontoForeignFood
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@ForeignFoodID int = NULL
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
		 INSERT into PersontoForeignFood( PersonID, ForeignFoodID ) --, StartDate, EndDate)
					 Values ( @PersonID, @ForeignFoodID ) -- , @StartDate, @EndDate);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoHobby]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoHobby records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoHobby]   -- usp_InsertPersontoHobby
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@HobbyID int = NULL
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
		 INSERT into PersontoHobby( PersonID, HobbyID ) --, StartDate, EndDate)
					 Values ( @PersonID, @HobbyID ) -- , @StartDate, @EndDate);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoHomeRemedy]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoHomeRemedy records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoHomeRemedy]   -- usp_InsertPersontoHomeRemedy
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@HomeRemedyID int = NULL
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
		 INSERT into PersontoHomeRemedy( PersonID, HomeRemedyID ) --, StartDate, EndDate)
					 Values ( @PersonID, @HomeRemedyID ) -- , @StartDate, @EndDate);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoInsurance]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoInsurance records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoInsurance]   -- usp_InsertPersontoInsurance
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@InsuranceID smallint = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@GroupID varchar(20) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoInsurance( PersonID, InsuranceID, StartDate, EndDate, GroupID)
					 Values ( @PersonID, @InsuranceID, @StartDate, @EndDate, @GroupID);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoLanguage]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoLanguage records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoLanguage]   -- usp_InsertPersontoLanguage
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@LanguageID smallint = NULL,
	@isPrimaryLanguage bit = NULL
	--@StartDate date = NULL,
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
		IF EXISTS (SELECT PersonID from PersontoLanguage where PersonID = @PersonID and LanguageID = @LanguageID)
		BEGIN
			-- make sure there are no other primary languages
			IF (@isPrimaryLanguage = 1)
				update PersontoLanguage set isPrimaryLanguage = 0 WHERE PersonID = @PersonID AND LanguageID != @LanguageID AND isPrimaryLanguage = 1
			update PersontoLanguage set isPrimaryLanguage = @isPrimaryLanguage WHERE PersonID = @PersonID AND LanguageID = @LanguageID
		END
		ELSE
			INSERT into PersontoLanguage( PersonID, LanguageID, isPrimaryLanguage ) -- StartDate, EndDate, GroupID)
					 Values ( @PersonID, @LanguageID, @isPrimaryLanguage ) -- @StartDate, @EndDate, @GroupID);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoOccupation]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoOccupation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoOccupation]   -- usp_InsertPersontoOccupation
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@OccupationID smallint = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL
	--@GroupID varchar(20) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @return_value int, @ErrorLogID int;

	-- at the very least assume the start date is today
	IF (@StartDate is NULL) SELECT @StartDate = GETDATE();

    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoOccupation( PersonID, OccupationID, StartDate, EndDate)
					 Values ( @PersonID, @OccupationID, @StartDate, @EndDate);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoPerson]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20150323
-- Description:	Stored Procedure to insert 
--              new PersontoPerson records how 
--              they are related
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoPerson]   -- usp_InsertPersontoPerson
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoPhoneNumber]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoPhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoPhoneNumber]   -- usp_InsertPersontoPhoneNumber
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@PhoneNumberID int = NULL,
	@NumberPriority tinyint = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoPhoneNumber( PersonID, PhoneNumberID, NumberPriority)
					 Values ( @PersonID, @PhoneNumberID, @NumberPriority )
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoProperty]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoProperty]   -- usp_InsertPersontoProperty
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@PropertyID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@isPrimaryResidence bit = NULL,
	@NewPersontoPropertyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoProperty( PersonID, PropertyID, StartDate, EndDate, isPrimaryResidence)
					 Values ( @PersonID, @PropertyID, @StartDate, @EndDate, @isPrimaryResidence )
		SELECT @NewPersontoPropertyID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoStatus]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoStatus records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoStatus]   -- usp_InsertPersontoStatus
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@StatusID int = NULL,
	@StatusDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoStatus( PersonID, StatusID, StatusDate ) -- , EndDate, isPrimaryResidence)
					 Values ( @PersonID, @StatusID, @StatusDate ) --, @EndDate, @isPrimaryResidence )
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoTravelCountry]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoTravelCountry records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoTravelCountry]   -- usp_InsertPersontoTravelCountry
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@TravelCountryID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoTravelCountry( PersonID, CountryID, StartDate, EndDate )
					 Values ( @PersonID, @TravelCountryID, @StartDate, @EndDate )
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPersonTravelNotes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert PersonTravel notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPersonTravelNotes] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update PersonTravel information
		INSERT INTO PersonTravelNotes (PersonID, Notes) 
				values (@Person_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END


GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPhoneNumber]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPhoneNumber]   -- usp_InsertPhoneNumber 
	-- Add the parameters for the stored procedure here
	@CountryCode tinyint = 1,
	@PhoneNumber bigint = NULL,
	@PhoneNumberTypeID tinyint = NULL,
	@DEBUG bit = NULL,
	@PhoneNumberID_OUTPUT int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		-- Determine if the phone number already exists
		SELECT @PhoneNumberID_OUTPUT = PhoneNumberID from PHoneNumber where PhoneNumber = @PhoneNumber

		-- If the phone number doesn't exist, insert it and get the new id
		IF (@PhoneNumberID_OUTPUT IS NULL)
		BEGIN
			IF (@DEBUG = 1)
				SELECT 'INSERT into PhoneNumber ( CountryCode, PhoneNumber, PhoneNumberTypeID )
						 Values ( @CountryCode, @PhoneNumber, @PhoneNumberTypeID );', @CountryCode, @PhoneNumber, @PhoneNumberTypeID

			INSERT into PhoneNumber ( CountryCode, PhoneNumber, PhoneNumberTypeID )
						 Values ( @CountryCode, @PhoneNumber, @PhoneNumberTypeID );
			SELECT @PhoneNumberID_OUTPUT = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPhoneNumberType]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20141220
-- Description:	Stored Procedure to insert new PhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPhoneNumberType]   -- usp_InsertPhoneNumberType
	-- Add the parameters for the stored procedure here
	@PhoneNumberTypeName VarChar(50) = NULL,
	@PhoneNumberTypeID_OUTPUT int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	
	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PhoneNumberType ( PhoneNumberTypeName )
					 Values ( @PhoneNumberTypeName );
		SELECT @PhoneNumberTypeID_OUTPUT = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertProperty]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new property records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertProperty]   -- usp_InsertProperty 
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
	@OverRideDuplicate bit = 1,
	@PropertyID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;
    -- Insert statements for procedure here
	BEGIN TRY
		-- Check if the property already exists, if it does, return the propertyID
		SELECT @PropertyID = [dbo].udf_DoesPropertyExist (
						@AddressLine1,
						@AddressLine2,
						@City,
						@State,
						@ZipCode
						)

		if (@PropertyID iS NOT NULL)
		BEGIN
			if (@OverrideDuplicate = 0)
			BEGIN
				DECLARE @ErrorString VARCHAR(3000);
				SET @ErrorString = 'Property Address ' + @AddressLine1 + ', ' + @City + ', ' + @State + ', ' + @ZipCode
								   + ' '  + ' appears to be a duplicate of: ' + cast(@PropertyID as varchar(30));
				RAISERROR('@PropertyID exists: @AddressLine1, @City, @State, @ZipCode', 11, -1);
				RETURN;
			END

			-- RETURN THE PropertyID of the matching property
			PRINT 'returning existing propertyID: ' + cast(@PropertyID as varchar);
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertyNotes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert Property notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertPropertyNotes] 
	-- Add the parameters for the stored procedure here
	@Property_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Property information
		INSERT INTO PropertyNotes (PropertyID, Notes) 
				values (@Property_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END


GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertySampleResults]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PropertySampleResults records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPropertySampleResults]   -- usp_InsertPropertySampleResults 
	-- Add the parameters for the stored procedure here
	@isBaseline bit = NULL,
	@PropertyID int = NULL,
	@LabSubmissionDate date = getdate,
	@LabID int = NULL,
	@SampleTypeID tinyint = NULL,
	@Notes varchar(3000) = NULL,
	@NewPropertySampleResultsID int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @ExistsPropertyID int;

	-- check if the property has a record in BloodTestResults Table
	select @ExistsPropertyID = PropertyID from PropertySampleResults


    -- Insert statements for procedure here
	BEGIN TRY
	-- Determine if this person already has an entry in BloodTestResults and set isBaseline appropriately.
		IF ( @isBaseline is NULL ) -- nothing passed in for baseline
		BEGIN
			IF  ( @ExistsPropertyID is not NULL )
			BEGIN
				SET @isBaseline = 0;
			END
			ELSE -- the person has no entry in BloodTestResults, this is a baseline entry
			BEGIN
				SET @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 0 ) -- this should not be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPropertyID is NULL)  -- the person does not have an entry in BloodTestResults, this is a baseline entry
			BEGIN
				Set @isBaseline = 1;
			END
		END
		ELSE IF ( @isBaseline = 1 ) -- this should be a baseline entry according to passed in argument
		BEGIN
			IF (@ExistsPropertyID is not NULL)  -- the person already has an entry in BloodTestResults, this isn't a baseline entry
			BEGIN
				Set @isBaseline = 0;
			END
		END 

		 INSERT into PropertySampleResults ( isBaseline, PropertyID, LabSubmissionDate, LabID,
		                                   SampleTypeID, Notes )
					 Values ( @isBaseline, @PropertyID, @LabSubmissionDate, @LabID,
		                                   @SampleTypeID, @Notes );
		SELECT @NewPropertySampleResultsID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertytoCleanupStatus]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PropertytoCleanupStatus records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPropertytoCleanupStatus]   -- usp_InsertPropertytoCleanupStatus
	-- Add the parameters for the stored procedure here
	@PropertyID int = NULL,
	@CleanupStatusID tinyint = NULL,
	@CleanupStatusDate date = NULL,
	@CostofCleanup money = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PropertytoCleanupStatus( PropertyID, CleanupStatusID, CleanupStatusDate, CostofCleanup )
					 Values ( @PropertyID, @CleanupStatusID, @CleanupStatusDate, @CostofCleanup )
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertytoHouseholdSourcesofLead]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PropertytoHouseholdSourcesofLead records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPropertytoHouseholdSourcesofLead]   -- usp_InsertPropertytoHouseholdSourcesofLead
	-- Add the parameters for the stored procedure here
	@PropertyID int = NULL,
	@HouseholdSourcesofLeadID int = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PropertytoHouseholdSourcesofLead( PropertyID, HouseholdSourcesofLeadID )
					 Values ( @PropertyID, @HouseholdSourcesofLeadID )
		SELECT SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertPropertytoMedium]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PropertytoMedium records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPropertytoMedium]   -- usp_InsertPropertytoMedium
	-- Add the parameters for the stored procedure here
	@PropertyID int = NULL,
	@MediumID int = NULL,
	@MediumTested bit = 1

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PropertytoMedium( PropertyID, MediumID, MediumTested )
					 Values ( @PropertyID, @MediumID, @MediumTested )
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
/****** Object:  StoredProcedure [dbo].[usp_InsertQuestionnaire]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Questionnaire records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertQuestionnaire]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@QuestionnaireDate date = getdate,
	@Source int = NULL,
	@VisitRemodeledProperty bit = NULL,
	@PaintDate date = NULL,
	@RemodelPropertyDate date = NULL,
	@isExposedtoPeelingPaint bit = NULL,
	@isTakingVitamins bit = NULL,
	@isNursing bit = Null,
	@isUsingPacifier bit = NULL,
	@isUsingBottle bit = NULL,
	@BitesNails bit = NULL,
	@NonFoodEating bit = NULL,
	@NonFoodinMouth bit = NULL,
	@EatOutside bit = NULL,
	@Suckling bit = NULL,
	@FrequentHandWashing bit = NULL,
	@Daycare bit = NULL,
	@New_Notes varchar(3000) = NULL,
	@QuestionnaireID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Questionnaire ( PersonID, QuestionnaireDate, Source, VisitRemodeledProperty, PaintDate, RemodelPropertyDate,
		                             isExposedtoPeelingPaint, isTakingVitamins, isNursing, isUsingPacifier, isUsingBottle,
									 Bitesnails, NonFoodEating, NonFoodinMouth, EatOutside, Suckling, FrequentHandWashing,
									 Daycare )
					 Values ( @PersonID, @QuestionnaireDate, @Source, @VisitRemodeledProperty, @PaintDate, @RemodelPropertyDate,
		                      @isExposedtoPeelingPaint, @isTakingVitamins, @isNursing, @isUsingPacifier, @isUsingBottle,
							  @Bitesnails, @NonFoodEating, @NonFoodinMouth, @EatOutside, @Suckling, @FrequentHandWashing,
							  @Daycare );
		SELECT @QuestionnaireID = SCOPE_IDENTITY();

		IF (@New_Notes IS NOT NULL)
		EXEC	[dbo].[usp_InsertQuestionnaireNotes]
							@Questionnaire_ID = @QuestionnaireID,
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
/****** Object:  StoredProcedure [dbo].[usp_InsertQuestionnaireNotes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to insert Questionnaire notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertQuestionnaireNotes] 
	-- Add the parameters for the stored procedure here
	@Questionnaire_ID int = NULL, 
	@Notes VARCHAR(3000) = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Questionnaire information
		INSERT INTO QuestionnaireNotes (QuestionnaireID, Notes) 
				values (@Questionnaire_ID, @Notes);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END

GO
/****** Object:  StoredProcedure [dbo].[usp_InsertRemediation]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Remediation records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertRemediation]   -- usp_InsertRemediation 
	-- Add the parameters for the stored procedure here
	@RemediationApprovalDate date = getdate,
	@RemediationStartDate date = NULL,
	@RemediationEndDate date = NULL,
	@PropertyID int = NULL,
	@RemediationActionPlanID int = NULL,
	@AccessAgreementID int = NULL,
	@FinalRemediationReportFile varbinary(max) = NULL,
	@FinalRemediationReportDate date = Null,
	@RemediationCost money = NULL,
	@OneYearRemediationCompleteDate date = NULL,
	@Notes varchar(3000) = NULL,
	@OneYearRemediatioNComplete bit = NULL,
	@NewRemediationID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Remediation ( RemediationApprovalDate, RemediationStartDate, RemediationEndDate, PropertyID
		                           , RemediationActionPlanID, AccessAgreementID, FinalRemediationReportFile, FinalRemediationReportDate
								   , RemediationCost, OneYearRemediationCompleteDate, Notes, OneYearRemediationComplete )
					 Values ( @RemediationApprovalDate, @RemediationStartDate, @RemediationEndDate, @PropertyID
		                      , @RemediationActionPlanID, @AccessAgreementID, @FinalRemediationReportFile, @FinalRemediationReportDate
							  , @RemediationCost, @OneYearRemediationCompleteDate, @Notes, @OneYearRemediationComplete);
		SELECT @NewRemediationID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertRemediationActionPlan]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new RemediationActionPlan records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertRemediationActionPlan]   -- usp_InsertRemediationActionPlan 
	-- Add the parameters for the stored procedure here
	@RemediationActionPlanApprovalDate date = getdate,
	@HomeOwnerConsultationDate date = NULL,
	@ContractorCompletedInvestigationDate date = NULL,
	@EnvironmentalInvestigationID int = NULL,
	@RemediationActionPlanFinalReportSubmissionDate date = NULL,
	@RemediationActionPlanFile varbinary(max) = NULL,
	@PropertyID int = NULL,
	@NewRemediationActionPlanID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into RemediationActionPlan ( RemediationActionPlanApprovalDate, HomeOwnerConsultationDate, ContractorCompletedInvestigationDate
		                                     , EnvironmentalInvestigationID, RemediationActionPlanFinalReportSubmissionDate,
											 RemediationActionPlanFile, PropertyID )
					 Values ( @RemediationActionPlanApprovalDate, @HomeOwnerConsultationDate, @ContractorCompletedInvestigationDate
								, @EnvironmentalInvestigationID, @RemediationActionPlanFinalReportSubmissionDate
								, @RemediationActionPlanFile, @PropertyID );
		SELECT @NewRemediationActionPlanID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertSampleLevelCategory]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new SampleLevelCategory records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertSampleLevelCategory]   -- usp_InsertSampleLevelCategory 
	-- Add the parameters for the stored procedure here
	@SampleLevelCategoryName varchar(20) = NULL,
	@SampleLevelCategoryDescription varchar(256) = NULL,
	@NewSampleLevelCategoryID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into SampleLevelCategory ( SampleLevelCategoryName, SampleLevelCategoryDescription )
					 Values ( @SampleLevelCategoryName, @SampleLevelCategoryDescription );
		SELECT @NewSampleLevelCategoryID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertSampleType]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new SampleType records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertSampleType]   -- usp_InsertSampleType 
	-- Add the parameters for the stored procedure here
	@SampleTypeName varchar(20) = NULL,
	@SampleTypeDescription varchar(256) = NULL,
	@NewSampleTypeID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into SampleType ( SampleTypeName, SampleTypeDescription )
					 Values ( @SampleTypeName, @SampleTypeDescription );
		SELECT @NewSampleTypeID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertStatus]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Status records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertStatus]   -- usp_InsertStatus 
	-- Add the parameters for the stored procedure here
	@StatusName varchar(20) = NULL,
	@StatusDescription varchar(256) = NULL,
	@NewStatusID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Status ( StatusName, StatusDescription )
					 Values ( @StatusName, @StatusDescription );
		SELECT @NewStatusID = SCOPE_IDENTITY();
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
/****** Object:  StoredProcedure [dbo].[usp_InsertTravelNotes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150319
-- Description:	stored procedure to insert Travel notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertTravelNotes] 
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL, 
	@Travel_Notes VARCHAR(3000) = NULL,
	@Start_Date date = NULL,
	@End_Date date = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Property information
		INSERT INTO TravelNotes (FamilyID, Notes, StartDate, EndDate) 
				values (@Family_ID, @Travel_Notes, @Start_Date, @End_Date);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END



GO
/****** Object:  StoredProcedure [dbo].[usp_SLAllBloodTestResults]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20141222
-- Description:	select blood test results
--				optionally only return for a specific 
--				client
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLAllBloodTestResults] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@Min_Lead_Value numeric(9,4) = NULL,
	@DEBUG bit = 0


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000), @OrderBy NVARCHAR(500),
			@Recompile BIT = 1, @ErrorLogID int; 
	BEGIN
    -- Insert statements for procedure here
	SELECT @spexecutesqlStr = N'SELECT ''ClientID'' = [P].[personid], ''LastName'' = [P].[LastName], [P].[FirstName], ''BirthDate'' = [P].[BirthDate]
								, [BTR].[SampleDate], ''Pb_ug_Per_dl'' = [BTR].[LeadValue]
								, ''Hb_g_Per_dl'' = [BTR].[HemoglobinValue], ''RetestBL'' = DATEADD(yy,1,sampledate)
								, ''RetestHB'' = DATEADD(yy,1,sampledate)
								-- , ''Closed'' = [P].[isClosed] , ''Moved'' = [P].[Moved], ''Movedate'' = [P].[MovedDate]
							from [Person] [P]
							join [BloodTestResults] [BTR] on [P].[PersonID] = [BTR].[PersonID]
							WHERE [P].[isClient] = 1'

	IF @Person_ID IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[PersonID] = @PersonID'
		SET @OrderBy = ' ORDER BY [BTR].[LeadValue],[BTR].[SampleDate] desc'
	END

	IF @Min_Lead_Value IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [BTR].[LeadValue] >= @MinLeadValue'
	END

	IF @Person_ID is NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr;
		SET @OrderBy = N' ORDER BY [p].[LastName], [P].[PersonID] ASC, [BTR].[SampleDate] DESC';
	END


	SELECT @spexecutesqlStr = @spexecutesqlStr + @OrderBy

	IF ( (@Person_ID IS NULL) AND (@Min_Lead_Value IS NULL) )
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		-- If debugging print out query
		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, 'PID' = @Person_ID, 'MLV' = @Min_Lead_Value, 'R' = @Recompile;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@PersonID int,@MinLeadValue numeric(9,4)'
		, @PersonID = @Person_ID, @MinLeadValue = @Min_Lead_Value;
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
/****** Object:  StoredProcedure [dbo].[usp_SLAllBloodTestResults2]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20141222
-- Description:	select blood test results
--				optionally only return for a specific 
--				client
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLAllBloodTestResults2] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@Min_Lead_Value numeric(9,4) = NULL,
	@DEBUG bit = 0


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000), @OrderBy NVARCHAR(500),
			@Recompile BIT = 1, @ErrorLogID int; 


    -- Insert statements for procedure here
	SET FMTONLY OFF
	SELECT @spexecutesqlStr = N'SELECT ''ClientID'' = [P].[personid], ''LastName'' = [P].[LastName], ''BirthDate'' = [P].[BirthDate]
								, [BTR].[SampleDate], ''Pb ug/dl'' = [BTR].[LeadValue], ''Hb g/dl'' = [BTR].[HemoglobinValue], ''Retest BL'' = DATEADD(yy,1,sampledate)
								, ''Retest HB'' = DATEADD(yy,1,sampledate)
								--, ''Close'' = [P].[isClosed], ''Moved'' = [P].[Moved], ''Movedate'' = [P].[MovedDate]
							from [Person] [P]
							join [BloodTestResults] [BTR] on [P].[PersonID] = [BTR].[PersonID]
							WHERE 1 = 1'

	IF @Person_ID IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[PersonID] = @PersonID'
		SET @OrderBy = ' ORDER BY [BTR].[LeadValue],[BTR].[SampleDate] desc'
	END

	IF @Min_Lead_Value IS NOT NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [BTR].[LeadValue] >= @MinLeadValue'
	END

	IF @Person_ID is NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr;
		SET @OrderBy = N' ORDER BY [p].[LastName], [P].[PersonID] ASC, [BTR].[SampleDate] DESC';
	END


	SELECT @spexecutesqlStr = @spexecutesqlStr + @OrderBy

	IF ( (@Person_ID IS NULL) AND (@Min_Lead_Value IS NULL) )
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		-- If debugging print out query
		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, 'PID' = @Person_ID, 'MLV' = @Min_Lead_Value, 'R' = @Recompile;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@PersonID int,@MinLeadValue numeric(9,4)'
		, @PersonID = @Person_ID, @MinLeadValue = @Min_Lead_Value;
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
/****** Object:  StoredProcedure [dbo].[usp_SLAllBloodTestResultsMetaData]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20141222
-- Description:	select blood test results
--				optionally only return for a specific 
--				client
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLAllBloodTestResultsMetaData] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@Min_Lead_Value numeric(9,4) = NULL,
	@DEBUG bit = 0


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000), @OrderBy NVARCHAR(500),
			@Recompile BIT = 1, @ErrorLogID int; 
	BEGIN
    -- Insert statements for procedure here
	SELECT 'ClientID' = [P].[personid], 'LastName' = [P].[LastName], 'BirthDate' = [P].[BirthDate]
				, [BTR].[SampleDate], 'Pb_ug_Per_dl' = [BTR].[LeadValue]
				, 'Hb_g_Per_dl' = [BTR].[HemoglobinValue], 'RetestBL' = DATEADD(yy,1,sampledate)
				, 'RetestHB' = DATEADD(yy,1,sampledate), 'Close' = [P].[isClosed], 'Moved' = [P].[Moved]
				, 'Movedate' = [P].[MovedDate]
			from [Person] [P]
			join [BloodTestResults] [BTR] on [P].[PersonID] = [BTR].[PersonID]
			WHERE 1 = 0
	END
END




GO
/****** Object:  StoredProcedure [dbo].[usp_SlChildStatus]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	returns valid status codes for passed in type - Child
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlChildStatus] 
	-- Add the parameters for the stored procedure here
	@TargetType varchar(50) = NULL, 
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(3000)

	select @spexecutesqlStr =''


    -- Insert statements for procedure here
	SELECT [TS].[StatusName],[TS].[StatusID] from [TargetStatus] AS [TS]
	where 1 = 1 AND TargetType in ('Person','All')

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlColumnDetails]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141124
-- Description:	stored procedure to list column details for each column in a table
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlColumnDetails] 
	-- Add the parameters for the stored procedure here
	@TableName varchar(256) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	SELECT 'Table' = @TableName,
    c.name 'Column Name',
    t.Name 'Data type',
    c.max_length 'Max Length',
    c.precision ,
    c.scale ,
    c.is_nullable,
    ISNULL(i.is_primary_key, 0) 'Primary Key'
	FROM    
		sys.columns c
	INNER JOIN 
		sys.types t ON c.user_type_id = t.user_type_id
	LEFT OUTER JOIN 
		sys.index_columns ic ON ic.object_id = c.object_id AND ic.column_id = c.column_id
	LEFT OUTER JOIN 
		sys.indexes i ON ic.object_id = i.object_id AND ic.index_id = i.index_id
	WHERE
		c.object_id = OBJECT_ID(@TableName)
END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountFamilyMembers]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141125
-- Description:	stored procedure to count family members
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountFamilyMembers]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'SELECT [f].[familyid], FamilyName = [f].[lastname], Members = count([P].[Lastname]) from [Family] AS [F]
		 LEFT OUTER JOIN [persontoFamily] [p2f] on [F].[FamilyID] = [p2F].[Familyid] 
		 LEFT OUTER JOIN [Person] AS [P] on [P].[Personid] = [p2f].[Personid]
		 where 1=1';

	IF (@FamilyID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [f].[familyID] = @Family_ID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' group by [f].[familyid],[f].[lastname]
			order by [f].[lastname],[f].[familyid]';


	IF (@FamilyID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'FamilyID' = @FamilyID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Family_ID int'
			, @Family_ID = @FamilyID;
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
/****** Object:  StoredProcedure [dbo].[usp_SlCountNewPeople]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 2/13/2014
-- Description:	procedure returns the number of entries in the persons 
--				table, filter by minimum creation date
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountNewPeople] 
	-- Add the parameters for the stored procedure here
	@Created_Days_Ago int = NULL,
	@DEBUG bit = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int
			, @Min_Date datetime;
	
	BEGIN TRY
		SET @Created_Days_Ago = @Created_Days_Ago * -1
		SET @Min_Date = DateAdd(dd,@Created_Days_Ago, GetDate())

		SELECT @spexecutesqlStr = 'SELECT Participants = count([PersonId]), Min(CreatedDate)
									, MinimumCreatedDate = @MinDate
									, CreatedDaysAgo = @CreatedDaysAgo
									from [person] WHERE 1=1'
							
		IF (@Created_Days_Ago IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + '  AND [CreatedDate] >= @MinDate';

		IF @Recompile = 1
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		if (@DEBUG = 1) select @spexecutesqlStr, @Created_Days_Ago, @Min_Date
		EXEC [sp_executesql] @spexecutesqlStr
		, N'@CreatedDaysAgo int, @MinDate datetime'
		, @CreatedDaysAgo = @Created_Days_Ago
		, @MinDate = @Min_Date

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
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeople]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 2/13/2014
-- Description:	procedure returns the number of entries in the persons table, being the number of participants
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeople] 
	-- Add the parameters for the stored procedure here
	@Max_Age int = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int, @MaxAge int;
	
	BEGIN TRY
		SELECT @spexecutesqlStr = 'SELECT Participants = count([PersonId]) from [person] WHERE 1=1'

		IF (@Max_Age IS NOT NULL)
		BEGIN
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [Age] <= @MaxAge';
		END
		ELSE
			
		IF @Recompile = 1
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@MaxAge VARCHAR(50)'
		, @MaxAge = @Max_Age

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
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeopleByAge]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20141222
-- Description:	returns count of people grouped by 
--              age. If a lastname is passed in
--              displays a list of people with that lastname
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeopleByAge]
	-- Add the parameters for the stored procedure here
	-- @Last_Name varchar(50) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='select Age, ''Personcount'' = count(PersonID)
		from [person]
		where isClient = 1'
	
	-- Return all families and associated properties if nothing was passed in
	--IF (@Last_Name IS NOT NULL)
	--	SELECT @spexecutesqlStr = @spexecutesqlStr + ' and [LastName] = @LastName'
	--ELSE
	--    SET @Recompile = 0

	-- group people by age
	SELECT 
		@spexecutesqlStr = @spexecutesqlStr + ' group by [dbo].udf_CalculateAge(BirthDate,GetDate())'

	-- order by age
	SELECT 
		@spexecutesqlStr = @spexecutesqlStr + ' order by Age'

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';
	
	EXEC [sp_executesql] @spexecutesqlStr
 --   , N'@LastName varchar(50)'
	--, @LastName = @Last_Name;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeopleByAgeGroup]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150112
-- Description:	returns count of people grouped by 
--              age categories. If a lastname is passed in
--              displays a list of people with that lastname
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeopleByAgeGroup]
	-- Add the parameters for the stored procedure here
	-- @Last_Name varchar(50) = NULL
	@DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1;


	; with AgeGroups as 
	(  SELECT CASE
		  WHEN Age < 6 THEN '05andUnder'
		  WHEN Age >= 6 AND Age < 11 THEN '06-10'
		  WHEN Age >= 11 AND Age < 18 THEN '11-17'
		  ELSE '18andOver' 
	  END  AS Groups
	  -- , MaxAge = max(Person.Age)
	  FROM Person
	  where isClient = 1
	)

	SELECT ROW_NUMBER() OVER(ORDER BY Groups DESC) AS Row, AgeGroups = Coalesce(Groups,'Total'), 
								Clients =  Count(Groups) From AgeGroups group by Groups-- with ROLLUP

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT AgeGroups = Coalesce(Groups,''Total''), 
								Clients =  Count(Groups) From AgeGroups group by Groups with ROLLUP'
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeopleByLastName]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountPeopleByLastName]
		@Last_Name VARCHAR(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @spExecutesqlStr NVARCHAR(4000), @Recompile BIT = 1;

	BEGIN TRY
		SELECT @spexecutesqlStr = 'SELECT [lastname],''Members'' = count([firstname]) from [person] WHERE 1=1';

		if (@Last_Name is not NULL)
		BEGIN
			SET @Recompile = 1;
			SELECT @spExecutesqlStr = @spExecutesqlStr + ' AND [person].[LastName] = @LastName'
		END
		ELSE
			SET @Recompile = 0

		-- Group by last name for counting purposes
		SELECT @spExecutesqlStr = @spExecutesqlStr + ' group by [lastname]'

		-- force recompile for selective query
		IF @Recompile = 1
			SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		EXEC [sp_executesql] @spExecutesqlStr 
			, N'@LastName VARCHAR(50)'
			, @LastName = @Last_Name;

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
/****** Object:  StoredProcedure [dbo].[usp_SlDaycare]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150319
-- Description:	returns daycare name, id, description
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlDaycare] 
	-- Add the parameters for the stored procedure here
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select DaycareID,DaycareName,DaycareDescription from Daycare

END


GO
/****** Object:  StoredProcedure [dbo].[usp_SlEditClientInfoWebScreenInformation]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150408
-- Description:	stored procedure to select 
--              person edit screen info
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditClientInfoWebScreenInformation]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	IF (@PersonID IS NULL)
	BEGIN
		RAISERROR ('You must supply a person.', 11, -1);
		RETURN;
	END;

	SELECT @spexecuteSQLStr =
		N'select [P].[PersonID],[P].[LastName],[P].[FirstName],[P].[MiddleName]
		,[P].[Birthdate],[P].[Gender]
		,[L].[LanguageName]
		,[E].[Ethnicity]
		,[P].[Moved]
		,[MovedOutofCounty] = [P].[OutofSite]
		from [Person] AS [P]
		LEFT OUTER JOIN [PersontoLanguage] AS [PL] on [P].[PersonID] = [PL].[PersonID]
		LEFT OUTER JOIN [Language] AS [L] ON [PL].[LanguageID] = [L].[LanguageID]
		LEFT OUTER JOIN [PersontoEthnicity] AS [PE] ON [PE].[PersonID] = [P].[PersonID]
		LEFT OUTER JOIN [Ethnicity] AS [E] ON [PE].[EthnicityID] = [E].[EthnicityID]
		where [P].[PersonID] = @PersonID';

	
	IF EXISTS ( SELECT PersonID from PersontoLanguage where PersonID = @PersonID ) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [PL].[isPrimaryLanguage] = 1';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [L].[CreatedDate] desc';
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
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
/****** Object:  StoredProcedure [dbo].[usp_SlEditFamilyWebScreenInformation]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150405
-- Description:	returns Family Lastname, Primary Address,
--				Home phonenumber, work phonenumber,
--				number of smokers, number of pets,
--				if pets are in and out pets,
--				if pets are washed frequently
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditFamilyWebScreenInformation] 
	-- Add the parameters for the stored procedure here
	@Family_ID INT = NULL,
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @HomePhoneNumber bigint, @WorkPhoneNumber bigint,
			@spexecuteSQLStr NVARCHAR(4000), @Recompile  BIT = 1, @ErrorLogID int;
	
	IF (@Family_ID IS NULL)
	BEGIN
		RAISERROR ('You must supply the Family.', 11, -1);
		RETURN;
	END;
	
	-- Select Home Phone number
	select  @HomePhoneNumber = dbo.udf_SlFamilyPhoneNumber(@Family_ID, 1)

	-- Select Work Phone number
	select  @WorkPhoneNumber = dbo.udf_SlFamilyPhoneNumber(@Family_ID, 2)
	
	SELECT @spexecuteSQLStr =
		N'SELECT [F].[FamilyID],[F].[Lastname],[P].[AddressLine1],[P].[AddressLine2]
			,[P].[City],[P].[State],[P].[ZipCode]
			, HomePhoneNumber = @HomePhoneNumber, WorkPhoneNumber = @WorkPhoneNumber
			,[F].[NumberofSmokers],[F].[Pets],[F].[Petsinandout]
		FROM [Family] AS [F]
		JOIN [Property] AS [P] ON [F].[PrimaryPropertyID] = [P].[PropertyID]
		WHERE 1 = 1'

	IF (@Family_ID IS NULL)
		SET @Recompile = 0;

	IF (@Family_ID IS NOT NULL)
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' and FamilyID = @FamilyID ORDER by FamilyID desc'

	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'FamilyID' = @Family_ID, 'HomePhoneNumber' = @HomePhoneNumber, 'WorkPhoneNumber' = @WorkPhoneNumber;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@FamilyID int, @HomePhoneNumber bigint, @WorkPhoneNumber bigint'
			, @FamilyID = @Family_ID
			, @HomePhoneNumber = @HomePhoneNumber
			, @WorkPhoneNumber = @WorkPhoneNumber;
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
/****** Object:  StoredProcedure [dbo].[usp_SlEditPropertyWebScreenInformation]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150405
-- Description:	returns AddressLine1, Addressline2
--				City, State, and Zipcode
--				of a specific property
--				if no property ID is passed in, 
--				informatin is returned for all properties
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlEditPropertyWebScreenInformation] 
	-- Add the parameters for the stored procedure here
	@Property_ID INT = NULL,
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @spexecuteSQLStr NVARCHAR(4000), @Recompile  BIT = 1, @ErrorLogID int;
	
	SELECT @spexecuteSQLStr =
		N'SELECT [P].[PropertyID],[P].[AddressLine1],[P].[AddressLine2]
			,[P].[City],[P].[State],[P].[ZipCode]
			FROM [Property] AS [P]
			WHERE 1 = 1'

	IF (@Property_ID IS NULL)
		SET @Recompile = 0;

	IF (@Property_ID IS NOT NULL)
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' and PropertyID = @PropertyID ORDER by PropertyID desc'

	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PropertyID' = @Property_ID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PropertyID int'
			, @PropertyID = @Property_ID;
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
/****** Object:  StoredProcedure [dbo].[usp_SlFamilyMembers]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to list family members
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlFamilyMembers]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'SELECT [f].[familyid], FamilyName = [f].[lastname], [P].[LastName], [P].[FirstName] from [Family] AS [F]
		 LEFT OUTER JOIN [persontoFamily] [p2f] on [F].[FamilyID] = [p2F].[Familyid] 
		 LEFT OUTER JOIN [Person] AS [P] on [P].[Personid] = [p2f].[Personid]
		 where 1=1';

	IF (@FamilyID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [f].[familyID] = @Family_ID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [f].[lastname],[f].[familyid]';


	IF (@FamilyID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'FamilyID' = @FamilyID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Family_ID int'
			, @Family_ID = @FamilyID;
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
/****** Object:  StoredProcedure [dbo].[usp_SlFamilyNametoProperty]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20141123
-- Description:	User defined stored procedure to
--              select family and property address
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlFamilyNametoProperty]
	-- Add the parameters for the stored procedure here
	@Family_Name varchar(50) = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT ''FamilyName'' = [F].[LastName],[Prop].[StreetNumber],[Prop].[Street],[Prop].[StreetSuffix],[Prop].[ZipCode]
	from [family] AS [F]
	join [Property] as [Prop] on [F].[PrimaryPropertyID] = [Prop].[PropertyID]
	where 1 = 1'
	
	-- Return all families and associated properties if nothing was passed in
	IF (@Family_Name IS NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' and [F].[LastName] = @FamilyName'
	ELSE
	    SET @Recompile = 0

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [F].[LastName]'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		EXEC [sp_executesql] @spexecutesqlStr
		, N'@FamilyName varchar(50)'
		, @FamilyName = @Family_Name;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SLInsertedData]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20130509
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLInsertedData] 
	-- Add the parameters for the stored procedure here
	@Last_Name varchar(50) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000),
			@Recompile BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	SELECT @spexecutesqlStr = N'SELECT [P].[PersonID] 
								, ''FamilyLastName'' = [F].[Lastname]
								, [P].[LastName]
								, [P].[MiddleName]
								, [P].[FirstName]
								, [P].[BirthDate]
								, [P].[Gender]
								, ''StreetAddress'' = cast([Prop].[StreetNumber] as varchar)
									+ '' ''+ cast([Prop].[Street] as varchar) + '' '' 
									+ cast([Prop].[StreetSuffix] as varchar)
								, [Prop].[ApartmentNumber]
								, [Prop].[City]
								, [Prop].[State]
								, [Prop].[Zipcode]
								, ''PrimaryPhoneNumber'' = [Ph].[PhoneNumber]
								, [L].[LanguageName]
								, [F].[NumberofSmokers]
								, [F].[Pets]
								, [F].[inandout]
								, [F].[Notes]
								, [P].[Moved]
								, [P].[ForeignTravel]
								, [P].[OutofSite]
								, [H].[HobbyName]
								, [P].[Notes]
								, [P].[isSmoker]
								, [P].[RetestDate]
								, [Q].[QuestionnaireDate]
								, [Q].[isExposedtoPeelingPaint]
								, ''PaintAge'' = [Q].[RemodeledPropertyAge]
								, [Q].[VisitRemodeledProperty]
								, ''RemodelPropertyAge'' = [Q].[RemodeledPropertyAge]
								, [Q].[isTakingVitamins]
								, [Q].[FrequentHandWashing]
								, [Q].[isUsingBottle]
								, [Q].[isNursing]
								, [Q].[isUsingPacifier]
								, [Q].[BitesNails]
								, [Q].[EatOutside]
								, [Q].[NonFoodinMouth]
								, [Q].[NonFoodEating]
								, [Q].[Suckling]
								, [Q].[Daycare]
								, [Q].[Source]
								, [Q].[Notes]
								, [BTR].[SampleDate]
								, [BTR].[LabSubmissionDate]
								, [Lab].[LabName]
								, ''What is status code?''
								, [BTR].[HemoglobinValue]
						  FROM [LeadTrackingTesting-Liam].[dbo].[Person] AS [P]
						  LEFT OUTER JOIN [PersontoFamily] as [P2F] on [P].[PersonID] = [P2F].[PersonID]
						  LEFT OUTER JOIN [Family] AS [F] on [F].[FamilyID] = [P2F].[FamilyID]
						  LEFT OUTER JOIN [PersontoProperty] as [P2P] on [P].PersonID = [P2P].[PersonID]
						  LEFT OUTER JOIN [Questionnaire] as [Q] on [P].[PersonID] = [Q].[PersonID]
						  LEFT OUTER JOIN [BloodTestResults] as [BTR] on [P].[PersonID] = [BTR].[PersonID]
						  LEFT OUTER JOIN [PersontoLanguage] as [P2L] on [P2L].[PersonID] = [P].[PersonID]
						  LEFT OUTER JOIN [Language] as [L] on [L].LanguageID = [P2L].[LanguageID]
						  LEFT OUTER JOIN [Property] as [Prop] on [Prop].[PropertyID] = [F].[PrimaryPropertyID]
						  LEFT OUTER JOIN [PersontoPhoneNumber] as [P2Ph] on [P].[PersonID] = [P2Ph].[PersonID]
						  LEFT OUTER JOIN [PhoneNumber] as [Ph] on [Ph].[PhoneNumberID] = [P2Ph].[PhoneNumberID]
						  LEFT OUTER JOIN [PhoneNumberType] as [PhT] on [Ph].[PhoneNumberTypeID] = [PhT].[PhoneNumberTypeID]
						  LEFT OUTER JOIN [PersontoHobby] as [P2H] on [P].PersonID = [P2H].[HobbyID]
						  LEFT OUTER JOIN [Hobby] as [H] on [H].[HobbyID] = [P2H].[HobbyID]
						  LEFT OUTER JOIN [Lab] on [BTR].[LabID] = [Lab].[LabID]
							WHERE 1 = 1'

	if @Last_Name IS NOT NULL
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[LastName] = @LastName ORDER BY [P].[PersonID] desc'
	ELSE
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' ORDER BY [P].[PersonID] desc'

	IF @Last_name is NULL
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		EXEC [sp_executesql] @spexecutesqlStr
		, N'@Lastname varchar(50)'
		, @LastName = @Last_name;  
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
/****** Object:  StoredProcedure [dbo].[usp_SLInsertedDataMetaData]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130509
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLInsertedDataMetaData] 
	-- Add the parameters for the stored procedure here
	@Last_Name varchar(50) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000),
			@Recompile BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
SELECT [P].[PersonID] 
		, 'FamilyLastName' = [F].[Lastname]
		, [P].[LastName]
		, [P].[MiddleName]
		, [P].[FirstName]
		, [P].[BirthDate]
		, [P].[Gender]
		, 'StreetAddress' = cast([Prop].[StreetNumber] as varchar)
			+ ' '+ cast([Prop].[Street] as varchar) + ' ' 
			+ cast([Prop].[StreetSuffix] as varchar)
		, [Prop].[ApartmentNumber]
		, [Prop].[City]
		, [Prop].[State]
		, [Prop].[Zipcode]
		, 'PrimaryPhoneNumber' = [Ph].[PhoneNumber]
		, [L].[LanguageName]
		, [F].[NumberofSmokers]
		, [F].[Pets]
		, [F].[inandout]
		, [F].[Notes]
		, [P].[Moved]
		, [P].[ForeignTravel]
		, [P].[OutofSite]
		, [H].[HobbyName]
		, [P].[Notes]
		, [P].[isSmoker]
		, [P].[RetestDate]
		, [Q].[QuestionnaireDate]
		, [Q].[isExposedtoPeelingPaint]
		, 'PaintAge' = [Q].[RemodeledPropertyAge]
		, [Q].[VisitRemodeledProperty]
		, 'RemodelPropertyAge' = [Q].[RemodeledPropertyAge]
		, [Q].[isTakingVitamins]
		, [Q].[FrequentHandWashing]
		, [Q].[isUsingBottle]
		, [Q].[isNursing]
		, [Q].[isUsingPacifier]
		, [Q].[BitesNails]
		, [Q].[EatOutside]
		, [Q].[NonFoodinMouth]
		, [Q].[NonFoodEating]
		, [Q].[Suckling]
		, [Q].[Daycare]
		, [Q].[Source]
		, [Q].[Notes]
		, [BTR].[SampleDate]
		, [BTR].[LabSubmissionDate]
		, [Lab].[LabName]
		, 'What is status code?'
		, [BTR].[HemoglobinValue]
	FROM [LeadTrackingTesting-Liam].[dbo].[Person] AS [P]
	LEFT OUTER JOIN [PersontoFamily] as [P2F] on [P].[PersonID] = [P2F].[PersonID]
	LEFT OUTER JOIN [Family] AS [F] on [F].[FamilyID] = [P2F].[FamilyID]
	LEFT OUTER JOIN [PersontoProperty] as [P2P] on [P].PersonID = [P2P].[PersonID]
	LEFT OUTER JOIN [Questionnaire] as [Q] on [P].[PersonID] = [Q].[PersonID]
	LEFT OUTER JOIN [BloodTestResults] as [BTR] on [P].[PersonID] = [BTR].[PersonID]
	LEFT OUTER JOIN [PersontoLanguage] as [P2L] on [P2L].[PersonID] = [P].[PersonID]
	LEFT OUTER JOIN [Language] as [L] on [L].LanguageID = [P2L].[LanguageID]
	LEFT OUTER JOIN [Property] as [Prop] on [Prop].[PropertyID] = [F].[PrimaryPropertyID]
	LEFT OUTER JOIN [PersontoPhoneNumber] as [P2Ph] on [P].[PersonID] = [P2Ph].[PersonID]
	LEFT OUTER JOIN [PhoneNumber] as [Ph] on [Ph].[PhoneNumberID] = [P2Ph].[PhoneNumberID]
	LEFT OUTER JOIN [PhoneNumberType] as [PhT] on [Ph].[PhoneNumberTypeID] = [PhT].[PhoneNumberTypeID]
	LEFT OUTER JOIN [PersontoHobby] as [P2H] on [P].PersonID = [P2H].[HobbyID]
	LEFT OUTER JOIN [Hobby] as [H] on [H].[HobbyID] = [P2H].[HobbyID]
	LEFT OUTER JOIN [Lab] on [BTR].[LabID] = [Lab].[LabID]
	WHERE 1 = 0
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SLInsertedDataSimplified]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20130509
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLInsertedDataSimplified] 
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
/****** Object:  StoredProcedure [dbo].[usp_SlLabName]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150304
-- Description:	Lists lab names
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlLabName] 
	-- Add the parameters for the stored procedure here
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select LabName from Lab

END


GO
/****** Object:  StoredProcedure [dbo].[usp_SLListAllFamilyMembers]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150103
-- Description:	stored procedure to list family members
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLListAllFamilyMembers]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'SELECT [f].[familyid], FamilyName = [f].[lastname],[P].[LastName],[P].[Firstname]  from [person] as [p]
		 join [persontoFamily] [p2f] on [p].[personid] = [p2f].[personid] 
		 join [family] AS [f] on [f].[familyid] = [p2f].[familyid]
		 where 1=1';

	IF (@FamilyID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [f].[familyID] = @Family_ID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [f].[FamilyID],[f].[lastname]';


	IF (@FamilyID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY    
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Family_ID int'
			, @Family_ID = @FamilyID;
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
/****** Object:  StoredProcedure [dbo].[usp_SlListFamilies]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150110
-- Description:	User defined stored procedure to
--              select all families
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListFamilies]
	-- Add the parameters for the stored procedure her
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT [F].[FamilyID], ''FamilyName'' = [F].[LastName]
	from [family] AS [F]
	where 1 = 1'
	
	-- Return all families and associated properties if nothing was passed in
	SET @Recompile = 0

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [F].[LastName],[F].[FamilyID]'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		EXEC [sp_executesql] @spexecutesqlStr;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlListFamilyMembers]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150103
-- Description:	stored procedure to list family members
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListFamilyMembers]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'SELECT [f].[familyid], FamilyName = [f].[lastname],[P].[LastName],[P].[Firstname]  from [person] as [p]
		 join [persontoFamily] [p2f] on [p].[personid] = [p2f].[personid] 
		 join [family] AS [f] on [f].[familyid] = [p2f].[familyid]
		 where 1=1';

	IF (@FamilyID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [f].[familyID] = @Family_ID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [f].[lastname],[f].[familyid]';


	IF (@FamilyID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY    
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Family_ID int'
			, @Family_ID = @FamilyID;
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
/****** Object:  StoredProcedure [dbo].[usp_SLListNursingMothers]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150315
-- Description:	stored procedure to list nursing
--				mothers. 
--				If @Count is set to 1, returns the
--				number of nusring mothers
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLListNursingMothers]
	-- Add the parameters for the stored procedure here
	  @PersonID int = NULL
	, @Count BIT = 0 -- If 1 return county only, if 0 return full list
	, @DEBUG BIT = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	BEGIN TRY
		SELECT @spexecuteSQLStr =
			N'SELECT [PersonID],[QuestionnaireID],[LastName],[FirstName],[Age],[isNursing],[QuestionnaireDate] 
			from vNursingMothers where 1=1';

		IF (@PersonID IS NOT NULL) 
			SELECT @spexecuteSQLStr = @spexecuteSQLStr
				+ N' AND [PersonID] = @PersonID';

		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' order by [PersonID], [lastname]';

		-- select how many nursing mothers there are
		IF (@Count = 1)
		BEGIN
			SELECT @spexecuteSQLStr = N'SELECT count([PersonID]) from vNursingMothers';
			SET @Recompile = 0;
		END

		IF (@PersonID IS NULL) 
			SET @Recompile = 0;
	
		-- Recompile the stored procedure if the query return list is sufficiently small
		IF @Recompile = 1
			SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

		-- If debugging, output the query string
		IF @DEBUG = 1
			SELECT @spexecuteSQLStr, @PersonID

		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Person_ID int'
			, @Person_ID = @PersonID;
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
/****** Object:  StoredProcedure [dbo].[usp_SlListPeoplebyCreateDateRange]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150120
-- Description:	User defined stored procedure to
--              select People by created date range
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListPeoplebyCreateDateRange]
	-- Add the parameters for the stored procedure here
	@Begin_Date date = NULL,
	@End_Date date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	--SELECT [P].[PersonID], 'FamilyName' = [F].[LastName]
	--	, [P].[LastName], [P].[FirstName], [P].[CreatedDate]
	--	FROM [Person] AS [P]
	--	JOIN PersontoFamily AS P2F ON [P].[PersonID] = [P2F].[PersonID]
	--	JOIN [family] AS [F] ON [P2F].[FamilyID] = [F].[FamilyID]
	--	where 1 = 2 AND [P].[CreatedDate] >= @Begin_Date AND [P].[CreatedDate] <= @End_Date order by [P].[LastName],[P].[PersonID] OPTION(RECOMPILE)

	select @spexecutesqlStr ='SELECT [P].[PersonID],[P].[LastName],[P].[FirstName],[P].[CreatedDate]
								from [Person] AS [P]
								where 1 = 1'
	
	-- Return all People if nothing was passed in
	IF ((@Begin_Date is NULL) AND (@End_Date is NULL))
		SET @Recompile = 0

	IF (@Begin_Date is NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] >= @BeginDate'

	IF (@End_Date is NOT NULL)
	BEGIN
		SET @End_Date = DateAdd(dd,1,@End_Date)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[CreatedDate] < @EndDate'
	END

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [P].[CreatedDate] DESC, [P].[LastName],
	[P].[PersonID] ASC'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'BEGINDate' = @Begin_Date, 'ENDDate' = @End_Date, 'DEBUG' = @Debug

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@BeginDate datetime, @EndDate datetime'
		, @BeginDate = @Begin_Date
		, @EndDate = @End_Date;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		SELECT @ReturnError = ERROR_NUMBER();

		DROP TABLE ##ReturnedValues;
		RETURN @ReturnError
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SLListPotentialDuplicatePeople]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150127
-- Description:	stored procedure to potential 
--				duplicate people
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLListPotentialDuplicatePeople]
	-- Add the parameters for the stored procedure here
	@Debug bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	SELECT @spexecuteSQLStr =
		N'SELECT P1PersonID = P1.PersonID
				, P2PersonID = P2.PersonID	
				, P1LastName = P1.LastName
				, P2LastName = P2.LastName 
				, P1FirstName = P1.FirstName
				, P2FirstName = P2.FirstName 
				, P1BirthDate = P1.BirthDate
				, P2BirthDate = P2.BirthDate
				, P1Gender = P1.Gender
				, P2Gender = P2.Gender
				, P1CreatedDate = P1.CreatedDate
				, P2CreatedDate = P2.CreatedDate
				, P1ModifiedDate = P1.ModifiedDate
				, P2ModifiedDate = P2.ModifiedDate
			from person AS P1
			JOIN person AS P2 on 
				P1.LastName = P2.LastName
				AND P1.FirstName = P2.FirstName
				AND P1.Age = P2.Age
				AND P1.PersonID != P2.PersonID 
				OPTION(RECOMPILE)';

	BEGIN TRY    
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr;
		EXEC [sp_executesql] @spexecuteSQLStr;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Log Errors
			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SLListPotentialDuplicateProperties]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150127
-- Description:	stored procedure to potential 
--				duplicate properties
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLListPotentialDuplicateProperties]
	-- Add the parameters for the stored procedure here
	@Debug bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	SELECT @spexecuteSQLStr =
		N'SELECT [P1PropertyID] = [P1].[PropertyID]
				, [P2PropertyID] = [P2].[PropertyID]
				, [P1StreetNumber] = [P1].[StreetNumber]
				, [P2StreetNumber] = [P2].[StreetNumber]
				, [P1Street] = [P1].[Street]
				, [P2Street] = [P2].[Street]
				, [P1StreetSuffix] = [P1].[StreetSuffix]
				, [P2StreetSuffix] = [P2].[StreetSuffix]
				, [P1City] = [P1].[City]
				, [P2City] = [P2].[City]
				, [P1State] = [P1].[State]
				, [P2State] = [P2].[State]
				, [P1ZipCode] = [P1].[Zipcode]
				, [P2ZipCode] = [P2].[Zipcode]
				, [P1County] = [P1].[County]
				, [P2County] = [P2].[County]
				, [P1CreatedDate] = [P1].[CreatedDate]
				, [P2CreatedDate] = [P2].[CreatedDate]
				, [P1ModifiedDate] = [P1].[ModifiedDate]
				, [P2ModifiedDate] = [P2].[ModifiedDate]
			from [Property] AS [P1]
			JOIN [Property] AS [P2] on 
				[P1].[Street] = [P2].[Street]
				AND [P1].[StreetNumber] = [P2].[StreetNumber]
				AND [P1].[City] = [P2].[City]
				AND [P1].[County] = [P2].[County]
				AND [P1].[Zipcode] = [P2].[Zipcode]
				AND [P1].[State] = [P2].[State]
				AND [P1].[PropertyID] != [P2].[PropertyID]
				OPTION(RECOMPILE)';

	BEGIN TRY    
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr;
		EXEC [sp_executesql] @spexecuteSQLStr;
	END TRY
			BEGIN CATCH
			-- Call procedure to print error information.
			EXECUTE dbo.uspPrintError;

			-- Log Errors
			EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
			RETURN ERROR_NUMBER()
		END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SLMostRecentBloodTestResults]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20141222
-- Description:	select most recent blood test results
--				optionally only return for a specific 
--				client
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLMostRecentBloodTestResults] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@Min_Lead_Value numeric(9,4) = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000), @OrderBy NVARCHAR(500),
			@Recompile BIT = 1, @ErrorLogID int; 

    -- Insert statements for procedure here
	SELECT @spexecutesqlStr = N'Select [P].[LastName],[P].[FirstName],[P].[PersonID],[BTR].[LeadValue], [BTR].[SampleDate],[BTR].[HemoglobinValue]
								,[BTR].[CreatedDate],[BTR].[ModifiedDate],[BTR].[BloodTestResultsID] from [Person] AS [P]
								JOIN [BloodTestResults] AS [BTR] on [BTR].[BloodTestResultsID] = (
									select top 1 [BloodTestResultsID] from [BloodTestResults] 
									where [BloodTestResults].[PersonID] = [P].[PersonID]
									-- AND [LeadValue] > @MinLeadValue uncomment to list most recent tests with BLL above minimum
									) 
								WHERE 1=1';

	IF @Min_Lead_Value IS NULL
		SET @Min_Lead_Value = 0.0;

	IF @Person_ID IS NOT NULL
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[PersonID] = @PersonID';

	-- comment out if statement and immediate select statement to list most recent test with BLL above minimum
	IF (@Min_Lead_Value > 0)
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND  [BTR].[LeadValue] > @MinLeadValue';

	IF @Person_ID is NULL
	BEGIN
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' ORDER BY [p].[LastName], [P].[PersonID] ASC, [BTR].[SampleDate] DESC';
	END

	IF ( (@Person_ID IS NULL) AND (@Min_Lead_Value = 0.0) )
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		-- If debugging print out query
		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, 'PID' = @Person_ID, 'MLV' = @Min_Lead_Value, 'R' = @Recompile;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@PersonID int,@MinLeadValue numeric(9,4)'
		, @PersonID = @Person_ID, @MinLeadValue = @Min_Lead_Value;
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
/****** Object:  StoredProcedure [dbo].[usp_SlPersonNotes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to list 
--              person and their ethnicities
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlPersonNotes]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'select P.PersonID,LastName,FirstName, PN.Notes,P.ModifiedDate from Person AS P
			LEFT OUTER JOIN PersonNotes AS PN on P.PersonID = PN.PErsonID
			where Notes is not null';

	IF (@PersonID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [P].[PersonID] = @PersonID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [P].[lastname],[P].[Personid]';


	IF (@PersonID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
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
/****** Object:  StoredProcedure [dbo].[usp_SlPersontoEthnicity]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to list 
--              person and their ethnicities
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlPersontoEthnicity]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'select P.PersonID,LastName,FirstName,E.Ethnicity from Person AS P
			LEFT OUTER JOIN PersontoEthnicity AS P2E on P.PersonID = P2E.PErsonID
			LEFT OUTER JOIN Ethnicity AS E on P2E.EthnicityID = E.EthnicityID 
			WHERE 1 = 1';

	IF (@PersonID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [P].[PersonID] = @PersonID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [P].[lastname],[P].[Personid]';


	IF (@PersonID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
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
/****** Object:  StoredProcedure [dbo].[usp_SlPersontoLanguage]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	stored procedure to list 
--              person and their languages
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlPersontoLanguage]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	--IF (@FamilyID IS NULL)
	--BEGIN
	--	RAISERROR ('You must supply at least one parameter.', 11, -1);
	--	RETURN;
	--END;
	SELECT @spexecuteSQLStr =
		N'select [P].PersonID,LastName,FirstName, L.LanguageName from Person AS P
			LEFT OUTER JOIN PersontoLanguage AS P2L on P.PersonID = P2L.PErsonID
			LEFT OUTER JOIN Language AS L on P2L.LanguageID = L.LanguageID 
			WHERE 1 = 1';

	IF (@PersonID IS NOT NULL) 
		SELECT @spexecuteSQLStr = @spexecuteSQLStr
			+ N' AND [P].[PersonID] = @PersonID';

	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [P].[lastname],[P].[Personid]';


	IF (@PersonID IS NULL) 
		SET @Recompile = 0;
	
	IF @Recompile = 1
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' OPTION(RECOMPILE)';

	BEGIN TRY   
		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'PersonID' = @PersonID;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@PersonID int'
			, @PersonID = @PersonID;
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
/****** Object:  StoredProcedure [dbo].[usp_SlRelationShipTypes]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150110
-- Description:	User defined stored procedure to
--              select all relationship types and IDs
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlRelationShipTypes]
	-- Add the parameters for the stored procedure her
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	select @spexecutesqlStr ='SELECT [RT].[RelationshipTypeID], [RT].[RelationshipTypeName]
	from [RelationshipType] AS [RT]
	where 1 = 1'
	
	-- Return all families and associated properties if nothing was passed in
	SET @Recompile = 0

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [RT].[RelationshipTypeName]'
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		EXEC [sp_executesql] @spexecutesqlStr;
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Add error information to errorlog
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END
GO
/****** Object:  StoredProcedure [dbo].[usp_SlStatus]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	returns valid status codes for passed in type - Child
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlStatus] 
	-- Add the parameters for the stored procedure here
	@TargetType varchar(50) = NULL, 
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	-- IF (@StatusType = 'Child')
		select statusName from TargetStatus where TargetType = @TargetType

END

GO
/****** Object:  StoredProcedure [dbo].[usp_SlTargetSampleType]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150102
-- Description:	retrieve sample types for people (lead levels)
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlTargetSampleType] 
	-- Add the parameters for the stored procedure here
	@Sample_Target varchar(50) = NULL, 
	@p2 int = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr nvarchar(4000), @RECOMPILE bit =1;
    -- Insert statements for procedure here

	SELECT @spexecutesqlStr = 'SELECT [SampleTypeID],[SampleTypeName] from [SampleType] where 1=1'
	
	if (@Sample_Target IS NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [SampleType].[SampleTarget] = @SampleTarget'

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' OPTION(RECOMPILE)';

	EXEC [sp_executesql] @spexecutesqlStr
		, N'@SampleTarget varchar(50)', @SampleTarget = @Sample_Target
END
GO
/****** Object:  StoredProcedure [dbo].[usp_upClientWebScreen]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150325
-- Description:	stored procedure to update data 
--              from the Add a new client web page
-- =============================================
CREATE PROCEDURE [dbo].[usp_upClientWebScreen]
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
	@New_Notes varchar(3000) = NULL,
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
						@New_Notes = @New_Notes,
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
			IF (@New_LanguageID is not NULL)
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
/****** Object:  StoredProcedure [dbo].[usp_upFamily]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20150214
-- Description:	Stored Procedure to update Family information
-- =============================================

CREATE PROCEDURE [dbo].[usp_upFamily]  
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL,
	@New_Last_Name varchar(50) = NULL,
	@New_Number_of_Smokers tinyint = 0,
	@New_Primary_Language_ID tinyint = 1,
	@New_Notes varchar(3000) = NULL,
	@New_Pets tinyint = NULL,
	@New_Frequently_Wash_Pets bit = NULL,
	@New_Pets_in_and_out bit = NULL,
	@New_Primary_Property_ID int = NULL,
	@New_ForeignTravel bit = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ErrorLogID int, @spupdateFamilysqlStr nvarchar(4000)
			, @NotesID INT, @Recompile BIT = 1;
	
	BEGIN TRY -- update Family information
		-- BUILD update statement
		IF (@New_Last_Name IS NULL)
			SELECT @New_Last_Name = LastName from family where FamilyID = @Family_ID;
	
		SELECT @spupdateFamilysqlStr = N'update Family set Lastname = @LastName'

		IF (@New_Number_of_Smokers IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', NumberofSmokers = @NumberofSmokers'

		IF (@New_Primary_Language_ID IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', PrimaryLanguageID = @PrimaryLanguageID'

		IF (@New_Pets IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', Pets = @Pets'

		IF (@New_Frequently_Wash_Pets IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', FrequentlyWashPets = @FrequentlyWashPets'	
			
		IF (@New_Pets_in_and_out IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', Petsinandout = @Petsinandout'

		IF (@New_Primary_Property_ID IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', PrimaryPropertyID = @PrimaryPropertyID'

		IF (@New_ForeignTravel IS NOT NULL)
			SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N', ForeignTravel = @ForeignTravel'


		SELECT @spupdateFamilysqlStr = @spupdateFamilysqlStr + N' WHERE FamilyID = @FamilyID'

		IF @DEBUG = 1
			SELECT @spupdateFamilysqlStr, 'Lastname' = @New_Last_Name, 'NumberofSmokers' = @New_Number_of_Smokers
				, 'PrimaryLanguageID' = @New_Primary_Language_ID, 'Pets' = @New_Pets, 'Petsinandout' = @New_Pets_in_and_out
				, 'PrimaryPropertyID' = @New_Primary_Property_ID, 'FrequentlyWashPets' = @New_Frequently_Wash_Pets
				, 'ForeignTravel' = @New_ForeignTravel
			
			IF (@New_Notes IS NOT NULL)
			BEGIN
				IF @DEBUG = 1
					SELECT 'EXEC [dbo].[usp_InsertFamilyNotes] @Family_ID = @Family_ID, @Notes = @New_Notes, @InsertedNotesID = @NotesID OUTPUT ' 
						, @Family_ID, @New_Notes 

				EXEC	[dbo].[usp_InsertFamilyNotes]
							@Family_ID = @Family_ID,
							@Notes = @New_Notes,
							@InsertedNotesID = @NotesID OUTPUT
			END
	
			-- update Family table
			EXEC [sp_executesql] @spupdateFamilysqlStr
				, N'@LastName VARCHAR(50), @NumberofSmokers tinyint, @PrimaryLanguageID tinyint
				, @Pets tinyint, @Petsinandout BIT, @PrimaryPropertyID int, @FrequentlyWashPets bit, @ForeignTravel bit, @FamilyID int'
				, @LastName = @New_Last_Name
				, @NumberofSmokers = @New_Number_of_Smokers
				, @PrimaryLanguageID = @New_Primary_Language_ID
				, @Pets = @New_Pets
				, @Petsinandout = @New_Pets_in_and_out
				, @PrimaryPropertyID = @New_Primary_Property_ID
				, @FrequentlyWashPets = @New_Frequently_Wash_Pets
				, @ForeignTravel = @New_ForeignTravel
				, @FamilyID = @Family_ID
	END TRY -- update Family
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
/****** Object:  StoredProcedure [dbo].[usp_upFamilyWebScreen]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20150329
-- Description:	Stored Procedure to update Family 
--              web screen information
-- =============================================

CREATE PROCEDURE [dbo].[usp_upFamilyWebScreen]  
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL,
	@isNewAddress bit = 0,
	@New_Last_Name varchar(50) = NULL,
	@PropertyID int = NULL,
	@New_ConstructionType int = NULL,
	@New_AreaID int = NULL,
	@New_isinHistoricDistrict bit = NULL,
	@New_isRemodeled bit = NULL, 
	@New_RemodelDate date = NULL,
	@New_isinCityLimits bit = NULL,
	@New_Address_Line1 varchar(100) = NULL,
	@New_Address_Line2 varchar(100) = NULL,
	@New_CityName varchar(50) = NULL,
	@New_County varchar(50) = NULL,
	@New_StateAbbr char(2) = NULL,
	@New_ZipCode varchar(10) = NULL,
	@New_Year_Built date = NULL,
	@New_Owner_id int = NULL,
	@New_is_Owner_Occupied bit = NULL,
	@New_ReplacedPipesFaucets bit = NULL,
	@New_TotalRemediationCosts money = NULL,
	@New_PropertyNotes varchar(3000) = NULL,
	@New_is_Residential bit = NULL,
	@New_isCurrentlyBeingRemodeled bit = NULL,
	@New_has_Peeling_Chipping_Patin bit = NULL,
	@New_is_Rental bit = NULL,
	@New_HomePhone bigint = NULL,
	@New_WorkPhone bigint = NULL,
	@New_Number_of_Smokers tinyint = NULL,
	@New_Primary_Language_ID tinyint = 1,
	@New_Family_Notes varchar(3000) = NULL,
	@New_Pets tinyint = NULL,
	@New_Frequently_Wash_Pets bit = NULL,
	@New_Pets_in_and_out bit = NULL,
	-- @New_Primary_Property_ID int = NULL,
	@New_ForeignTravel bit = NULL,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ErrorLogID int, @Update_Family_return_value int
			, @Update_Property_return_value int
			, @NotesID INT, @Recompile BIT = 1
			, @New_Primary_Property_ID int;
	
	BEGIN TRY -- update Family information
		-- Exit if family isn't specified
		IF (@Family_ID IS NULL)
		BEGIN
			RAISERROR (50001, 11, -1,'Family must be specified');
			RETURN;
		END;

		-- Exit if property isn't specified
		IF (@PropertyID IS NULL)
		BEGIN
			RAISERROR (50002, 11, -1,'Property must be specified');
			RETURN;
		END;

		IF (@isNewAddress = 0)
		BEGIN
			EXEC @Update_Property_return_value = [dbo].[usp_upProperty]
				@PropertyID = @PropertyID,
				@New_ConstructionTypeID = @New_ConstructionType,
				@New_AreaID = @New_AreaID,
				@New_isinHistoricDistrict = @New_isinHistoricDistrict,
				@New_isRemodeled = @New_isRemodeled,
				@New_RemodelDate = @New_RemodelDate,
				@New_isinCityLimits = @New_isinCityLimits,
				@New_AddressLine1 = @New_Address_Line1,
				@New_AddressLine2 = @New_Address_Line2,
				@New_City = @New_CityName,
				@New_State = @New_StateAbbr,
				@New_Zipcode = @New_ZipCode,
				@New_YearBuilt = @New_Year_Built,
				@New_Ownerid = @New_Owner_id,
				@New_isOwnerOccuppied = @New_is_Owner_Occupied,
				@New_ReplacedPipesFaucets = @New_ReplacedPipesFaucets,
				@New_TotalRemediationCosts = @New_TotalRemediationCosts,
				@New_PropertyNotes = @New_PropertyNotes,
				@New_isResidential = @New_is_Residential,
				@New_isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled,
				@New_hasPeelingChippingPaint = @New_has_Peeling_Chipping_Patin,
				@New_County = @New_County,
				@New_isRental = @New_is_Rental,
				@DEBUG = @DEBUG

			-- SET the new primary property ID
			SET @New_Primary_Property_ID = @PropertyID;
		END

		IF (@isNewAddress = 1)
		BEGIN
			EXEC [dbo].[usp_InsertProperty]
				@ConstructionTypeID = @New_ConstructionType,
				@AreaID = @New_AreaID,
				@isinHistoricDistrict = @New_isinHistoricDistrict, 
				@isRemodeled = @New_isRemodeled,
				@RemodelDate = @New_RemodelDate,
				@isinCityLimits = @New_isinCityLimits,
				@AddressLine1 = @New_Address_Line1,
				@AddressLine2 = @New_Address_Line2,
				@City = @New_CityName,
				@State = @New_StateAbbr,
				@Zipcode = @New_ZipCode,
				@YearBuilt = @New_Year_Built,
				@Ownerid = @New_Owner_id,
				@isOwnerOccuppied = @New_is_Owner_Occupied,
				@ReplacedPipesFaucets = @New_ReplacedPipesFaucets,
				@TotalRemediationCosts = @New_TotalRemediationCosts,
				@New_PropertyNotes = @New_PropertyNotes,
				-- @isResidential = @New_isResidential,
				@isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled,
				@hasPeelingChippingPaint = @New_has_Peeling_Chipping_Patin,
				@County = @New_County,
				-- @isRental = @New_isRental,
				--@OverRideDuplicate = @New_OverRideDuplicate,
				@PropertyID = @New_Primary_Property_ID OUTPUT
		END

				
		EXEC	@Update_Family_return_value = [dbo].[usp_upFamily]
				@Family_ID = @Family_ID,
				@New_Last_Name = @New_Last_Name,
				@New_Number_of_Smokers = @New_Number_of_Smokers,
				@New_Primary_Language_ID = @New_Primary_Language_ID,
				@New_Notes = @New_Family_Notes,
				@New_Pets = @New_Pets,
				@New_Frequently_Wash_Pets = @New_Frequently_Wash_Pets,
				@New_Pets_in_and_out = @New_Pets_in_and_out,
				@New_Primary_Property_ID = @New_Primary_Property_ID,
				@New_ForeignTravel = @New_ForeignTravel,
				@DEBUG = @DEBUG;

	END TRY -- update Family
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
/****** Object:  StoredProcedure [dbo].[usp_upOccupation]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
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
/****** Object:  StoredProcedure [dbo].[usp_upPerson]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20130506
-- Description:	Stored Procedure to up new people records
-- =============================================
-- DROP PROCEDURE usp_upPerson
CREATE PROCEDURE [dbo].[usp_upPerson]  
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
/****** Object:  StoredProcedure [dbo].[usp_upProperty]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to update property records
-- =============================================

CREATE PROCEDURE [dbo].[usp_upProperty]   -- usp_upProperty 
	-- Add the parameters for the stored procedure here
	@PropertyID int = NULL,
	@New_ConstructionTypeID tinyint = NULL,
	@New_AreaID int = NULL,
	@New_isinHistoricDistrict bit = NULL, 
	@New_isRemodeled bit = NULL,
	@New_RemodelDate date = NULL,
	@New_isinCityLimits bit = NULL,
	-- @StreetNumber smallint = NULL,
	@New_AddressLine1 varchar(100) = NULL,
	-- @StreetSuffix varchar(20) = NULL,
	@New_AddressLine2 varchar(100) = NULL,
	@New_City varchar(50) = NULL,
	@New_State char(2) = NULL,
	@New_Zipcode varchar(12) = NULL,
	@New_YearBuilt date = NULL,
	@New_Ownerid int = NULL,
	@New_isOwnerOccuppied bit = NULL,
	@New_ReplacedPipesFaucets tinyint = 0,
	@New_TotalRemediationCosts money = NULL,
	@New_PropertyNotes varchar(3000) = NULL,
	@New_isResidential bit = NULL,
	@New_isCurrentlyBeingRemodeled bit = NULL,
	@New_hasPeelingChippingPaint bit = NULL,
	@New_County varchar(50) = NULL,
	@New_isRental bit = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @NotesID int, @spupdatePropertysqlStr nvarchar(4000);
    -- Insert statements for procedure here
	BEGIN TRY
		if (@PropertyID iS NULL)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString = 'Property must be specified';
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		-- BUILD update statement
		IF (@New_isinHistoricDistrict IS NULL)
			SELECT @New_isinHistoricDistrict = isinHistoricDistrict from Property where PropertyID = @PropertyID;
	
		SELECT @spupdatePropertysqlStr = N'update Property set isinHistoricDistrict = @isinHistoricDistrict'

		IF (@New_ConstructionTypeID IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', ConstructionTypeID = @ConstructionTypeID'

		IF (@New_AreaID IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', AreaID = @AreaID'

		IF (@New_isRemodeled IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isRemodeled = @isRemodeled'

		IF (@New_RemodelDate IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', RemodelDate = @RemodelDate'

		IF (@New_isinCityLimits IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isinCityLimits = @isinCityLimits'

		IF (@New_AddressLine1 IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', AddressLine1 = @AddressLine1'

		IF (@New_AddressLine2 IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', AddressLine2 = @AddressLine2'	
			
		IF (@New_City IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', City = @City'

		IF (@New_State IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', State = @State'

		IF (@New_Zipcode IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', ZipCode = @ZipCode'

		IF (@New_Ownerid IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', OwnerID = @OwnerID'
			
		IF (@New_isOwnerOccuppied IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isOwnerOccuppied = @isOwnerOccuppied'
			
		IF (@New_ReplacedPipesFaucets IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', ReplacedPipesFaucets = @ReplacedPipesFaucets'
			
		IF (@New_TotalRemediationCosts IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', TotalRemediationCosts = @TotalRemediationCosts'
			
		IF (@New_isResidential IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isResidential = @isResidential'
			
		IF (@New_isCurrentlyBeingRemodeled IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isCurrentlyBeingRemodeled = @isCurrentlyBeingRemodeled'
			
		IF (@New_hasPeelingChippingPaint IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', hasPeelingChippingPaint = @hasPeelingChippingPaint'
			
		IF (@New_County IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', County = @County'
			
		IF (@New_isRental IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', isRental = @isRental'
			
		IF (@New_YearBuilt IS NOT NULL)
			SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N', YearBuilt = @YearBuilt'

		SELECT @spupdatePropertysqlStr = @spupdatePropertysqlStr + N' WHERE PropertyID = @PropertyID'

		-- update property table
		IF @DEBUG = 1
			SELECT @spupdatePropertysqlStr, @New_ConstructionTypeID, @New_AreaID, @New_isinHistoricDistrict, @New_isRemodeled
					, @New_RemodelDate, @New_isinCityLimits, @New_AddressLine1, @New_AddressLine2, @New_City, @New_State
					, @New_Zipcode, @New_Ownerid, @New_isOwnerOccuppied, @New_ReplacedPipesFaucets, @New_PropertyNotes, @New_TotalRemediationCosts
					, @New_isResidential, @New_isCurrentlyBeingRemodeled, @New_hasPeelingChippingPaint, @New_County
					, @New_isRental, @New_YearBuilt, @PropertyID

		EXEC [sp_executesql] @spupdatePropertysqlStr 
			, N'@ConstructionTypeID tinyint, @AreaID int, @isinHistoricDistrict bit, @isRemodeled bit, @RemodelDate date
			, @isinCityLimits BIT, @AddressLine1 varchar(100), @AddressLine2 varchar(100), @City varchar(50), @State char(2)
			, @Zipcode varchar(12), @OwnerID int, @isOwnerOccuppied bit, @ReplacedPipesFaucets tinyint, @TotalRemediationCosts money
			, @isResidential bit, @isCurrentlyBeingRemodeled bit, @hasPeelingChippingPaint bit
			, @County varchar(50), @isRental bit, @YearBuilt date, @PropertyID int'
			, @ConstructionTypeID = @New_ConstructionTypeID
			, @AreaID = @New_AreaID
			, @isinHistoricDistrict = @New_isinHistoricDistrict
			, @isRemodeled = @New_isRemodeled
			, @RemodelDate = @New_RemodelDate
			, @isinCityLimits = @New_isinCityLimits
			, @AddressLine1 = @New_AddressLine1
			, @AddressLine2 = @New_AddressLine2
			, @City = @New_City
			, @State = @New_State
			, @Zipcode = @New_Zipcode
			, @OwnerID = @New_Ownerid
			, @isOwnerOccuppied = @New_isOwnerOccuppied
			, @ReplacedPipesFaucets = @New_ReplacedPipesFaucets
			, @TotalRemediationCosts = @New_TotalRemediationCosts
			, @isResidential = @New_isResidential
			, @isCurrentlyBeingRemodeled = @New_isCurrentlyBeingRemodeled
			, @hasPeelingChippingPaint = @New_hasPeelingChippingPaint
			, @County = @New_County
			, @isRental = @New_isRental
			, @YearBuilt = @New_YearBuilt
			, @PropertyID = @PropertyID

		IF (@New_PropertyNotes IS NOT NULL)
		BEGIN
			IF @DEBUG = 1
				SELECT 'EXEC [dbo].[usp_InsertPropertyNotes] @Property_ID = @Property_ID, @Notes = @New_PropertyNotes, @InsertedNotesID = @NotesID OUTPUT ' 
					, @PropertyID, @New_PropertyNotes

				EXEC	[dbo].[usp_InsertPropertyNotes]
						@Property_ID = @PropertyID,
						@Notes = @New_PropertyNotes,
						@InsertedNotesID = @NotesID OUTPUT
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
/****** Object:  StoredProcedure [dbo].[uspLogError]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspLogError] 
    @ErrorLogID [int] = 0 OUTPUT  -- Contains the ErrorLogID of the row inserted
                                  -- by uspLogError in the ErrorLog table.

AS
BEGIN
    SET NOCOUNT ON;

    -- Output parameter value of 0 indicates that error 
    -- information was not logged.
    SET @ErrorLogID = 0;

    BEGIN TRY
        -- Return if there is no error information to log.
        IF ERROR_NUMBER() IS NULL
            RETURN;

        -- Return if inside an uncommittable transaction.
        -- Data insertion/modification is not allowed when 
        -- a transaction is in an uncommittable state.
        IF XACT_STATE() = -1
        BEGIN
            PRINT 'Cannot log error since the current transaction is in an uncommittable state. ' 
                + 'Rollback the transaction before executing uspLogError in order to successfully log error information.';
            RETURN;
        END;

        INSERT [dbo].[ErrorLog] 
            (
            [UserName], 
            [ErrorNumber], 
            [ErrorSeverity], 
            [ErrorState], 
            [ErrorProcedure], 
            [ErrorLine], 
            [ErrorMessage]
            ) 
        VALUES 
            (
            CONVERT(sysname, CURRENT_USER), 
            ERROR_NUMBER(),
            ERROR_SEVERITY(),
            ERROR_STATE(),
            ERROR_PROCEDURE(),
            ERROR_LINE(),
            ERROR_MESSAGE()
            );

        -- Pass back the ErrorLogID of the row inserted
        SELECT @ErrorLogID = @@IDENTITY;
    END TRY
    BEGIN CATCH
        PRINT 'An error occurred in stored procedure uspLogError: ';
        EXECUTE [dbo].[uspPrintError];
        RETURN -1;
    END CATCH
END; 
GO
/****** Object:  StoredProcedure [dbo].[uspPrintError]    Script Date: 4/13/2015 11:30:48 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE PROCEDURE [dbo].[uspPrintError] 
AS
BEGIN
    SET NOCOUNT ON;

    -- Print error information. 
    PRINT 'Error ' + CONVERT(varchar(50), ERROR_NUMBER()) +
          ', Severity ' + CONVERT(varchar(5), ERROR_SEVERITY()) +
          ', State ' + CONVERT(varchar(5), ERROR_STATE()) + 
          ', Procedure ' + ISNULL(ERROR_PROCEDURE(), '-') + 
          ', Line ' + CONVERT(varchar(5), ERROR_LINE());
    PRINT ERROR_MESSAGE();
END;

GO
