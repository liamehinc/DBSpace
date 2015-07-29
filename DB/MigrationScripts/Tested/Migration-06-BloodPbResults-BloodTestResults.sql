 USE LCCHPPublic
 GO
 SET NOCOUNT ON;

select 'Adding temporary historicLabName column'
 alter table BloodTestResults add historicLabName varchar(30) NULL
 GO

select 'Copying bloodtestresults'
  insert into BloodTestResults
           (SampleDate,LeadValue,HemoglobinValue,HistoricLabResultsID,SampleTypeID,BloodTestCosts
		   ,isBaseline,HistoricBloodTestResultsID,ExcludeResult,LabSubmissionDate,HistoricLabName
		   )
  select cast(BPR.SampleDate as Date),BPR.LeadValue,HemoglobinValue = cast(BPR.Hematocrit / 3 as numeric(4,1)),
          LabID,
          ST = case BPR.SampleType
		               When 'C' Then (select SampleTypeID from SampleType where SampleTypeName = 'Capillary')
					   When 'V' Then (select SampleTypeID from SampleType where SampleTypeName = 'Venous')
			   END
	     ,BPR.Cost,BPR.Baseline, BPR.AnalysisID,BPR.ExcludeResult,LabSubmissionDate = cast(coalesce(BPR.LabDate,SampleDate) as date)
		 , LabName
		 from LCCHPImport..BloodPbResults BPR
		 -- LEFT OUTER join Lab on BPR.LabName = Lab.HistoricLabID
		 -- LEFT OUTER join Action on BPR.ChildID = Action.ActionCode
		 order by BPR.AnalysisID

	select 'cleaning up historic lab names'
		-- Tamarac lab
 		update BloodTestResults set LabID = (select labID from Lab where LabName = 'Tamarac')
		 where HistoricLabname in ('TAMA','TAMAR','TAMARAC')
		-- LeadCare II Analyzer
 		update BloodTestResults set LabID = (select labID from Lab where LabName = 'LeadCare II')
		 where HistoricLabname in ('LEADARE2','LEADCAE2','LEADCARA2','LEADCARE','LEADCARE2')
		 -- RMFP lab
		 update BloodTestResults set LabID = (select labID from Lab where LabName = 'RMFP')
		 where HistoricLabname in ('RMFP','RMFP LEAD','RMFP LEADVILLE','RMFPLEADVILL','RMFPLEADVILLE')
		 -- Quest Diagnostic lab
		 update BloodTestResults set LabID = (select labID from Lab where LabName = 'Quest Diagnostic')
		 where HistoricLabname in ('QUEST','Quest Diagnostic','LAB CORP')
		 -- Mayo Lab lab
		 update BloodTestResults set LabID = (select labID from Lab where LabName = 'Mayo Lab')
		 where HistoricLabname in ('Mayo Lab')
		 -- Lead Tech lab
		 update BloodTestResults set LabID = (select labID from Lab where LabName = 'Lead Tech')
		 where HistoricLabname in ('Lead Tech')
		 -- EVMC lab
		 update BloodTestResults set LabID = (select labID from Lab where LabName = 'EVMC')
		 where HistoricLabname in ('EVMC')
		-- DONE AT CLINIC
		 update BloodTestResults set LabID = (select labID from Lab where LabName = 'DONE AT CLINIC')
		 where HistoricLabname in ('DONE AT CLINIC')

		select 'updating modifieddate'
		update BTR
		SET BTR.ModifiedDate = cast(BPR.UpdateDate as datetime2)
		from BloodTestResults AS BTR
		JOIN LCCHPImport..BloodPbResults AS BPR ON BTR.HistoricBloodTestResultsID = BPR.AnalysisID

		select 'Deleting temporary historicLabName column'
		alter table BloodTestResults drop column HistoricLabName

	select 'Comparing BloodTestResults row count to BloodPbResults count'
		select count(BloodTestResultsID) from BloodTestResults
		Select count(analysisID) from LCCHPImport..BloodPbResults BPR

		select 'identify records in Access blood test results that are not in SQL Db'
		select analysisID from LCCHPImport..BloodPbResults where analysisID not in (select HistoricBloodTestResultsID from BloodTestResults)