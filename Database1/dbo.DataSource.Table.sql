USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[DataSource]    Script Date: 4/26/2015 8:29:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[DataSource](
	[DataSourceID] [tinyint] IDENTITY(1,1) NOT NULL,
	[DataSourceDescription] [varchar](253) NULL,
	[DataSourceName] [varchar](50) NULL,
	[HistoricDataSourceID] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_DataSource] PRIMARY KEY CLUSTERED 
(
	[DataSourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[DataSource] ADD  CONSTRAINT [DF_DataSource_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Detailed description of the data source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource', @level2type=N'COLUMN',@level2name=N'DataSourceDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the data source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource', @level2type=N'COLUMN',@level2name=N'DataSourceName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'historic data source ID from access database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource', @level2type=N'COLUMN',@level2name=N'HistoricDataSourceID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'last modified date for the record' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource', @level2type=N'COLUMN',@level2name=N'ModifiedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the record was created' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of contact types' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DataSource'
GO
