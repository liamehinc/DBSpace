USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertPersontoPhoneNumber]
		@PersonID = 2688,
		@PhoneNumberID = 18,
		@NumberPriority = 1

SELECT	'Return Value' = @return_value

GO

select * from PersontoPhoneNumber AS P2P
join Person on Person.PersonID = P2P.PersonID
join PhoneNumber as PN on PN.PhoneNumberID = P2P.PhoneNumberID
