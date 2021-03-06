USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[ContractortoRemediationActionPlan]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[ContractortoRemediationActionPlan](
	[ContractorID] [int] NOT NULL,
	[RemediationActionPlanID] [int] NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[isSubContractor] [bit] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_ContractortoRemediationActionPlan] PRIMARY KEY CLUSTERED 
(
	[ContractorID] ASC,
	[RemediationActionPlanID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan] ADD  CONSTRAINT [DF_ContractortoRemediationActionPlan_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoRemediationActionPlan_Contractor] FOREIGN KEY([ContractorID])
REFERENCES [dbo].[Contractor] ([ContractorID])
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan] CHECK CONSTRAINT [FK_ContractortoRemediationActionPlan_Contractor]
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoRemediationActionPlan_RemediationActionPlan] FOREIGN KEY([RemediationActionPlanID])
REFERENCES [dbo].[RemediationActionPlan] ([RemediationActionPlanID])
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan] CHECK CONSTRAINT [FK_ContractortoRemediationActionPlan_RemediationActionPlan]
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoRemediationPlan_RemediationActionPlan] FOREIGN KEY([RemediationActionPlanID])
REFERENCES [dbo].[RemediationActionPlan] ([RemediationActionPlanID])
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan] CHECK CONSTRAINT [FK_ContractortoRemediationPlan_RemediationActionPlan]
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan]  WITH CHECK ADD  CONSTRAINT [FK_ContractortoSamplingPlan_Contractor] FOREIGN KEY([ContractorID])
REFERENCES [dbo].[Contractor] ([ContractorID])
GO
ALTER TABLE [dbo].[ContractortoRemediationActionPlan] CHECK CONSTRAINT [FK_ContractortoSamplingPlan_Contractor]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for contractor and sampling plan' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'ContractortoRemediationActionPlan'
GO
