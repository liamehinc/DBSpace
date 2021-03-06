USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertMediumSampleResults]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new MediumSampleResults records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertMediumSampleResults]   -- usp_InsertMediumSampleResults 
	-- Add the parameters for the stored procedure here
	@MediumID int = NULL,
	@MediumSampleValue numeric(9,4) = NULL,
	@UnitsID smallint = NULL,
	@SampleLevelCategoryID tinyint = NULL,
	@MediumSampleDate date = getdate,
	@LabID int = NULL,
	@LabSubmissionDate date = getdate,
	@Notes varchar(3000) = NULL,
	@IsAboveTriggerLevel bit = NULL,
	@NewMediumSampleResultsID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int, @TriggerlevelUnitsID smallint, @TriggerLevel numeric(9,4), @NotesID int, @Notes_results int;
    -- Insert statements for procedure here
	
	-- See if Value is above Trigger Level - initially assume units are identical
	-- Determine Trigger level units and Trigger Level
	Select @TriggerLevel = M.TriggerLevel , @TriggerLevelUnitsID = M.TriggerLevelUnitsID FROM MediumSampleresults AS MSR 
		JOIN Medium as M on M.MediumID = MSR.MediumID 
		JOIN Units AS TLU on M.TriggerLevelUnitsID = TLU.UnitsID;

	-- IF the units are the same, 
	IF (@UnitsID = @TriggerlevelUnitsID )
	BEGIN
		print 'units are identical comparing values'
		IF ( @MediumSampleValue < @TriggerLevel ) 
			SET @IsAboveTriggerLevel = 0;
		ELSE 
			SET @IsAboveTriggerLevel = 1;
	END
	ELSE  
		print 'consider converting values to the same units'


	BEGIN TRY
		 INSERT into MediumSampleResults ( MediumID, MediumSampleValue, UnitsID, SampleLevelCategoryID, MediumSampleDate, LabID,
		                                   LabSubmissionDate, IsAboveTriggerLevel )
					 Values ( @MediumID, @MediumSampleValue, @UnitsID, @SampleLevelCategoryID, @MediumSampleDate, @LabID,
		                      @LabSubmissionDate, @IsAboveTriggerLevel );
		SELECT @NewMediumSampleResultsID = SCOPE_IDENTITY();

		IF (@Notes IS NOT NULL)
			EXEC	@Notes_results = [usp_InsertMediumSampleResultsNotes]
								@MediumSampleResults_ID = @NewMediumSampleResultsID,
								@Notes = @Notes,
								@InsertedNotesID = @NotesID OUTPUT
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
