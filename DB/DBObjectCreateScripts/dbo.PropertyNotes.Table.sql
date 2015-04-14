USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PropertyNotes]    Script Date: 4/14/2015 1:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PropertyNotes](
	[PropertyNotesID] [int] IDENTITY(1,1) NOT NULL,
	[PropertyID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_PropertyNotes] PRIMARY KEY CLUSTERED 
(
	[PropertyNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PropertyNotes] ADD  CONSTRAINT [DF_PropertyNotes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PropertyNotes]  WITH CHECK ADD  CONSTRAINT [FK_PropertyNotes_Property] FOREIGN KEY([PropertyID])
REFERENCES [dbo].[Property] ([PropertyID])
GO
ALTER TABLE [dbo].[PropertyNotes] CHECK CONSTRAINT [FK_PropertyNotes_Property]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertyNotes'
GO
