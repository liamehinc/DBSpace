USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int,
		@NewCleanupStatusID int

EXEC	@return_value = [dbo].[usp_InsertCleanupStatus]
		@CleanupStatusDescription = N'Cleaned and ready for the next step',
		@CleanupStatusName = N'Cleaned',
		@NewCleanupStatusID = @NewCleanupStatusID OUTPUT

SELECT	@NewCleanupStatusID as N'@NewCleanupStatusID'

SELECT	'Return Value' = @return_value

GO

Select * from CleanupStatus
