USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlDaycare]    Script Date: 6/20/2015 11:25:44 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO

-- =============================================
-- Author:		Liam Thier
-- Create date: 20150319
-- Description:	returns daycare name, id, description
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlDaycare] 
	-- Add the parameters for the stored procedure here
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	select DaycareID,DaycareName,DaycareDescription from Daycare order by DaycareName

END


GO
