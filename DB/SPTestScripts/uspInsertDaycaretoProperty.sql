USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertDaycaretoProperty]
		@DaycareID = 2,
		@PropertyID = 11307,
		@StartDate = '20110522'

SELECT	'Return Value' = @return_value

GO
