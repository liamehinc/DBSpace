USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SLMostRecentBloodTestResults]
		@Person_ID = NULL,
		@Min_Lead_Value = NULL,
		@DEBUG = 1

SELECT	'Return Value' = @return_value

GO
