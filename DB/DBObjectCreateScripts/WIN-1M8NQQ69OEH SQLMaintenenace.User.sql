USE [LCCHPDev]
GO
/****** Object:  User [WIN-1M8NQQ69OEH\SQLMaintenenace]    Script Date: 4/14/2015 1:07:46 AM ******/
CREATE USER [WIN-1M8NQQ69OEH\SQLMaintenenace] FOR LOGIN [WIN-1M8NQQ69OEH\SQLMaintenenace] WITH DEFAULT_SCHEMA=[dbo]
GO
ALTER ROLE [db_backupoperator] ADD MEMBER [WIN-1M8NQQ69OEH\SQLMaintenenace]
GO
