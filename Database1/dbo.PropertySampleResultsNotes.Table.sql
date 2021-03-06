USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PropertySampleResultsNotes]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[PropertySampleResultsNotes](
	[PropertySampleResultsNotesID] [int] IDENTITY(1,1) NOT NULL,
	[PropertySampleResultsID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Notes] [varchar](3000) NOT NULL,
 CONSTRAINT [PK_PropertySampleResultsNotes] PRIMARY KEY CLUSTERED 
(
	[PropertySampleResultsNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[PropertySampleResultsNotes] ADD  CONSTRAINT [DF_PropertySampleResultsNotes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PropertySampleResultsNotes]  WITH CHECK ADD  CONSTRAINT [FK_PropertySampleResultsNotes_PropertySampleResults] FOREIGN KEY([PropertySampleResultsID])
REFERENCES [dbo].[PropertySampleResults] ([PropertySampleResultsID])
GO
ALTER TABLE [dbo].[PropertySampleResultsNotes] CHECK CONSTRAINT [FK_PropertySampleResultsNotes_PropertySampleResults]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResultsNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PropertySampleResultsNotes'
GO
