USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Daycare]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Daycare](
	[DaycareID] [int] IDENTITY(1,1) NOT NULL,
	[DaycareName] [varchar](50) NOT NULL,
	[DaycareDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Daycare_CreatedDate]  DEFAULT (getdate()),
 CONSTRAINT [PK_Daycare] PRIMARY KEY CLUSTERED 
(
	[DaycareID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'name of the daycare' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Daycare', @level2type=N'COLUMN',@level2name=N'DaycareName'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'short description of the daycare business' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Daycare', @level2type=N'COLUMN',@level2name=N'DaycareDescription'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of daycare facilities' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Daycare'
GO
