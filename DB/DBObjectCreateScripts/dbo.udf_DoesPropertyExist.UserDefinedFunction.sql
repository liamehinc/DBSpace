USE [LCCHPDev]
GO
/****** Object:  UserDefinedFunction [dbo].[udf_DoesPropertyExist]    Script Date: 3/24/2015 6:42:22 PM ******/
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
	@City varchar(50),
	@State char(2),
	@ZipCode varchar(12)
)
RETURNS int
AS
BEGIN
	-- Declare the return variable here
	DECLARE @PropertyID int

	-- Add the T-SQL statements to compute the return value here
	SELECT @PropertyID = PropertyID from Property where
		replace(AddressLine1,'.','') = replace(@AddressLine1,'.','') and City = @City 
		and [State] = @State and Zipcode = @ZipCode
	
	-- Return the result of the function
	RETURN @PropertyID

END

GO
