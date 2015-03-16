USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertDaycare]    Script Date: 3/15/2015 6:51:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new Daycare records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertDaycare]   -- usp_InsertDaycare 
	-- Add the parameters for the stored procedure here
	@DaycareName varchar(50) = NULL,
	@DaycareDescription varchar(200) = NULL,
	@newDayCareID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into Daycare ( DaycareName, DaycareDescription )
					 Values ( @DaycareName, @DaycareDescription );
	END TRY
	BEGIN CATCH
		-- Call procedure to print error information.
		EXECUTE dbo.uspPrintError;

		-- Roll back any active or uncommittable transactions before
		-- inserting information in the ErrorLog.
		IF XACT_STATE() <> 0
		BEGIN
			ROLLBACK TRANSACTION;
		END

		EXECUTE dbo.uspLogError @ErrorLogID = @ErrorLogID OUTPUT;
		RETURN ERROR_NUMBER()
	END CATCH;
END

GO
