USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Property]    Script Date: 3/26/2015 1:22:08 AM ******/
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
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[YearBuilt] [date] NULL,
	[Street] [varchar](50) NULL,
 CONSTRAINT [PK_Property] PRIMARY KEY CLUSTERED 
(
	[PropertyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Property] ADD  CONSTRAINT [DF_Property_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_Area] FOREIGN KEY([AreaID])
REFERENCES [dbo].[Area] ([AreaID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_Area]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_ConstructionType] FOREIGN KEY([ConstructionTypeID])
REFERENCES [dbo].[ConstructionType] ([ConstructionTypeID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_ConstructionType]
GO
ALTER TABLE [dbo].[Property]  WITH CHECK ADD  CONSTRAINT [FK_Property_Person] FOREIGN KEY([OwnerID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[Property] CHECK CONSTRAINT [FK_Property_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for the property object' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property', @level2type=N'COLUMN',@level2name=N'PropertyID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of properties and basic attributes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Property'
GO
