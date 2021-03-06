USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoAccessAgreement]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoAccessAgreement](
	[PersonID] [int] NOT NULL,
	[AccessAgreementID] [int] NOT NULL,
	[AccessAgreementDate] [date] NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoAccessAgreement] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[AccessAgreementID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoAccessAgreement] ADD  CONSTRAINT [DF_PersontoAccessAgreement_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoAccessAgreement]  WITH CHECK ADD  CONSTRAINT [FK_PersontoAccessAgreement_AccessAgreement] FOREIGN KEY([AccessAgreementID])
REFERENCES [dbo].[AccessAgreement] ([AccessAgreementID])
GO
ALTER TABLE [dbo].[PersontoAccessAgreement] CHECK CONSTRAINT [FK_PersontoAccessAgreement_AccessAgreement]
GO
ALTER TABLE [dbo].[PersontoAccessAgreement]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoAccessAgreement_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoAccessAgreement] CHECK CONSTRAINT [FK_PersontoAccessAgreement_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the access agreement was signed' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoAccessAgreement', @level2type=N'COLUMN',@level2name=N'AccessAgreementDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and access agreement' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoAccessAgreement'
GO
