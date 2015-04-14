USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Medium]    Script Date: 4/14/2015 1:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Medium](
	[MediumID] [int] IDENTITY(1,1) NOT NULL,
	[MediumName] [varchar](50) NOT NULL,
	[MediumDescription] [varchar](253) NULL,
	[TriggerLevel] [int] NULL,
	[TriggerLevelUnitsID] [int] NULL,
	[HistoricMediumCode] [char](1) NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Medium] PRIMARY KEY CLUSTERED 
(
	[MediumID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Medium] ADD  CONSTRAINT [DF_Medium_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of the medium' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Medium', @level2type=N'COLUMN',@level2name=N'MediumID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short name for the medium' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Medium', @level2type=N'COLUMN',@level2name=N'MediumName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short description of the medium' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Medium', @level2type=N'COLUMN',@level2name=N'MediumDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'mediumcode identifier from legacy database' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Medium', @level2type=N'COLUMN',@level2name=N'HistoricMediumCode'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of mediums that are tested' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Medium'
GO
