USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[CleanupStatus]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[CleanupStatus](
	[CleanupStatusID] [tinyint] IDENTITY(1,1) NOT NULL,
	[CleanupStatusDescription] [varchar](253) NULL,
	[CleanupStatusName] [varchar](50) NULL,
	[HistoricCleanupStatusID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_CleanupStatus_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_CleanupStatus] PRIMARY KEY CLUSTERED 
(
	[CleanupStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the cleanup status object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CleanupStatus', @level2type=N'COLUMN',@level2name=N'CleanupStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'description of the cleanup status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CleanupStatus', @level2type=N'COLUMN',@level2name=N'CleanupStatusDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the cleanup status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CleanupStatus', @level2type=N'COLUMN',@level2name=N'CleanupStatusName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of clean up status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'CleanupStatus'
GO
