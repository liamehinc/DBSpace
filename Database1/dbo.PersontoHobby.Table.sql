USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[PersontoHobby]    Script Date: 8/28/2015 10:38:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[PersontoHobby](
	[PersonID] [int] NOT NULL,
	[HobbyID] [smallint] NOT NULL,
	[CreatedDate] [datetime] NULL,
 CONSTRAINT [PK_PersontoHobby] PRIMARY KEY CLUSTERED 
(
	[PersonID] ASC,
	[HobbyID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
ALTER TABLE [dbo].[PersontoHobby] ADD  CONSTRAINT [DF_PersontoHobby_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
ALTER TABLE [dbo].[PersontoHobby]  WITH CHECK ADD  CONSTRAINT [FK_PersontoHobby_Hobby] FOREIGN KEY([HobbyID])
REFERENCES [dbo].[Hobby] ([HobbyID])
GO
ALTER TABLE [dbo].[PersontoHobby] CHECK CONSTRAINT [FK_PersontoHobby_Hobby]
GO
ALTER TABLE [dbo].[PersontoHobby]  WITH NOCHECK ADD  CONSTRAINT [FK_PersontoHobby_Person] FOREIGN KEY([PersonID])
REFERENCES [dbo].[Person] ([PersonID])
GO
ALTER TABLE [dbo].[PersontoHobby] CHECK CONSTRAINT [FK_PersontoHobby_Person]
GO
EXEC sys.sp_addextendedproperty @name=N'MS_Description', @value=N'linking table for person and hobby' , @level0type=N'SCHEMA',@level0name=N'dbo', @level1type=N'TABLE',@level1name=N'PersontoHobby'
GO
