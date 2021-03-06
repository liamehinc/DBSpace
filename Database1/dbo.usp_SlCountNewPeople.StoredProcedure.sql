USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountNewPeople]    Script Date: 4/26/2015 8:29:36 PM ******/
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
