USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[MediumSampleResultsNotes]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[MediumSampleResultsNotes](
	[MediumSampleResultsNotesID] [int] IDENTITY(1,1) NOT NULL,
	[MediumSampleResultsID] [int] NOT NULL,
	[CreatedDate] [datetime] NULL,
	[Notes] [varchar](3000) NULL,
 CONSTRAINT [PK_MediumSampleResultsNotes] PRIMARY KEY CLUSTERED 
(
	[MediumSampleResultsNotesID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[MediumSampleResultsNotes] ADD  CONSTRAINT [DF_MediumSampleResultsNotes_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[MediumSampleResultsNotes]  WITH CHECK ADD  CONSTRAINT [FK_MediumSampleResultsNotes_MediumSampleResults] FOREIGN KEY([MediumSampleResultsID])
REFERENCES [dbo].[MediumSampleResults] ([MediumSampleResultsID])
GO
ALTER TABLE [dbo].[MediumSampleResultsNotes] CHECK CONSTRAINT [FK_MediumSampleResultsNotes_MediumSampleResults]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'date the notes where added' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResultsNotes', @level2type=N'COLUMN',@level2name=N'CreatedDate'
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for access agreement and access agreement notes' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'MediumSampleResultsNotes'
GO
