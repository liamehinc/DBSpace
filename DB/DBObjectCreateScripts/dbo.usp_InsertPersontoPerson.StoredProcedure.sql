USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoPerson]    Script Date: 3/26/2015 1:22:08 AM ******/
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
	@isGuardian bit = NULL,
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
