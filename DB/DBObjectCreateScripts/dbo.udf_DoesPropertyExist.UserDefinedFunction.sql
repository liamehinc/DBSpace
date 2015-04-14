USE [LCCHPDev]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DoesPropertyExist]    Script Date: 4/14/2015 1:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
-- =============================================
-- Author:		Liam Thier
-- Create date: 20150322
-- Description:	Function to check for duplicate property
-- =============================================
CREATE FUNCTION [dbo].[udf_DoesPropertyExist] 
(
	-- Add the parameters for the function here
	@AddressLine1 varchar(100),
	@AddressLine2 varchar(100) = NULL,
	@City varchar(50),
	@State char(2),
	@ZipCode varchar(12)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PropertyID int

	--Print 'Checking ' +  cast(@AddressLine1 as varchar) + ' ' + cast(@AddressLine2 as varchar) + ' ' +
	--	@City + ' ' + @State + ' '+ @ZipCode
	-- Determine if the property matches an existing property address:
	-- AddressLine1, AddressLine2, City, State, and ZipCode match

	IF (@AddressLine2 IS NULL)
		SELECT @PropertyID = PropertyID from Property where
			(dbo.RemoveSpecialChars(AddressLine1) = dbo.RemoveSpecialChars(@AddressLine1))
			AND (AddressLine2 IS NULL)
			AND (City = @City )
			and ([State] = @State and Zipcode = @ZipCode)
	ELSE
		SELECT @PropertyID = PropertyID from Property where
			(dbo.RemoveSpecialChars(AddressLine1) = dbo.RemoveSpecialChars(@AddressLine1))
			AND (dbo.RemoveSpecialChars(isNULL(AddressLine2,'')) = dbo.RemoveSpecialChars(@AddressLine2))
			AND (City = @City )
			and ([State] = @State and Zipcode = @ZipCode)


	-- Return the result of the function
	RETURN @PropertyID

END

GO
