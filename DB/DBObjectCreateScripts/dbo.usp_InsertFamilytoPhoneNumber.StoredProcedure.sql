USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertFamilytoPhoneNumber]    Script Date: 4/16/2015 5:43:54 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20150404
-- Description:	Stored Procedure to insert new 
--				FamilytoPhoneNumber records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertFamilytoPhoneNumber]
	-- Add the parameters for the stored procedure here
	@FamilyID int = NULL,
	@PhoneNumberID int = NULL,
	@NumberPriority tinyint = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @ExistingNumberPriority tinyint, @FamilytoPhoneNumberExists bit
		, @FamilyPhonePriorityExists bit;
    -- Insert statements for procedure here
	BEGIN TRY
		-- see if the family already has a number with same priority
		SELECT @FamilyPhonePriorityExists = 1 from FamilytoPhoneNumber where FamilyID = @FamilyID and NumberPriority = @NumberPriority
		
		-- if the family already has a phone number with the same priority, update the phonenumber id for that record
		-- if not, enter a new family to phone number relationship
		IF (@FamilyPhonePriorityExists = 1)
		BEGIN
			IF (@DEBUG = 1)
				SELECT 'update FamilytoPhoneNumber set PhoneNumberID = @PhoneNumberID where FamilyID = @FamilyID and NumberPriority = @NumberPriority'
					, @PhoneNumberID, @FamilyID, @NumberPriority
			update FamilytoPhoneNumber set PhoneNumberID = @PhoneNumberID where FamilyID = @FamilyID and NumberPriority = @NumberPriority
		END
		ELSE
			INSERT into FamilytoPhoneNumber( FamilyID, PhoneNumberID, NumberPriority)
				 Values ( @FamilyID, @PhoneNumberID, @NumberPriority )
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
