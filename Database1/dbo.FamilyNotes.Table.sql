USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[FamilyNotes]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[FamilyNotes](
	[FamilyNotesID] [int] IDENTITY(1,1) NOT NULL,
	[FamilyID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_FamilyNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_FamilyNotes] PRIMARY KEY CLUSTERED 
(
	[FamilyNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[FamilyNotes]  WITH CHECK ADD  CONSTRAINT [FK_FamilyNotes_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO
ALTER TABLE [dbo].[FamilyNotes] CHECK CONSTRAINT [FK_FamilyNotes_Family]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilyNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'table for Family notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'FamilyNotes'
GO
