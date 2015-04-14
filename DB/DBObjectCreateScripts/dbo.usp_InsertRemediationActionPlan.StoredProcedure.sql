USE [LCCHPDev]
GO
/****** Object:  StoredProcedure [dbo].[usp_InsertRemediationActionPlan]    Script Date: 4/14/2015 1:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO



-- =============================================
-- Author:		William Thier
-- Create date: 20140817
-- Description:	Stored Procedure to insert new RemediationActionPlan records
-- =============================================

CREATE PROCEDURE [dbo].[usp_InsertRemediationActionPlan]   -- usp_InsertRemediationActionPlan 
	-- Add the parameters for the stored procedure here
	@RemediationActionPlanApprovalDate date = getdate,
	@HomeOwnerConsultationDate date = NULL,
	@ContractorCompletedInvestigationDate date = NULL,
	@EnvironmentalInvestigationID int = NULL,
	@RemediationActionPlanFinalReportSubmissionDate date = NULL,
	@RemediationActionPlanFile varbinary(max) = NULL,
	@PropertyID int = NULL,
	@NewRemediationActionPlanID int OUTPUT

AS
BEGIN
	-- SET NOCOUNT ON added to prevent extra result sets from
	-- interfering with SELECT statements.
	SET NOCOUNT ON;

	DECLARE @ErrorLogID int;
    -- Insert statements for procedure here
	BEGIN TRY
		 INSERT into RemediationActionPlan ( RemediationActionPlanApprovalDate, HomeOwnerConsultationDate, ContractorCompletedInvestigationDate
		                                     , EnvironmentalInvestigationID, RemediationActionPlanFinalReportSubmissionDate,
											 RemediationActionPlanFile, PropertyID )
					 Values ( @RemediationActionPlanApprovalDate, @HomeOwnerConsultationDate, @ContractorCompletedInvestigationDate
								, @EnvironmentalInvestigationID, @RemediationActionPlanFinalReportSubmissionDate
								, @RemediationActionPlanFile, @PropertyID );
		SELECT @NewRemediationActionPlanID = SCOPE_IDENTITY();
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
