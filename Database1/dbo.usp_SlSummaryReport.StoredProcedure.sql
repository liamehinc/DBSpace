USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlSummaryReport]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		Liam Thier
-- Create date: 20150605
-- Description:	procedure returns the number of 
--				blood tests conducted within 
--				the specified date range.
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlSummaryReport] 
	-- Add the parameters for the stored procedure here
	@StartDate date = NULL,
	@EndDate date = NULL,
	@MinLeadValue numeric(4,1) = NULL,
	@MaxLeadValue Numeric(4,1) = NULL,
	@MinAge int = 18,
	@DEBUG bit = 0
	
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr NVARCHAR(4000), @Recompile BIT = 1, @ErrorLogID int, @ParmDefinition nvarchar(500)
	, @ClientCount int, @NewClientCount int, @BLLCount int, @EBLLCount int, @PregnantWomenCount int
	, @NursingMotherCount int, @NursingInfantCount int, @AdultCount int, @BloodTestCount int, @HomeSoilCount int
	, @BllMinLeadValue decimal(4,1), @BllMaxLeadValue decimal(4,1)
	, @EBLLMinLeadValue decimal(4,1), @EBLLMaxLeadValue decimal(4,1);
	
	BEGIN TRY

		IF (@StartDate IS NULL)
			SET @StartDate = '00010101';
		
		IF (@EndDate IS NULL)
			SET @EndDate = GETDATE();

		SET @EndDate = DateAdd(dd,1,@EndDate);
		
		IF (@StartDate >= @EndDate)
		BEGIN
			DECLARE @ErrorString VARCHAR(3000);
			SET @ErrorString ='EndDate must be after StartDate: StartDate: ' + cast(@StartDate as varchar) + ' EndDate: ' + cast(@EndDate as varchar);
			RAISERROR (@ErrorString, 11, -1);
			RETURN;
		END

		-- clients
		SELECT @spexecutesqlStr = 'Select  @Clients = count(total.PersonID) from (
			SELECT  PersonID from bloodTestResults WHERE 1=1 AND SampleDate >= @StartDate AND SampleDate < @EndDate
			UNION
			SELECT  PersonID from Questionnaire WHERE 1=1 AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
			) total 
			JOIN Person on Person.PersonID = total.PersonID
			where Person.isClient = 1'
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @Clients int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @Clients = @ClientCount OUTPUT;

		-- NewClients
		SELECT @spexecutesqlStr = 'Select  @NewClients = count(PersonID) from Person WHERE PersonID in (
				SELECT  PersonID from bloodTestResults WHERE 1=1 AND SampleDate >= @StartDate AND SampleDate < @EndDate
				UNION
				SELECT  PersonID from Questionnaire WHERE 1=1 AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
				)
				AND CreatedDate >= @StartDate AND CreatedDate < @EndDate';

		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @NewClients int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @NewClients = @NewClientCount OUTPUT;

		-- Total BloodLead Tests
		SELECT @spexecutesqlStr = 'SELECT @BloodTestCount = count([BloodTestResultsID]) from [BloodTestResults] 
			where SampleDate >= @StartDate AND SampleDate < @EndDate';
			
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @BloodTestCount int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @BloodTestCount = @BloodTestCount OUTPUT;

		-- BLL 5 ug/dl - 9.9 ug/dl
		SET @BLLMinLeadValue = 5.0;
		SET @BLLMaxLeadValue = 10.0;

		SELECT @spexecutesqlStr = 'SELECT @BLLCount = count([BloodTestResultsID]) from [BloodTestResults] 
			where Leadvalue >= @MinLeadValue AND LeadValue < @MaxLeadValue AND SampleDate >= @StartDate
			AND SampleDate < @EndDate';
			
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate, [MinLeadValue] = @MinLeadValue, [MaxLeadValue] = @MaxLeadValue;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @MinLeadValue numeric(4,1), @MaxLeadValue numeric(4,1), @BLLCount int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @MinLeadValue = @BLLMinLeadValue
		, @MaxLeadValue = @BLLMaxLeadValue
		, @BLLCount = @BLLCount OUTPUT;

		-- EBLL 10 ug/dl and above
		SET @EBLLMinLeadValue = 10;
		SET @EBLLMaxLeadValue = NULL;

		SELECT @spexecutesqlStr = 'SELECT @EBLLCount = count([BloodTestResultsID]) from [BloodTestResults] 
			where SampleDate >= @StartDate AND SampleDate < @EndDate AND Leadvalue >= @MinLeadValue';
		
		IF (@EBLLMaxLeadValue IS NOT NULL)
			SELECT @spexecutesqlStr = @spexecutesqlStr + ' AND LeadValue < @MaxLeadValue';

		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate, [MinLeadValue] = @MinLeadValue, [MaxLeadValue] = @MaxLeadValue;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @MinLeadValue numeric(4,1), @MaxLeadValue numeric(4,1), @EBLLCount int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @MinLeadValue = @EBLLMinLeadValue
		, @MaxLeadValue = @EBLLMaxLeadValue
		, @EBLLCount = @EBLLCount OUTPUT;

		-- Pregnant women
		select @spexecutesqlStr ='Select @PregnantWomen = COUNT(PersonID) from (
								Select BTR.PersonID,Q.Pregnant from BloodTestResults AS BTR
								LEFT OUTER JOIN  [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
																select top 1 [QuestionnaireID] from [Questionnaire] 
																where [Questionnaire].[PersonID] = [BTR].[PersonID]
																AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
																order by Pregnant desc
																)
								where SampleDate >= @StartDate and SampleDate < @EndDate AND Q.Pregnant = 1

								UNION 
								SELECT PersonID,Pregnant from Questionnaire where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate
								AND Pregnant = 1
							) ClientsinReportingPeriod
							where ClientsinReportingPeriod.Pregnant = 1';
	
		IF @Recompile = 1
			SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'StartDate' = @StartDate, 'ENDDate' = @EndDate, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate datetime, @EndDate datetime, @PregnantWomen int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @PregnantWomen = @PregnantWomenCount OUTPUT;

		-- Nursing Mothers
		SELECT @spexecutesqlStr = 'Select @NursingMothers = COUNT(PersonID) from (
								Select BTR.PersonID,Q.NursingMother from BloodTestResults AS BTR
								LEFT OUTER JOIN  [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
																select top 1 [QuestionnaireID] from [Questionnaire] 
																where [Questionnaire].[PersonID] = [BTR].[PersonID]
																AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
																order by NursingMother desc
																)
								where SampleDate >= @StartDate and SampleDate < @EndDate AND Q.NursingMother = 1

								UNION 
								SELECT PersonID,NursingMother from Questionnaire where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate
								AND NursingMother = 1
							) ClientsinReportingPeriod
							where ClientsinReportingPeriod.NursingMother = 1';

		IF ((DateDiff(YYYY,@StartDate,@EndDate) > 5))
			SET @Recompile = 0;
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @NursingMothers int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @NursingMothers = @NursingMotherCount OUTPUT;

		-- Nursing Infants
		SELECT @spexecutesqlStr = 'Select @NursingInfants = COUNT(PersonID) from (
									Select BTR.PersonID,Q.NursingInfant from BloodTestResults AS BTR
									LEFT OUTER JOIN  [Questionnaire] AS [Q] on [Q].[QuestionnaireID] = (
																	select TOP 1 [QuestionnaireID] from [Questionnaire] 
																	where [Questionnaire].[PersonID] = [BTR].[PersonID]
																	AND QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
																	order by NursingInfant desc
																	)
									where SampleDate >= @StartDate and SampleDate < @EndDate AND Q.NursingInfant = 1

									UNION 
									SELECT PersonID,NursingInfant from Questionnaire where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate
									AND NursingInfant = 1
								) ClientsinReportingPeriod
								where ClientsinReportingPeriod.NursingInfant = 1';

		IF ((DateDiff(YYYY,@StartDate,@EndDate) > 5))
			SET @Recompile = 0;
	
		IF (@Recompile = 1)
		    SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1)
			SELECT @spexecutesqlStr, [StartDate] = @StartDate, [EndDate] = @EndDate;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate date, @EndDate date, @NursingInfants int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @NursingInfants = @NursingInfantCount OUTPUT;

		-- Adults
		-- Create temporary table
		CREATE Table #TempPotentialAdults
		( PersonID int 
			, TestID int
			, AgeAtVisit tinyint
			, MostRecentVisit date
			, Birthdate date
			, Visits tinyint
		)

		-- insert values from bloodtest results
			insert Into #TempPotentialAdults (PersonID, MostRecentVisit, TestID)
				select PersonID,MostRecentVisit = SampleDate, TestID = BloodTestResultsID 
				from BloodtestResults 
					where SampleDate >= @StartDate AND SampleDate < @EndDate ;

		-- insert values from questionnaire	
			insert Into #TempPotentialAdults (PersonID, MostRecentVisit, TestID)
				Select PersonID,MostRecentVisit = QuestionnaireDate, TestID = QuestionnaireID 
				from Questionnaire 
					where QuestionnaireDate >= @StartDate AND QuestionnaireDate < @EndDate
					and (ISNULL(Questionnaire.NursingMother,0) = 0 OR  ISNULL(Questionnaire.Pregnant,0) = 0 );

		-- populate birthdate only if the difference from most recent visit to birthdate is at least minAge
			update #TempPotentialAdults set BirthDate = Person.Birthdate,
				 AgeAtVisit = [dbo].[udf_CalculateAge]([Person].[BirthDate],MostRecentVisit)
			FROM #TempPotentialAdults
			JOIN Person on Person.PersonID = #TempPotentialAdults.PersonID
			where Datediff(yy,Person.BirthDate,MostRecentVisit) >= @MinAge;

		Select @AdultCount = count(distinct PersonID) from #TempPotentialAdults
		where AgeAtVisit >= @MinAge;

		drop table #TempPotentialAdults;

		-- Home visits and soil testing
		select @spexecutesqlStr ='select @HomeSoilCount = count(PersonID) from (
						SELECT PersonID
						from BloodTestResults where SampleDate >= @StartDate and SampleDate < @EndDate
								AND ClientStatusID in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
														where TargetType = ''Person''
														AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')
													  )
						UNION
						-- people with questionnaire but no blood test during reporting period
						Select Q.PersonID
						from Questionnaire AS Q
								LEFT OUTER JOIN  [BloodTestResults] AS [BTR] on [BTR].[BloodTestResultsID] = (
																select top 1 [BloodTestResultsID] from [BloodTestResults] 
																where [BloodTestResults].[PersonID] = [Q].[PersonID]
																-- AND SampleDate >= @StartDate AND SampleDate < @EndDate
																AND BTR.ClientStatusID
																	in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
																			where TargetType = ''Person''
																			AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')			  
																		)
																order by SampleDate desc
																)
								where QuestionnaireDate >= @StartDate and QuestionnaireDate < @EndDate 
								AND BTR.ClientStatusID
									in (	SELECT [TS].[StatusID] from [TargetStatus] AS [TS]
											where TargetType = ''Person''
											AND StatusName in (''Home visit'', ''Home Visit and Soil Sample'', ''Soil Sample'')			  
										)
						) HomeVisitSoilSamples';
	
		IF @Recompile = 1
			SELECT @spexecutesqlStr = @spexecutesqlStr + N' OPTION(RECOMPILE)';

		IF (@DEBUG = 1) 
			SELECT @spexecutesqlStr, 'StartDate' = @StartDate, 'ENDDate' = @EndDate, 'DEBUG' = @Debug;

		EXEC [sp_executesql] @spexecutesqlStr
		, N'@StartDate datetime, @EndDate datetime, @HomeSoilCount int OUTPUT'
		, @StartDate = @StartDate
		, @EndDate = @EndDate
		, @HomeSoilCount = @HomeSoilCount OUTPUT;
		-- total tests

		select 'ClientCount' = @ClientCount, 'NewClientCount' = @NewClientCount, 'BloodTestCount' = @BloodTestCount
				, 'BLL5to10ugPerdl' = @BLLCount, 'EBLLCount' = @EBLLCount, 'PregnantWomen' = @PregnantWomenCount
				, 'NursingMotherCount' = @NursingMotherCount, 'NursingInfantCount' = @NursingInfantCount
				, 'AdultCount' = @AdultCount, 'HomeSoilCount' = @HomeSoilCount;

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
