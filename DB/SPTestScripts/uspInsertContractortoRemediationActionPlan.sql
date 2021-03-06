USE [LeadTrackingTesting-Liam]
GO

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_InsertContractortoRemediationActionPlan]
		@ContractorID = 2,
		@RemediationActionPlanID = 2,
		@StartDate = '20110901',
		@EndDate = '20110923',
		@isSubContractor = 0

SELECT	'Return Value' = @return_value

GO

select * from RemediationActionPlan


Select 'StreetAddr' = P.StreetNumber + ' ' + P.Street + ' ' + coalesce(P.StreetSuffix,'')
	, 'AddrLine2' =  P.City + ', ' + P.State + ' ' + P.Zipcode 
	, C.ContractorName, R.RemediationActionPlanApprovalDate, R.HomeOwnerConsultationDate,R.ContractorCompletedInvestigationDate
	, R.RemediationActionPlanFinalReportSubmissionDate, R.EnvironmentalInvestigationID
from ContractortoRemediationActionPlan AS C2R
JOIN Contractor as C on C2R.ContractorID = C.ContractorID
JOIN RemediationACtionPlan as R on C2R.RemediationActionPlanID = R.RemediationActionPlanID
JOIN Property AS P on R.PropertyID = P.PropertyID