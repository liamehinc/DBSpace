USE [LCCHPDev]
GO

/****** Object:  Table [dbo].[Person]    Script Date: 4/28/2015 12:05:53 AM ******/
SET ANSI_NULLS ON
GO

SET QUOTED_IDENTIFIER ON
GO

SET ANSI_PADDING ON
GO

CREATE TABLE [dbo].[Person](
	[PersonID] [int] IDENTITY(1,1) NOT NULL,
	[FirstName] [varchar](50) NOT NULL,
	[MiddleName] [varchar](50) NULL,
	[LastName] [varchar](50) NOT NULL,
	[BirthDate] [date] NULL,
	[Gender] [char](1) NULL,
	[StatusID] [smallint] NULL,
	[ForeignTravel] [bit] NULL,
	[OutofSite] [bit] NULL,
	[EatsForeignFood] [bit] NULL,
	[HistoricChildID] [smallint] NULL,
	[RetestDate] [date] NULL,
	[Moved] [bit] NULL,
	[MovedDate] [date] NULL,
	[isClosed] [bit] NULL,
	[isResolved] [bit] NULL,
	[GuardianID] [int] NULL,
	[personCode] [smallint] NULL,
	[isSmoker] [bit] NULL,
	[CreatedDate] [datetime] NULL,
	[ModifiedDate] [datetime] NULL,
	[Age]  AS ([dbo].[udf_CalculateAge]([BirthDate],getdate())),
	[isClient] [bit] NULL,
	[isNursing] [bit] NULL,
	[isPregnant] [bit] NULL,
	[ReleaseStatusID] [tinyint] NULL,
	[ReviewStatusID] [tinyint] NULL,
	[EmailAddress] [varchar](320) NULL,
 CONSTRAINT [PK_Person] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO

SET ANSI_PADDING OFF
GO

ALTER TABLE [dbo].[Person] ADD  CONSTRAINT [DF_Person_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO

ALTER TABLE [dbo].[Person] ADD  CONSTRAINT [DF_Person_isClient]  DEFAULT ((1)) FOR [isClient]
GO

ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [FK_Person_ReviewStatus] FOREIGN KEY([ReviewStatusID])
REFERENCES [dbo].[ReviewStatus] ([ReviewStatusID])
GO

ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [FK_Person_ReviewStatus]
GO

ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [ck_Person_BirthDate] CHECK  (([dbo].[udf_DateInThePast]([BirthDate])=(1)))
GO

ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [ck_Person_BirthDate]
GO

ALTER TABLE [dbo].[Person]  WITH CHECK ADD  CONSTRAINT [ck_Person_MovedDate] CHECK  (([dbo].[udf_DateInThePast]([MovedDate])=(1) OR [MovedDate] IS NULL))
GO

ALTER TABLE [dbo].[Person] CHECK CONSTRAINT [ck_Person_MovedDate]
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'unique identifier for each person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'PersonID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'personID of the person''s guardian' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person', @level2type=N'COLUMN',@level2name=N'GuardianID'
GO

EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of people and basic attributes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'Person'
GO

