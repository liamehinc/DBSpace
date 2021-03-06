use LCCHPTestImport
GO

-- alter table Family add HistoricFamilyID smallint
insert into Family (HistoricFamilyID,LastName,NumberofSmokers,PrimaryLanguageID,Pets,Petsinandout,ReviewStatusID)
select FamilyID,P1LastName
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
from TESTAccessImport..Families as FAM
LEFT OUTER join [Language] on [FAM].[PrimLanguageCode] = [Language].[HistoricPrimaryLanguageCode]
LEFT OUTER JOIN [ReviewStatus] AS [RS] on [FAM].[ReviewStatusCode] = [RS].[HistoricReviewStatusID]
where P1LastName is not null


  --- Family NOTES: HobbyNotes,OccupationNotes,OtherNotes
	  insert into FamilyNotes (Notes,FamilyID)
	  Select HobbyNotes,F.FamilyID from TESTAccessImport..Families AS TAIF
	  JOIN Family AS F on TAIF.FamilyID = F.HistoricFamilyID
	  where TAIF.HobbyNotes is not null

	  insert into FamilyNotes (Notes,FamilyID)
	  Select OccupNotes,F.FamilyID from TESTAccessImport..Families AS TAIF
	  JOIN Family AS F on TAIF.FamilyID = F.HistoricFamilyID
	  where TAIF.OccupNotes is not null

	  insert into FamilyNotes (Notes,FamilyID)
	  Select OtherNotes,F.FamilyID from TESTAccessImport..Families AS TAIF
	  JOIN Family AS F on TAIF.FamilyID = F.HistoricFamilyID
	  where TAIF.OtherNotes is not null

-- select * from FamilyNotes


-- Import modified/update date
		update F set ModifiedDate = cast(TAIC.UpdateDate as date)
		-- Select F.FamilyID,F.FamilyID,F.HistoricFamilyID,cast(UpdateDate as date)
		FROM Family AS F
		JOIN TestAccessImport..Families AS TAIC ON F.HistoricFamilyID = TAIC.FamilyID


select count(*) from family
select count(*) from TESTAccessImport..Families where P1LastName is not null