USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@InsertedNotesID int

EXEC	@return_value = [dbo].[usp_InsertPersonNotes]
		@Person_ID = 4242,
		@Notes = NULL,  --N'she is a lovely lass, though a bit slow on the uptake',
		@InsertedNotesID = @InsertedNotesID OUTPUT

SELECT	@InsertedNotesID as N'@InsertedNotesID'

SELECT	'Return Value' = @return_value

GO


