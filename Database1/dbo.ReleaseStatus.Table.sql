USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[ReleaseStatus]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[ReleaseStatus](
	[ReleaseStatusID] [tinyint] IDENTITY(1,1) NOT NULL,
	[ReleaseStatusDescription] [varchar](253) NULL,
	[ReleaseStatusName] [varchar](50) NULL,
	[HistoricReleaseStatusID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_ReleaseStatus_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_ReleaseStatus] PRIMARY KEY CLUSTERED 
(
	[ReleaseStatusID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the Release status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus', @level2type=N'COLUMN',@level2name=N'ReleaseStatusDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the Release status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus', @level2type=N'COLUMN',@level2name=N'ReleaseStatusName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic ReleaseStatus ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus', @level2type=N'COLUMN',@level2name=N'HistoricReleaseStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of Release Status' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ReleaseStatus'
GO
