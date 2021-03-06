/****** Script for SelectTopNRows command from SSMS  ******/
   use LCCHPPublic
   GO
   SET NOCOUNT ON;
 insert into Lab (LabName)
	Select distinct NewLabName = case  LabName
									WHEN 'Tama' THEN 'Tamarac'
									WHEN 'TAMAR' THEN 'Tamarac'
									WHEN 'RMFP LEAD' THEN 'RMFP'
									WHEN 'RMFP LEADVILLE' THEN 'RMFP'
									WHEN 'RMFPLEADVILL' THEN 'RMFP'
									WHEN 'RMFPLEADVILLE' THEN 'RMFP'
									WHEN 'QUEST' THEN 'Quest Diagnostic'
									WHEN 'Leadare2' THEN 'LeadCare II'
									WHEN 'LeadCae2' THEN 'LeadCare II'
									WHEN 'LeadCara2' THEN 'LeadCare II'
									WHEN 'LEADCARE' THEN 'LeadCare II'
									WHEN 'LeadCare2' THEN 'LeadCare II'
									ELSE LabName
								END
							from LCCHPImport..BloodPbResults
							where LabName is not null;

select count(*) from Lab;

select 'listing labs';
select LabID, LabName from Lab order by LabName;


