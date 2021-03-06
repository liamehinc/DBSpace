USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPersontoHomeRemedy]
		@PersonID = 785,
		@HomeRemedyID = 2

SELECT	'Return Value' = @return_value

GO

Select P.LastName,P.FirstName, H.HomeRemedyName, H.HomeRemedyDescription from Person as P
JOIN PersontoHomeRemedy as P2H on P.PersonID = P2H.PersonID
JOIN HomeRemedy as H on P2H.HomeRemedyID = H.HomeRemedyID