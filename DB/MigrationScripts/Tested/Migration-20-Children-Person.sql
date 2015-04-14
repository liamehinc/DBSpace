  use LCCHPTestImport
  GO 

  --- alter table person add ReleaseStatusID tinyint

  insert into person (LastName, FirstName, BirthDate, Gender, Moved
					, HistoricChildID
					-- , EthnicityID
					, ReleaseStatusID
					, OutofSite
					, ForeignTravel
					, ReviewStatusID)
					--, ModifiedDate) 
  select C.LastName,C.FirstName,cast(C.BirthDate as Date),C.Sex,C.Moved,C.ChildID --,E.EthnicityID
	, R.ReleaseStatusID-- ,C.ChildNotes,C.TravelNotes,C.ReleaseNotes
	, C.OutofSite, C.ForeignTravel, RevS.ReviewStatusID
	--, C.UpdateDate
  from  TESTAccessImport..Children AS C
  LEFT OUTER JOIN Ethnicity AS E ON C.EthnicCode = E.HistoricEthnicityCode
  LEFT OUTER JOIN ReleaseStatus AS R on C.ReleaseCode = R.HistoricReleaseStatusID
  LEFT OUTER JOIN ReviewStatus AS RevS on C.ReviewStatusCode = RevS.HistoricReviewStatusID
  WHERE C.CHILDID < 10576
  and C.ChildID not in (select HistoricChildID from Person)
  order by C.ChildID

  -- need to manually add client 10576 from Cornelia's email on  2/12/2015

  select * from person
  select * from TESTAccessImport..Children order by CHildID where ChildID < 10576
  order by BirthDate
  