USE [LCCHPDev]
GO
/****** Object:  User [appUser]    Script Date: 3/15/2015 6:51:12 PM ******/
CREATE USER [appUser] FOR LOGIN [appUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [appUser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [appUser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [appUser]
GO
