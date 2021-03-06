USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[QuestionnaireDataSource]    Script Date: 4/26/2015 8:29:37 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[QuestionnaireDataSource](
	[QuestionnaireDataSourceID] [int] IDENTITY(1,1) NOT NULL,
	[QuestionnaireDataSourceName] [varchar](50) NOT NULL,
	[QuestionnaireDataSourceDescription] [varchar](253) NULL,
 CONSTRAINT [PK_QuestionnaireDataSource] PRIMARY KEY CLUSTERED 
(
	[QuestionnaireDataSourceID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the questionnaire data source' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireDataSource', @level2type=N'COLUMN',@level2name=N'QuestionnaireDataSourceID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Source of the questionnaire data - enviornmental or blood lead' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireDataSource', @level2type=N'COLUMN',@level2name=N'QuestionnaireDataSourceName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'More details about the source of the questionnaire data - enviornmental or blood lead' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireDataSource', @level2type=N'COLUMN',@level2name=N'QuestionnaireDataSourceDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'source of the data (Environmental group or Blood Lead)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'QuestionnaireDataSource'
GO
