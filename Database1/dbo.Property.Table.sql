USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Property]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Property](
	[PropertyID] [int] IDENTITY(1,1) NOT NULL,
	[ConstructionTypeID] [tinyint] NULL,
	[AreaID] [int] NULL,
	[isinHistoricDistrict] [bit] NULL,
	[isRemodeled] [bit] NULL,
	[RemodelDate] [date] NULL,
	[isinCityLimits] [bit] NULL,
	[StreetNumber] [varchar](15) NULL,
	[AddressLine1] [varchar](100) NULL,
	[StreetSuffix] [varchar](20) NULL,
	[AddressLine2] [varchar](100) NULL,
	[City] [varchar](50) NULL,
	[State] [char](2) NULL,
	[Zipcode] [varchar](12) NULL,
	[OwnerID] [int] NULL,
	[isOwnerOccuppied] [bit] NULL,
	[ReplacedPipesFaucets] [tinyint] NULL,
	[TotalRemediationCosts] [money] NULL,
	[isResidential] [bit] NULL,
	[isCurrentlyBeingRemodeled] [bit] NULL,
	[hasPeelingChippingPaint] [bit] NULL,
	[County] [varchar](50) NULL,
	[isRental] [bit] NULL,
	[HistoricPropertyID] [smallint] NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_Property_CreatedDate]  DEFAULT (getdate()),
	[ModifiedDate] [datetime] NULL,
	[YearBuilt] [date] NULL,
	[Street] [varchar](50) NULL,
	[ReviewStatusID] [tinyint] NULL,
	[AssessorsOfficeID] [varchar](50) NULL,
	[KidsFirstID] [int] NULL,
	[CleanUPStatusID] [tinyint] NULL,
	[OwnerContactInformation] [varchar](1000) NULL,
 CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_Area] FOREIGN KEY([AreaID])
REFERENCES [dbo].[Area] ([AreaID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_Area]
GO
ALTER TABLE [dbo].[Property]  WITH NOCHECK ADD  CONSTRAINT [FK_Property_CleanupStatus] FOREIGN KEY([CleanUPStatusID])
REFERENCES [dbo].[CleanupStatus] ([CleanupStatusID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_CleanupStatus]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_ConstructionType] FOREIGN KEY([ConstructionTypeID])
REFERENCES [dbo].[ConstructionType] ([ConstructionTypeID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_ConstructionType]
GO
ALTER TABLE [dbo].[Property]  WITH NOCHECK ADD  CONSTRAINT [FK_Property_Person] FOREIGN KEY([OwnerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_Person]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_ReleaseStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReleaseStatus] ([ReleaseStatusID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_ReleaseStatus]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the property object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'PropertyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Identification number from Assessor''s office' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'AssessorsOfficeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Kids First identification number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'KidsFirstID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Cleanup status id for the current property cleanup state' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'CleanUPStatusID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'basic contact information for the property owner' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'OwnerContactInformation'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of properties and basic attributes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property'
GO
