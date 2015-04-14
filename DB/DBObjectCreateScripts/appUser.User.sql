USE [LCCHPDev]
GO
/****** Object:  User [appUser]    Script Date: 4/14/2015 1:07:46 AM ******/
CREATE USER [appUser] FOR LOGIN [appUser] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_owner] ADD MEMBER [appUser]
GO
ALTER ROLE [db_datareader] ADD MEMBER [appUser]
GO
ALTER ROLE [db_datawriter] ADD MEMBER [appUser]
GO
