USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertDaycarePrimaryContact]
		@DaycareID = 15,
		@PersonID = 786,
		@ContactPriority = 1,
		@PrimaryPhoneNumberID = 25

SELECT	'Return Value' = @return_value

GO

select P.LastName, P.FirstName, DPC.ContactPriority 
	, Ph.CountryCode, PhoneNumber = cast(PH.PhoneNumber as char(11))
 from DaycarePrimaryContact AS DPC
JOIN Person AS P on DPC.PersonID = P.PersonID
JOIN PhoneNumber AS Ph on DPC.PrimaryPhoneNumberID = Ph.PhoneNumberID
LEFT OUTER JOIN PhoneNumberType as PT on PH.PhoneNumberTypeID = PT.PhoneNumberTypeID

-- SELECT PHONE NUMBER
select cast(CountryCode as Char(1)) + ' ' +
	  '(' + REVERSE(SUBSTRING(cast(REVERSE(phonenumber) as varchar),8,3)) +') ' + 
		 REVERSE(SUBSTRING(cast(REVERSE(phonenumber) as varchar),5,3)) + '-' + REVERSE(SUBSTRING(cast(REVERSE(PhoneNumber) as varchar),1,4))
	, PhoneNumber
from PhoneNumber


--Select * from PhoneNumber
--Select * from PersontoPhoneNumber where PersonID = 2786

--EXEC usp_insertPersontoPhoneNumber 786,25,1