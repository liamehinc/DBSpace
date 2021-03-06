USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[AccessAgreement]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[AccessAgreement](
	[AccessAgreementID] [int] IDENTITY(1,1) NOT NULL,
	[AccessPurposeID] [int] NULL,
	[AccessAgreementFile] [varbinary](max) NULL,
	[PropertyID] [int] NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_AccessAgreement] PRIMARY KEY CLUSTERED 
(
	[AccessAgreementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData] TEXTIMAGE_ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[AccessAgreement] ADD  CONSTRAINT [DF_AccessAgreement_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[AccessAgreement]  WITH CHECK ADD  CONSTRAINT [FK_AccessAgreement_AccessPurpose] FOREIGN KEY([AccessPurposeID])
REFERENCES [dbo].[AccessPurpose] ([AccessPurposeID])
GO
ALTER TABLE [dbo].[AccessAgreement] CHECK CONSTRAINT [FK_AccessAgreement_AccessPurpose]
GO
ALTER TABLE [dbo].[AccessAgreement]  WITH CHECK ADD  CONSTRAINT [FK_AccessAgreement_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[AccessAgreement] CHECK CONSTRAINT [FK_AccessAgreement_Property]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'id of the access purpose' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessAgreement', @level2type=N'COLUMN',@level2name=N'AccessPurposeID'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'collection of access agreements' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'AccessAgreement'
GO
