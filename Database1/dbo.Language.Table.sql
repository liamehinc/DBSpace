USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Language]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Language](
	[LanguageID] [tinyint] IDENTITY(1,1) NOT NULL,
	[LanguageName] [varchar](50) NOT NULL,
	[HistoricPrimaryLanguageCode] [char](1) NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Language_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_Language] PRIMARY KEY CLUSTERED 
(
	[LanguageID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of langauge object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'LanguageID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'spoken language' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language', @level2type=N'COLUMN',@level2name=N'LanguageName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of spoken languages' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Language'
GO
