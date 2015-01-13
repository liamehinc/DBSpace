USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewEthnicityID int

EXEC	@return_value = [dbo].[usp_InsertEthnicity]
		@Ethnicity = N'Dutch',
		@NewEthnicityID = @NewEthnicityID OUTPUT

SELECT	@NewEthnicityID as N'@NewEthnicityID'

SELECT	'Return Value' = @return_value

GO

SELECT * From Ethnicity
