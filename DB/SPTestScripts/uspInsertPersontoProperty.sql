USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int, @PersontoPropertyID int;

EXEC	@return_value = [dbo].[usp_InsertPersontoProperty]
		@PersonID = 2895,
		@PropertyID = 11101,
		@StartDate = '20141103',
		@EndDate = NULL,
		@isPrimaryResidence = 1,
		@NewPersontoPropertyID = @PersontoPropertyID OUTPUT

SELECT	'Return Value' = @return_value, 'PersontoPropertyID' = @PersontoPropertyID 

GO

select * from persontoProperty order by PersontoPropertyID desc



/*
select P2F.PersonID, P2F.FamilyID, P.Firstname, P.LastName, F.LastName from persontoFamily as P2F
JOIN Person AS P on P2F.PersonID = P.PersonID
JOIN Family as F on P2F.FamilyID = F.FamilyID
where P.PersonID in (select PersonID from persontoFamily group by PersonID having count(FamilyID) > 1)
order by PersonID asc


select * from person where personID = 346

select PersonID,count(familyID) from PersontoFamily 
group by PersonID
having count (FamilyID) > 1
*/