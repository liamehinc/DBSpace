USE [LCCHPDev]
GO

DECLARE	@return_value int,
		@PropertyID int

EXEC	@return_value = [dbo].[usp_InsertProperty]
		@ConstructionTypeID = 1,
		@AreaID = NULL,
		@isinHistoricDistrict = 1,
		@isRemodeled = 1,
		@RemodelDate = '1998',
		@isinCityLimits = 1,
		@AddressLine1 = N'24 e. 3rd ave',
		@AddressLine2 = N'Apt 5D',
		@City = N'Jonestown',
		@State = N'CO',
		@Zipcode = N'88021',
		@YearBuilt = '1978',
		@Ownerid = NULL,
		@isOwnerOccuppied = 1,
		@ReplacedPipesFaucets = NULL,
		@TotalRemediationCosts = NULL,
		@New_PropertyNotes = NULL,
		@isResidential = 1,
		@isCurrentlyBeingRemodeled = 0,
		@hasPeelingChippingPaint = 0,
		@County = NULL,
		@isRental = NULL,
		@PropertyID = @PropertyID OUTPUT

SELECT	@PropertyID as N'@PropertyID'

SELECT	'Return Value' = @return_value

GO
