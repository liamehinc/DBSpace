SET STATISTICS IO ON
SET STATISTICS TIME OFF

USE [LCCHPDev]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_SLBloodTestResults]
		 --@Min_Lead_Value = 10.0
		 --, @Person_ID = 1556 

SELECT	'Return Value' = @return_value

GO
