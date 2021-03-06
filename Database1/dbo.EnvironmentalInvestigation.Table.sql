USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[EnvironmentalInvestigation]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[EnvironmentalInvestigation](
	[EnvironmentalInvestigationID] [int] IDENTITY(1,1) NOT NULL,
	[ConductEnvironmentalInvestigation] [bit] NULL,
	[ConductEnvironmentalInvestigationDecisionDate] [date] NULL,
	[Cost] [money] NULL,
	[EnvironmentalInvestigationDate] [date] NULL,
	[PropertyID] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_EnvironmentalInvestigation] PRIMARY KEY CLUSTERED 
(
	[EnvironmentalInvestigationID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[EnvironmentalInvestigation] ADD  CONSTRAINT [DF_EnvironmentalInvestigation_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[EnvironmentalInvestigation]  WITH CHECK ADD  CONSTRAINT [FK_EnvironmentalInvestigation_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[EnvironmentalInvestigation] CHECK CONSTRAINT [FK_EnvironmentalInvestigation_Property]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'0 - no, 1 - yes; is an environmental investigation going to be conducted' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EnvironmentalInvestigation', @level2type=N'COLUMN',@level2name=N'ConductEnvironmentalInvestigation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the workgroup decided whether to conduct an environmental investigation or not' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EnvironmentalInvestigation', @level2type=N'COLUMN',@level2name=N'ConductEnvironmentalInvestigationDecisionDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'cost of the environmental investigation' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'EnvironmentalInvestigation', @level2type=N'COLUMN',@level2name=N'Cost'
GO
