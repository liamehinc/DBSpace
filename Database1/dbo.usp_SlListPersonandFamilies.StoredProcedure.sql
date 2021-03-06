USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlListPersonandFamilies]    Script Date: 12/5/2015 5:39:42 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20151104
-- Description:	stored procedure to list all 
--              families they are associated with
--				if the @withoutFamily parameter = 1
--				only people with no family
--				associations will be returned
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlListPersonandFamilies]
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@FamilyID int = NULL,
	@WithoutFamily bit = 0,
	@DEBUG BIT = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @spexecuteSQLStr NVARCHAR(4000)
			, @Recompile  BIT = 1, @ErrorLogID int;
	
	-- Build the base select statement
	SELECT @spexecuteSQLStr = N'Select [P].[PersonID], [P].[LastName], [P].[FirstName], [P].[BirthDate]'
	
	-- If the people have families, select family information and property, otherwise limit selection to person information
	if (@WithoutFamily = 0)
	BEGIN
		SELECT @spexecuteSQLStr = @spexecuteSQLStr +
			', [F].[FamilyID], [FamilyName] = [F].[LastName]
			, [Pr].[PropertyID], [Pr].[AddressLine1], [Pr].[AddressLine2]
			FROM [Person] as [P]
			LEFT OUTER JOIN [PersontoFamily] AS [P2F] on [P].[PersonID] = [P2F].[PersonID]
			LEFT OUTER JOIN [Family] AS [F] on [P2F].[FamilyID] = [F].[FamilyID]
			LEFT OUTER JOIN [Property] AS [Pr] on [F].[PrimaryPropertyID] = [Pr].[PropertyID]
			WHERE 1 = 1';

		IF (@PersonID IS NOT NULL) 
			SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' AND [P].[PersonID] = @PersonID';
		ELSE SET @Recompile = 0;

	END

	ELSE
	BEGIN
		Select @spexecuteSQLStr = @spexecuteSQLStr + 
								' from [Person] AS [P]
								where PersonID not in (select distinct PersonID from PersontoFamily)'
		IF (@PersonID IS NOT NULL) 
			SELECT @spexecuteSQLStr = @spexecuteSQLStr + N' AND [P].[PersonID] = @PersonID';
		ELSE SET @Recompile = 0;
	END

	-- Construct the order by clause
	SELECT @spexecuteSQLStr = @spexecuteSQLStr
		+ N' order by [P].[LastName],[P].[FirstName]';

	IF (@WithoutFamily = 0)
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + ',[F].[lastname]'

	SELECT @spexecuteSQLStr = @spexecuteSQLStr + ',[P].[PersonID]'

	-- If there are only a few records recompile the procedure
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
