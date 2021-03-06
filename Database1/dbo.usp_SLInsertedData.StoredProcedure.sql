USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SLInsertedData]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		William Thier
-- Create date: 20130509
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLInsertedData] 
	-- Add the parameters for the stored procedure here
	@Last_Name varchar(50) = NULL

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000),
			@Recompile BIT = 1, @ErrorLogID int;

    -- Insert statements for procedure here
	SELECT @spexecutesqlStr = N'SELECT [P].[PersonID] 
								, ''FamilyLastName'' = [F].[Lastname]
								, [P].[LastName]
								, [P].[MiddleName]
								, [P].[FirstName]
								, [P].[BirthDate]
								, [P].[Gender]
								, ''StreetAddress'' = cast([Prop].[StreetNumber] as varchar)
									+ '' ''+ cast([Prop].[Street] as varchar) + '' '' 
									+ cast([Prop].[StreetSuffix] as varchar)
								, [Prop].[ApartmentNumber]
								, [Prop].[City]
								, [Prop].[State]
								, [Prop].[Zipcode]
								, ''PrimaryPhoneNumber'' = [Ph].[PhoneNumber]
								, [L].[LanguageName]
								, [F].[NumberofSmokers]
								, [F].[Pets]
								, [F].[inandout]
								, [F].[Notes]
								, [P].[Moved]
								, [P].[ForeignTravel]
								, [P].[OutofSite]
								, [H].[HobbyName]
								, [P].[Notes]
								, [P].[isSmoker]
								, [P].[RetestDate]
								, [Q].[QuestionnaireDate]
								, [Q].[isExposedtoPeelingPaint]
								, ''PaintAge'' = [Q].[RemodeledPropertyAge]
								, [Q].[VisitRemodeledProperty]
								, ''RemodelPropertyAge'' = [Q].[RemodeledPropertyAge]
								, [Q].[isTakingVitamins]
								, [Q].[FrequentHandWashing]
								, [Q].[isUsingBottle]
								, [Q].[isNursing]
								, [Q].[isUsingPacifier]
								, [Q].[BitesNails]
								, [Q].[EatOutside]
								, [Q].[NonFoodinMouth]
								, [Q].[NonFoodEating]
								, [Q].[Suckling]
								, [Q].[Daycare]
								, [Q].[Source]
								, [Q].[Notes]
								, [BTR].[SampleDate]
								, [BTR].[LabSubmissionDate]
								, [Lab].[LabName]
								, ''What is status code?''
								, [BTR].[HemoglobinValue]
						  FROM [LeadTrackingTesting-Liam].[dbo].[Person] AS [P]
						  LEFT OUTER JOIN [PersontoFamily] as [P2F] on [P].[PersonID] = [P2F].[PersonID]
						  LEFT OUTER JOIN [Family] AS [F] on [F].[FamilyID] = [P2F].[FamilyID]
						  LEFT OUTER JOIN [PersontoProperty] as [P2P] on [P].PersonID = [P2P].[PersonID]
						  LEFT OUTER JOIN [Questionnaire] as [Q] on [P].[PersonID] = [Q].[PersonID]
						  LEFT OUTER JOIN [BloodTestResults] as [BTR] on [P].[PersonID] = [BTR].[PersonID]
						  LEFT OUTER JOIN [PersontoLanguage] as [P2L] on [P2L].[PersonID] = [P].[PersonID]
						  LEFT OUTER JOIN [Language] as [L] on [L].LanguageID = [P2L].[LanguageID]
						  LEFT OUTER JOIN [Property] as [Prop] on [Prop].[PropertyID] = [F].[PrimaryPropertyID]
						  LEFT OUTER JOIN [PersontoPhoneNumber] as [P2Ph] on [P].[PersonID] = [P2Ph].[PersonID]
						  LEFT OUTER JOIN [PhoneNumber] as [Ph] on [Ph].[PhoneNumberID] = [P2Ph].[PhoneNumberID]
						  LEFT OUTER JOIN [PhoneNumberType] as [PhT] on [Ph].[PhoneNumberTypeID] = [PhT].[PhoneNumberTypeID]
						  LEFT OUTER JOIN [PersontoHobby] as [P2H] on [P].PersonID = [P2H].[HobbyID]
						  LEFT OUTER JOIN [Hobby] as [H] on [H].[HobbyID] = [P2H].[HobbyID]
						  LEFT OUTER JOIN [Lab] on [BTR].[LabID] = [Lab].[LabID]
							WHERE 1 = 1'

	if @Last_Name IS NOT NULL
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' AND [p].[LastName] = @LastName ORDER BY [P].[PersonID] desc'
	ELSE
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' ORDER BY [P].[PersonID] desc'

	IF @Last_name is NULL
		SET @Recompile = 0;

	IF @Recompile = 1
		SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

	BEGIN TRY
		EXEC [sp_executesql] @spexecutesqlStr
		, N'@Lastname varchar(50)'
		, @LastName = @Last_name;  
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
