use LCCHPPublic
GO
SET NOCOUNT ON;

select 'inserting rows into family table';
-- alter table Family add HistoricFamilyID smallint
insert into Family (HistoricFamilyID,LastName,NumberofSmokers,PrimaryLanguageID,Pets,Petsinandout,ReviewStatusID)
select FamilyID,LastName = case 
								WHEN P1Lastname is null THEN 'UNKNOWN'
								ELSE P1LastName
							END
        , [FAM].[NumSmokers]
		, [Language].[LanguageID]
		, PETS = CASE InOutPets 
			 when 0 then 0
			 else 1
		 END,
        PETSINANCOUT = CASE InOutPets 
			 when 0 then 0
			 else 1
		 END,
		 [RS].[ReviewStatusID]
from LCCHPImport..Families as FAM
LEFT OUTER join [Language] on [FAM].[PrimLanguageCode] = [Language].[HistoricPrimaryLanguageCode]
LEFT OUTER JOIN [ReviewStatus] AS [RS] on [FAM].[ReviewStatusCode] = [RS].[HistoricReviewStatusID]

select 'inserting family notes from hobby notes';
  --- Family NOTES: HobbyNotes,OccupationNotes,OtherNotes
	  insert into FamilyNotes (Notes,FamilyID)
	  Select HobbyNotes,F.FamilyID from LCCHPImport..Families AS TAIF
	  JOIN Family AS F on TAIF.FamilyID = F.HistoricFamilyID
	  where TAIF.HobbyNotes is not null;

select 'inserting family notes from occupNotes';
	  insert into FamilyNotes (Notes,FamilyID)
	  Select OccupNotes,F.FamilyID from LCCHPImport..Families AS TAIF
	  JOIN Family AS F on TAIF.FamilyID = F.HistoricFamilyID
	  where TAIF.OccupNotes is not null;

select 'inserting family notes from othernotes';
	  insert into FamilyNotes (Notes,FamilyID)
	  Select OtherNotes,F.FamilyID from LCCHPImport..Families AS TAIF
	  JOIN Family AS F on TAIF.FamilyID = F.HistoricFamilyID
	  where TAIF.OtherNotes is not null;

select 'updating modified date';
-- Import modified/update date
		update F set ModifiedDate = cast(TAIC.UpdateDate as date)
		-- Select F.FamilyID,F.FamilyID,F.HistoricFamilyID,cast(UpdateDate as date)
		FROM Family AS F
		JOIN LCCHPImport..Families AS TAIC ON F.HistoricFamilyID = TAIC.FamilyID;

select 'comparing counts of family rows to families rows';
select count(*) from family;
select count(*) from LCCHPImport..Families;


select 'listing rows in Families but not in Family';
select FamilyID,P1LastName from LCCHPImport..Families where FamilyID not in (Select HistoricFamilyID from Family)