USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_SlChildStatus]    Script Date: 3/15/2015 6:51:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150215
-- Description:	returns valid status codes for passed in type - Child
-- =============================================
CREATE PROCEDURE [dbo].[usp_SlChildStatus] 
	-- Add the parameters for the stored procedure here
	@StatusType varchar(50) = NULL, 
	@DEBUG BIT  = 0
AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

    -- Insert statements for procedure here
	IF (@StatusType = 'Child')
		select statusName from Status where StatusID in (2, 7, 8, 9, 15)
	ELSE
		select statusName from Status

END

GO
