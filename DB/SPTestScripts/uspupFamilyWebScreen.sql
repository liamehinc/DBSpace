USE [LCCHPDev]
GO


select top 3 * from family order by familyID desc
select top 3 * from Property order by createddate desc

DECLARE	@return_value int

EXEC	@return_value = [dbo].[usp_upFamilyWebScreen]
		@Family_ID = 2824,
		@New_Last_Name = N'Galindo',
		@PropertyID = 11364,
		@New_ConstructionType = 4,
		@New_AreaID = 4,
		@New_isinHistoricDistrict = 0,
		@New_isRemodeled = 0,
		@New_RemodelDate = '20120501',
		@New_isinCityLimits = 0,
		@New_Address_Line1 = NULL,
		@New_Address_Line2 = N'suite 105',
		@New_CityName = N'Jacksonville',
		@New_County = N'Orange',
		@New_StateAbbr = N'FL',
		@New_ZipCode = N'45589',
		@New_Owner_id = NULL,
		@New_is_Owner_Occupied = 1,
		@New_ReplacedPipesFaucets = 1,
		@New_TotalRemediationCosts = 27985,
		@New_PropertyNotes = N'remodeled kitchen and bathroom',
		@New_is_Residential = 1,
		@New_isCurrentlyBeingRemodeled = 0,
		@New_has_Peeling_Chipping_Patin = 0,
		@New_is_Rental = 0,
		@New_HomePhone = NULL,
		@New_WorkPhone = NULL,
		@New_Number_of_Smokers = 0,
		@New_Primary_Language_ID = 1,
		@New_Family_Notes = N'the family has recently taken up tying their own lures',
		@New_Pets = 4,
		@New_Frequently_Wash_Pets = 0,
		@New_Pets_in_and_out = 0,
		@New_Primary_Property_ID = 11364,
		@New_ForeignTravel = 0,
		@DEBUG = 1

SELECT	'Return Value' = @return_value

select top 3 * from family order by familyID desc
select top 3 * from Property order by createddate desc


select ModifiedDate,* from person order by Person.ModifiedDate desc