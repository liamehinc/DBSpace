USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlCountPeople]    Script Date: 3/15/2015 6:51:12 PM ******/
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
