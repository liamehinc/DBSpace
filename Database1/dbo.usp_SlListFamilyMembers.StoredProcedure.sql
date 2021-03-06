USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlListFamilyMembers]    Script Date: 4/26/2015 8:29:36 PM ******/
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
