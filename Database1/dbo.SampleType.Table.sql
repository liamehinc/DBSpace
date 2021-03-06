USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[SampleType]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[SampleType](
	[SampleTypeID] [tinyint] IDENTITY(1,1) NOT NULL,
	[SampleTypeName] [varchar](50) NULL,
	[SampleTypeDescription] [varchar](253) NULL,
	[historicSampleType] [char](1) NULL,
	[SampleTarget] [varchar](50) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_SampleType_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_SampleType] PRIMARY KEY CLUSTERED 
(
	[SampleTypeID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of sample type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleType', @level2type=N'COLUMN',@level2name=N'SampleTypeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'friendly name for the sample type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleType', @level2type=N'COLUMN',@level2name=N'SampleTypeName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'extended description of the sample type' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleType', @level2type=N'COLUMN',@level2name=N'SampleTypeDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of sample types' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'SampleType'
GO
