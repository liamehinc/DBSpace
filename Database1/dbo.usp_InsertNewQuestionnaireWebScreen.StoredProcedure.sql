USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertNewQuestionnaireWebScreen]    Script Date: 6/21/2015 12:54:24 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20141208
-- Description:	stored procedure to insert data 
--              from the Lead Research Subject Questionnaire web page
-- =============================================
CREATE PROCEDURE [dbo].[usp_InsertNewQuestionnaireWebScreen]
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@QuestionnaireDate date = NULL,
	@PaintPeeling bit = NULL,
	@PaintDate date = NULL, 
	@VisitRemodel bit = NULL,
	@RemodelDate date = NULL, 
	@Vitamins bit = NULL,
	@HandWash bit = NULL,
	@Bottle bit = NULL,
	@NursingMother bit = NULL,
	@NursingInfant bit = NULL,
	@Pregnant bit = NULL,
	@Pacifier bit = NULL,
	@BitesNails bit = NULL,
	@EatsOutdoors bit = NULL, 
	@NonFoodInMouth bit = NULL,
	@EatsNonFood bit = NULL,
	@SucksThumb bit = NULL,
	@Mouthing bit = NULL,
	@DaycareID int = NULL,
	@VisitsOldHomes bit = NULL,
	@DayCareNotes varchar(3000) = NULL,
	@Source int = NULL,
	@QuestionnaireNotes varchar(3000) = NULL,
	@Hobby1ID smallint = NULL,
	@Hobby2ID smallint = NULL,
	@Hobby3ID smallint = NULL,
	@HobbyNotes varchar(3000) = NULL,
	@DEBUG bit = 0,
	@Questionnaire_return_value int OUTPUT
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	IF (@PaintPeeling = '') SET @PaintPeeling = NULL;

	DECLARE @ErrorLogID int, @New_Notes varchar(3000), @PersontoHobby1_return_value int
		, @PersontoHobby2_return_value int, @PersontoHobby3_return_value int, @HobbyNotesID int; 

	BEGIN TRY
		-- set default date if necessary 
		IF (@QuestionnaireDate is null) 
		BEGIN
			print 'Need to specify QuestionnaireDate, setting to today by defualt';
			set @QuestionnaireDate = GetDate();
		END

		IF (@Person_ID IS NULL)
		BEGIN
			RAISERROR ('Client name must be supplied', 11, -1);
			RETURN;
		END;

		-- Client ID must already exist in the database
		IF ( (select PersonID from person where personID = @Person_ID ) is NULL)
		BEGIN
			RAISERROR ('Specified ClientID does not exist', 11, -1);
			RETURN;
		END

		SET @New_Notes = concat(@QuestionnaireNotes,' ',@DayCareNotes);
	
		EXEC	[dbo].[usp_InsertQuestionnaire]
				@PersonID = @Person_ID,
				@QuestionnaireDate = @QuestionnaireDate,
				@QuestionnaireDataSourceID = @Source,
				@VisitRemodeledProperty = @VisitRemodel,
				@PaintDate = @PaintDate,
				@RemodelPropertyDate = @RemodelDate,
				@isExposedtoPeelingPaint = @PaintPeeling,
				@isTakingVitamins = @Vitamins,
				@NursingMother = @NursingMother,
				@NursingInfant = @NursingInfant,
				@Pregnant = @Pregnant,
				@isUsingPacifier = @Pacifier,
				@isUsingBottle = @Bottle,
				@BitesNails = @BitesNails,
				@NonFoodEating = @EatsNonFood,
				@NonFoodinMouth = @NonFoodInMouth,
				@EatOutside = @EatsOutdoors,
				@Suckling = @SucksThumb,
				@Mouthing = @Mouthing,
				@FrequentHandWashing = @HandWash,
				@DaycareID = @DaycareID,
				@VisitsOldHomes = @VisitsOldHomes,
				@New_Notes = @New_Notes,
				@DEBUG = @DEBUG,
				@QuestionnaireID = @Questionnaire_return_value OUTPUT 

		-- Set NursingMother, NursingInfant, and Pregnant attributes of the person according to the questionnaire
		-- anyone that completes a questionnaire is a client
		EXEC [dbo].[usp_upPerson] @Person_ID = @Person_ID, @New_NursingMother = @NursingMother, @New_NursingInfant = @NursingInfant
								, @New_Pregnant = @Pregnant, @New_isClient = 1, @DEBUG = @DEBUG

		-- associate person to Hobby
		if (@Hobby1ID is not NULL)
			EXEC	@PersontoHobby1_return_value = usp_InsertPersontoHobby
					@HobbyID = @Hobby1ID, @PersonID = @Person_ID;

		if (@Hobby2ID is not NULL)
			EXEC	@PersontoHobby2_return_value = usp_InsertPersontoHobby
					@HobbyID = @Hobby2ID, @PersonID = @Person_ID;

		if (@Hobby3ID is not NULL)
			EXEC	@PersontoHobby3_return_value = usp_InsertPersontoHobby
					@HobbyID = @Hobby3ID, @PersonID = @Person_ID;

		-- insert hobby notes
		IF (@HobbyNotes IS NOT NULL)
		EXEC	[dbo].[usp_InsertPersonHobbyNotes]
						@Person_ID = @Person_ID,
						@Notes = @HobbyNotes,
						@InsertedNotesID = @HobbyNotesID OUTPUT
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
