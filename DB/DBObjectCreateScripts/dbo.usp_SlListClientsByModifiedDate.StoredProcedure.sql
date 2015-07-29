USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlListClientsByModifieddate]    Script Date: 7/29/2015 1:05:09 PM ******/
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
ALTER PROCEDURE [dbo].[usp_SlListClientsByModifieddate]
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DEBUG bit = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR (4000),
        @Recompile  BIT = 1, @ErrorLogID int, @ReturnError int;

	select @spexecutesqlStr ='SELECT [P].[PersonID],[HistoricID] = [P].[HistoricChildID],[P].[LastName],[P].[MiddleName],[P].[FirstName],[P].[BirthDate],[P].[Gender],[P].[ModifiedDate]
								from [Person] AS [P]
								where 1 = 1';

	-- Return all People if nothing was passed in
	IF ((@StartDate is NULL) AND (@EndDate is NULL))
		SET @Recompile = 0;

	IF (@StartDate is NOT NULL)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[ModifiedDate] >= @BeginDate';

	IF (@EndDate is NOT NULL)
	BEGIN
		SET @EndDate = DateAdd(dd,1,@EndDate)
		SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND [P].[ModifiedDate] < @EndDate';
	END

	-- order by last name
	SELECT @spexecutesqlStr = @spexecutesqlStr + N' order by [P].[ModifiedDate] ASC, [P].[LastName],
	[P].[PersonID] ASC';
		
	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY 
		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'BEGINDate' = @StartDate, 'ENDDate' = @EndDate, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@BeginDate datetime, @EndDate datetime'
		, @BeginDate = @StartDate
		, @EndDate = @EndDate;
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

