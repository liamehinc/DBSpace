USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersonHobbyNotes]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PersonHobbyNotes](
	[PersonHobbyNotesID] [int] IDENTITY(1,1) NOT NULL,
	[PersonID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL CONSTRAINT [DF_PersonHobbyNotes_CreatedDate]  DEFAULT (getdate()),
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_PersonHobbyNotes] PRIMARY KEY CLUSTERED 
(
	[PersonHobbyNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PersonHobbyNotes]  WITH NOCHECK ADD  CONSTRAINT [FK_PersonHobbyNotes_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersonHobbyNotes] CHECK CONSTRAINT [FK_PersonHobbyNotes_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonHobbyNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'table for person hobby notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersonHobbyNotes'
GO
