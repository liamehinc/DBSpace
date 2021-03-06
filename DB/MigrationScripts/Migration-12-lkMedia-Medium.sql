USE LCCHPPublic
GO
SET NOCOUNT ON;
  insert into Medium (MediumName,HistoricMediumCode)
   select Medium,MediumCode from LCCHPImport..lkMedia
   
   update Medium set TriggerLevel = 2000, 
   TriggerLevelUnitsID = (select UnitsID from Units where Units = 'mg/kg')
   where Medium.MediumName = 'Dust'

	update Medium set TriggerLevel = 6, 
   TriggerLevelUnitsID = (select UnitsID from Units where Units = 'mg/cm2')
   where reverse(Medium.MediumName) like 'tniap%'

   update Medium set TriggerLevel = 15, 
   TriggerLevelUnitsID= (select UnitsID from Units where Units = 'ug/L')
   where Medium.MediumName = 'Water'

   update Medium set TriggerLevel = 3500,
   MediumName = 'residential soil',
   TriggerLevelUnitsID = (Select UnitsID from Units where Units = 'mg/kg')
   where reverse(Medium.MediumName) like 'lios%'


   insert into medium (MediumName,TriggerLevel,TriggerLevelUnitsID)
   values ('commercial soil',3500,(Select UnitsID from Units where Units = 'mg/kg'))

   -- need to break out commercial/residential soil from Medium table
  select * from Medium