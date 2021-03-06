USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountBloodLeadLevels]    Script Date: 6/11/2015 11:37:32 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150601
-- Description:	procedure returns the number of 
--				entries in the persons table
--				with blood test results within 
--				the specified date range, and 
--				>= 5 and < 10
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlCountBloodLeadLevels] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@MinLeadValue numeric(4,1) = NULL,
	@MaxLeadValue Numeric(4,1) = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int;
	
	BEGIN TRY
		SELECT @spexecutesqlStr = 'SELECT EBBLTests = count([BloodTestResultsID]) from [BloodTestResults] 
			where 1 = 1'

		IF (@MinLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND Leadvalue >= @MinLeadValue'
		
		IF (@MaxLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND LeadValue < @MaxLeadValue'

		IF (@StartDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate >= @StartDate'

		IF (@EndDate IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND SampleDate < @EndDate'
			
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate, [MinLeadValue] = @MinLeadValue, [MaxLeadValue] = @MaxLeadValue

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @MinLeadValue numeric(4,1), @MaxLeadValue numeric(4,1)'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @MinLeadValue = @MinLeadValue
		, @MaxLeadValue = @MaxLeadValue

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
