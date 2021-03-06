USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlPersonNotes]    Script Date: 4/26/2015 8:29:36 PM ******/
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
