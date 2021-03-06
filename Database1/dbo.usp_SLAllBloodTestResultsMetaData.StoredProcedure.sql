USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SLAllBloodTestResultsMetaData]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20141222
-- Description:	select blood test results
--				optionally only return for a specific 
--				client
-- =============================================
CREATE PROCEDURE [dbo].[usp_SLAllBloodTestResultsMetaData] 
	-- Add the parameters for the stored procedure here
	@Person_ID int = NULL,
	@Min_Lead_Value numeric(9,4) = NULL,
	@DEBUG bit = 0


AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @spexecutesqlStr	NVARCHAR(4000), @OrderBy NVARCHAR(500),
			@Recompile BIT = 1, @ErrorLogID int; 
	BEGIN
    -- Insert statements for procedure here
	SELECT 'ClientID' = [P].[personid], 'LastName' = [P].[LastName], 'BirthDate' = [P].[BirthDate]
				, [BTR].[SampleDate], 'Pb_ug_Per_dl' = [BTR].[LeadValue]
				, 'Hb_g_Per_dl' = [BTR].[HemoglobinValue], 'RetestBL' = DATEADD(yy,1,sampledate)
				, 'RetestHB' = DATEADD(yy,1,sampledate), 'Close' = [P].[isClosed], 'Moved' = [P].[Moved]
				, 'Movedate' = [P].[MovedDate]
			from [Person] [P]
			join [BloodTestResults] [BTR] on [P].[PersonID] = [BTR].[PersonID]
			WHERE 1 = 0
	END
END




GO
