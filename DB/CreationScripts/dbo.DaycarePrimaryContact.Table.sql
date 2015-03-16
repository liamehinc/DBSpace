USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[DaycarePrimaryContact]    Script Date: 3/15/2015 6:51:12 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DaycarePrimaryContact](
	[DaycareID] [int] NOT NULL,
	[PersonID] [int] NOT NULL,
	[ContactPriority] [tinyint] NOT NULL,
	[PrimaryPhoneNumberID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_DaycareContactPerson] PRIMARY KEY CLUSTERED 
(
	[DaycareID] ASC,
	[PersonID] ASC,
	[ContactPriority] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[DaycarePrimaryContact] ADD  CONSTRAINT [DF_DaycareContactPerson_ContactPriority]  DEFAULT ((1)) FOR [ContactPriority]
GO
ALTER TABLE [dbo].[DaycarePrimaryContact] ADD  CONSTRAINT [DF_DaycarePrimaryContact_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[DaycarePrimaryContact]  WITH CHECK ADD  CONSTRAINT [FK_DaycareContactPerson_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[DaycarePrimaryContact] CHECK CONSTRAINT [FK_DaycareContactPerson_Person]
GO
ALTER TABLE [dbo].[DaycarePrimaryContact]  WITH CHECK ADD  CONSTRAINT [FK_DaycarePrimaryContact_PersontoPhoneNumber] FOREIGN KEY([PersonID], [PrimaryPhoneNumberID])
REFERENCES [dbo].[PersontoPhoneNumber] ([PersonID], [PhoneNumberID])
GO
ALTER TABLE [dbo].[DaycarePrimaryContact] CHECK CONSTRAINT [FK_DaycarePrimaryContact_PersontoPhoneNumber]
GO
ALTER TABLE [dbo].[DaycarePrimaryContact]  WITH CHECK ADD  CONSTRAINT [FK_DaycarePrimaryContact_PhoneNumber] FOREIGN KEY([PrimaryPhoneNumberID])
REFERENCES [dbo].[PhoneNumber] ([PhoneNumberID])
GO
ALTER TABLE [dbo].[DaycarePrimaryContact] CHECK CONSTRAINT [FK_DaycarePrimaryContact_PhoneNumber]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'priority of this person in the contact list (1 being highest priority)' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycarePrimaryContact', @level2type=N'COLUMN',@level2name=N'ContactPriority'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the primary contact number' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycarePrimaryContact', @level2type=N'COLUMN',@level2name=N'PrimaryPhoneNumberID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for daycare and person - identifying contact person' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'DaycarePrimaryContact'
GO
