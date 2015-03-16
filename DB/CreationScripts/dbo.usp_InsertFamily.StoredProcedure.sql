USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertFamily]    Script Date: 3/15/2015 6:51:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20140205
-- Description:	Stored Procedure to insert new Family information
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertFamily]  
	-- Add the parameters for the stored procedure here
	@LastName varchar(50) = NULL,
	@NumberofSmokers tinyint = 0,
	@PrimaryLanguageID tinyint = 1,
	@Notes varchar(3000) = NULL,
	@Pets bit = 0,
	@inandout bit = NULL,
	@PrimaryPropertyID int = NULL,
	@FID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	DECLARE @ErrorLogID int, @FamilyNotesReturnValue int, @InsertedNotesID int;

	BEGIN TRY -- insert Family
		BEGIN TRANSACTION InsertFamilyTransaction
			INSERT into Family ( LastName,  NumberofSmokers,  PrimaryLanguageID, Pets, inandout
						, PrimaryPropertyID) 
						Values (@LastName, @NumberofSmokers, @PrimaryLanguageID, @Pets, @inandout
						, @PrimaryPropertyID)
			SET @FID = SCOPE_IDENTITY();  -- uncomment to return primary key of inserted values

			IF (@Notes IS NOT NULL)
			BEGIN
				EXEC	@FamilyNotesReturnValue = [dbo].[usp_InsertFamilyNotes]
													@Family_ID = @FID,
													@Notes = @Notes,
													@InsertedNotesID = @InsertedNotesID OUTPUT
			END
		COMMIT TRANSACTION InsertFamilyTransaction
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
		RETURN ERROR_NUMBER();
	END CATCH; 
END
GO
