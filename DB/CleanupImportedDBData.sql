select * from INFORMATION_SCHEMA.Tables where reverse(table_name) like '$%'


select 'drop table ' +Table_name from INFORMATION_SCHEMA.TABLES  where reverse(table_name) like '$%'


drop table ChildFamilyLink$
drop table Children$
drop table CleanupStatus$
drop table ConfidentialNotes$
drop table Control$
drop table EnvirPbResults$
drop table ExportControl$
drop table Families$
drop table FamilyPropertyLink$
drop table lkActionStatus$
drop table lkChildStatus$
drop table lkCleanupStatus$
drop table lkCondition$
drop table lkConstType$
drop table lkContactType$
drop table lkDataReview$
drop table lkDataSource$
drop table lkDescription$
drop table lkEthnicBackground$
drop table lkFlag$
drop table lkFPLinkType$
drop table lkFrequency$
drop table lkHistoricContrib$
drop table lkLocation$
drop table lkMedia$
drop table lkMethod$
drop table lkObject$
drop table lkPrimLanguage$
drop table lkReleaseStatus$
drop table lkSamplePurpose$
drop table lkSampleType$
drop table lkUnits$
drop table OtherPropertyLinks$
drop table Properties$
drop table PropertiesImport$
drop table PropertyContact$
drop table Questionnaires$
drop table SampleEvents$
drop table SampleLocations$
drop table Samples$