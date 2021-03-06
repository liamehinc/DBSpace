USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SLMostRecentBloodTestResults]    Script Date: 12/5/2015 5:39:42 PM ******/
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
	@Min_Lead_Value numeric(4,1) = NULL,
	@Max_Lead_Value numeric(4,1) = NULL,
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
									order by SampleDate desc
									) 
								WHERE 1=1';

	IF @Min_Lead_Value IS NULL
		SET @Min_Lead_Value = 0.0;

	IF @Person_ID IS NOT NULL
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[PersonID] = @PersonID';

	IF (@Min_Lead_Value > 0)
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND  [BTR].[LeadValue] >= @MinLeadValue';

	IF (@Max_Lead_Value > 0)
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND  [BTR].[LeadValue] < @MaxLeadValue';

	IF @Person_ID is NULL
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' ORDER BY [p].[LastName], [P].[PersonID] ASC, [BTR].[SampleDate] DESC';
	
	IF ( (@Person_ID IS NULL) AND (@Min_Lead_Value = 0) )
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		-- If debugging print out query
		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, 'PID' = @Person_ID, 'MLV' = @Min_Lead_Value, 'MaxLV' = @Max_Lead_Value, 'R' = @Recompile;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@PersonID int,@MinLeadValue numeric(4,1), @MaxLeadvalue numeric(4,1)'
		, @PersonID = @Person_ID, @MinLeadValue = @Min_Lead_Value, @MaxleadValue = @Max_Lead_Value;
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
