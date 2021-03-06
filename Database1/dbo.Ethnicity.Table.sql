USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Ethnicity]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Ethnicity](
	[EthnicityID] [tinyint] IDENTITY(1,1) NOT NULL,
	[Ethnicity] [varchar](50) NOT NULL,
	[HistoricEthnicityCode] [char](1) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Ethnicity_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Ethnicity] PRIMARY KEY CLUSTERED 
(
	[EthnicityID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier of ethnicities' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ethnicity', @level2type=N'COLUMN',@level2name=N'EthnicityID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'friendly shortname of ethnicity' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ethnicity', @level2type=N'COLUMN',@level2name=N'Ethnicity'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of ethnicities' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Ethnicity'
GO
