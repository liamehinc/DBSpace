USE [LCCHPDev]
GO
/****** Object:  User [WIN-1M8NQQ69OEH\SQLMaintenenace]    Script Date: 3/15/2015 6:51:12 PM ******/
CREATE USER [WIN-1M8NQQ69OEH\SQLMaintenenace] FOR LOGIN [WIN-1M8NQQ69OEH\SQLMaintenenace] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [WIN-1M8NQQ69OEH\SQLMaintenenace]
GO
