USE LCCHPTestImport
GO

/****** Script for SelectTopNRows command from SSMS  ******/

  insert into Ethnicity (Ethnicity, HistoricEthnicityCode)
  select ethnicBackground,ethnicCode from TESTAccessImport..lkEthnicBackground

  Select EthnicCode from TESTAccessImport..lkEthnicBackground where EthnicCode not in (Select HistoricEthnicityCode from Ethnicity)

Select Count(*) from Ethnicity
Select Count(*) from TESTAccessImport..lkEthnicBackground

  select * from Ethnicity
  select * from TESTAccessImport..lkEthnicBackground