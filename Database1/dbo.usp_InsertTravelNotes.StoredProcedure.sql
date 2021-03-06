USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertTravelNotes]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150319
-- Description:	stored procedure to insert Travel notes
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertTravelNotes] 
	-- Add the parameters for the stored procedure here
	@Family_ID int = NULL, 
	@Travel_Notes VARCHAR(3000) = NULL,
	@Start_Date date = NULL,
	@End_Date date = NULL,
	@InsertedNotesID INT OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;
	DECLARE @ErrorLogID int

    -- Insert statements for procedure here
	BEGIN TRY -- update Property information
		INSERT INTO TravelNotes (FamilyID, Notes, StartDate, EndDate) 
				values (@Family_ID, @Travel_Notes, @Start_Date, @End_Date);
		SET @InsertedNotesID = SCOPE_IDENTITY();
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		-- inserting information in the ErrorLog.
		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH; 
END



GO
