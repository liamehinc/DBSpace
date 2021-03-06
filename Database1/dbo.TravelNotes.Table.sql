USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[TravelNotes]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[TravelNotes](
	[TravelNotesID] [int] IDENTITY(1,1) NOT NULL,
	[FamilyID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Notes] [varchar](3000) NOT NULL,
	[StartDate] [date] NULL,
	[EndDate] [date] NULL,
 CONSTRAINT [PK_TravelNotes] PRIMARY KEY CLUSTERED 
(
	[TravelNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[TravelNotes] ADD  CONSTRAINT [DF_TravelNotes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[TravelNotes]  WITH CHECK ADD  CONSTRAINT [FK_TravelNotes_Family] FOREIGN KEY([FamilyID])
REFERENCES [dbo].[Family] ([FamilyID])
GO
ALTER TABLE [dbo].[TravelNotes] CHECK CONSTRAINT [FK_TravelNotes_Family]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TravelNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'Collection of family and travel notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'TravelNotes'
GO
