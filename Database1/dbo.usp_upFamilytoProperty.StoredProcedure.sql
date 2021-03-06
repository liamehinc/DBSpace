USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_upFamilytoProperty]    Script Date: 4/26/2015 8:29:36 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO


-- =============================================
-- Author:		William Thier
-- Create date: 20150417
-- Description:	Stored Procedure to update new FamilytoProperty records
-- =============================================

CREATE PROCEDURE [dbo].[usp_upFamilytoProperty]   
	-- Add the parameters for the stored procedure here
	@FamilytoPropertyID int = NULL,
	@PropertyLinkTypeID int = NULL,
	@StartDate date = NULL,
	@EndDate date = NULL,
	@isPrimaryResidence bit = NULL,
	@DEBUG bit = 0

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;


	DECLARE @ErrorLogID int, @spexecuteSQLStr nvarchar(4000);
    -- Insert statements for procedure here
	BEGIN TRY
		SELECT @spexecuteSQLStr = N'update FamilytoProperty set EndDate = @End_Date';
		
		IF @PropertyLinkTypeID IS NOT NULL
			SELECT @spexecuteSQLStr = @spexecuteSQLStr + ', PropertyLinkTypeID = @Property_Link_Type_ID'

		IF @StartDate IS NOT NULL
			SELECT @spexecuteSQLStr = @spexecuteSQLStr + ', StartDate = @Start_Date'

		IF @isPrimaryResidence IS NOT NULL
			SELECT @spexecuteSQLStr = @spexecuteSQLStr + ', isPrimaryResidence = @is_Primary_Residence'

		-- Add filters to update the correct record
		SELECT @spexecuteSQLStr = @spexecuteSQLStr + ' Where FamilytoPropertyID = @Family_to_Property_ID'

		IF (@DEBUG = 1) 
			SELECT @spexecuteSQLStr, 'FamilytoPropertyID' = @FamilytoPropertyID, 'PropertyLinkTypeID' = @PropertyLinkTypeID
				, 'StartDate' = @StartDate, 'EndDate' = @EndDate, 'isPrimaryResidence' = @isPrimaryResidence;
			 
		EXEC [sp_executesql] @spexecuteSQLStr
			, N'@Family_to_Property_ID int, @Property_Link_Type_ID int, @Start_Date date, @End_Date date, @is_Primary_Residence bit'
			, @Family_to_Property_ID = @FamilytoPropertyID
			, @Property_Link_Type_ID = @PropertyLinkTypeID
			, @Start_Date = @StartDate
			, @End_Date = @EndDate
			, @is_Primary_Residence = @isPrimaryResidence;

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
