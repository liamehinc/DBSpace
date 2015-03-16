USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertPersontoDaycare]    Script Date: 3/15/2015 6:51:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new PersontoDaycare records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertPersontoDaycare]   -- usp_InsertPersontoDaycare
	-- Add the parameters for the stored procedure here
	@PersonID int = NULL,
	@DaycareID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@DaycareNotes varchar(3000) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into PersontoDaycare( PersonID, DaycareID, StartDate, EndDate)
					 Values ( @PersonID, @DaycareID, @StartDate, @EndDate);
		--SELECT SCOPE_IDENTITY();
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
