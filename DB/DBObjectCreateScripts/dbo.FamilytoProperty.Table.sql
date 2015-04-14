USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[FamilytoProperty]    Script Date: 4/14/2015 1:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FamilytoProperty](
	[FamilytoPropertyID] [int] IDENTITY(1,1) NOT NULL,
	[FamilyID] [int] NOT NULL,
	[PropertyID] [int] NOT NULL,
	[PropertyLinkTypeID] [tinyint] NULL,
	[ReviewStatusID] [tinyint] NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
	[isPrimaryResidence] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
 CONSTRAINT [PK_FamilytoProperty] PRIMARY KEY CLUSTERED 
(
	[FamilytoPropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[FamilytoProperty] ADD  CONSTRAINT [DF_FamilytoProperty_StartDate]  DEFAULT (getdate()) FOR [StartDate]
GO
ALTER TABLE [dbo].[FamilytoProperty] ADD  CONSTRAINT [DF_FamilytoProperty_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_Family]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_Property]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_PropertyLinkType] FOREIGN KEY([PropertyLinkTypeID])
REFERENCES [dbo].[PropertyLinkType] ([PropertyLinkTypeID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_PropertyLinkType]
GO
ALTER TABLE [dbo].[FamilytoProperty]  WITH NOCHECK ADD  CONSTRAINT [FK_FamilytoProperty_ReviewStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReviewStatus] ([ReviewStatusID])
GO
ALTER TABLE [dbo].[FamilytoProperty] CHECK CONSTRAINT [FK_FamilytoProperty_ReviewStatus]
GO
