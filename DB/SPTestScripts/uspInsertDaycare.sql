USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@newDayCareID2 int

EXEC	@return_value = [dbo].[usp_InsertDaycare]
		@DaycareName = N'Time 4 Play',
		@DaycareDescription = N'daycare for 2 - 6 year olds',
		@newDayCareID = @newDayCareID2 OUTPUT

SELECT	@newDayCareID2 as N'@newDayCareID'

SELECT	'Return Value' = @return_value

GO
