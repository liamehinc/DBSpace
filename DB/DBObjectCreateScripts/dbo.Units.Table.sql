USE [LCCHPDev]
GO
/****** Object:  Table [dbo].[Units]    Script Date: 4/14/2015 1:07:46 AM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
SET ANSI_PADDING ON
GO
CREATE TABLE [dbo].[Units](
	[UnitsID] [smallint] IDENTITY(1,1) NOT NULL,
	[Units] [varchar](20) NOT NULL,
	[UnitsDescription] [varchar](253) NULL,
	[ModifiedDate] [datetime] NULL,
	[CreatedDate] [datetime] NULL,
	[HistoricUnitsCode] [char](1) NULL,
 CONSTRAINT [PK_Units] PRIMARY KEY CLUSTERED 
(
	[UnitsID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [UData]
) ON [UData]

GO
SET ANSI_PADDING OFF
GO
ALTER TABLE [dbo].[Units] ADD  CONSTRAINT [DF_Units_CreatedDate]  DEFAULT (getdate()) FOR [CreatedDate]
GO
