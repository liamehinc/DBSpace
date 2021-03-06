USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertNewBloodLeadTestResultsWebScreen]    Script Date: 6/11/2015 5:18:14 PM ******/
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
	@Blood_Lead_Result numeric(4,1)= NULL, -- Is this Lead value?
	@Flag INT = 365, -- flag follow up date
	@Test_Type tinyint = NULL, -- SampleTypeID need to determine if/how new testTypes are created
	@Lab varchar(50) = NULL,  -- is this necessary i think the lab should be selected from a drop down with the option to add a new lab and an id should be passed?
	@Lab_ID int = NULL,
	@Child_Status_Code smallint = NULL, -- StatusID need to determine if/how new statusCodes are created
	@Child_Status_Date date = NULL,
	@Hemoglobin_Value numeric(4,1) = NULL,
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
				@ClientStatusID = @Child_Status_Code,
				@BloodTestCosts = NULL,
				@sampleTypeID = @Test_Type,
				@New_Notes = NULL,
				@TakenAfterPropertyRemediationCompleted = NULL,
				@BloodTestResultID = @Blood_Test_Results_ID OUTPUT

		--IF (@Child_Status_Code IS NOT NULL)
		--BEGIN
		--	IF (@Child_Status_Date IS NULL)
		--		SELECT @Child_Status_Date = GetDate();

		--	IF @DEBUG = 1
		--		SELECT '@ChildStatusCode_return_value = [dbo].[usp_InsertPersontoStatus] @PersonID = @Person_ID, @StatusID = @Child_Status_Code, @StatusDate = @Sample_Date' 
		--					,@Person_ID , @Child_Status_Code, @Sample_Date

		--	EXEC	@ChildStatusCode_return_value = [dbo].[usp_InsertPersontoStatus]
		--			@PersonID = @Person_ID,
		--			@StatusID = @Child_Status_Code,
		--			@StatusDate = @Sample_Date
		--END

		-- set the retest date based on integer value passed in as Flag
		SET @Retest_Date = DATEADD(dd,@Flag,@Sample_Date);

		-- update Person table with the new retest date
		-- anyone with a blood test is a client
		EXEC	@RetestDate_return_value = [dbo].[usp_upPerson]
				@Person_ID = @Person_ID
				, @New_RetestDate = @Retest_Date
				, @New_ClientStatusID = @Child_Status_Code
				, @New_isClient = 1;
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
