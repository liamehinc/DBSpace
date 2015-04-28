USE [master]
GO

/****** Object:  Database [LCCHPTestImport]    Script Date: 4/26/2015 8:47:39 PM ******/
CREATE DATABASE [LCCHPTestImport]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'LCCHP', FILENAME = N'D:\MSSQL\Data\LCCHPTestImport.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 4096KB ), 
 FILEGROUP [LCCHPAttachments] CONTAINS FILESTREAM  DEFAULT 
( NAME = N'LCCHPAttachments', FILENAME = N'D:\MSSQL\Filestream\LCCHPAttachmentsTestImport' , MAXSIZE = UNLIMITED), 
 FILEGROUP [UData]  DEFAULT 
( NAME = N'LCCHP_UData', FILENAME = N'D:\MSSQL\Data\LCCHPTestImport_UData.ndf' , SIZE = 12288KB , MAXSIZE = UNLIMITED, FILEGROWTH = 4096KB )
 LOG ON 
( NAME = N'LCCHP_log', FILENAME = N'D:\MSSQL\Log\LCCHPTestImport_log.ldf' , SIZE = 21504KB , MAXSIZE = 2048GB , FILEGROWTH = 4096KB )
GO

ALTER DATABASE [LCCHPTestImport] SET COMPATIBILITY_LEVEL = 110
GO

IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [LCCHPTestImport].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO

ALTER DATABASE [LCCHPTestImport] SET ANSI_NULL_DEFAULT OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET ANSI_NULLS OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET ANSI_PADDING OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET ANSI_WARNINGS OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET ARITHABORT OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET AUTO_CLOSE OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET AUTO_CREATE_STATISTICS ON 
GO

ALTER DATABASE [LCCHPTestImport] SET AUTO_SHRINK OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET AUTO_UPDATE_STATISTICS ON 
GO

ALTER DATABASE [LCCHPTestImport] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET CURSOR_DEFAULT  GLOBAL 
GO

ALTER DATABASE [LCCHPTestImport] SET CONCAT_NULL_YIELDS_NULL OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET NUMERIC_ROUNDABORT OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET QUOTED_IDENTIFIER OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET RECURSIVE_TRIGGERS OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET  DISABLE_BROKER 
GO

ALTER DATABASE [LCCHPTestImport] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET TRUSTWORTHY OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET PARAMETERIZATION SIMPLE 
GO

ALTER DATABASE [LCCHPTestImport] SET READ_COMMITTED_SNAPSHOT OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET HONOR_BROKER_PRIORITY OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET RECOVERY FULL 
GO

ALTER DATABASE [LCCHPTestImport] SET  MULTI_USER 
GO

ALTER DATABASE [LCCHPTestImport] SET PAGE_VERIFY CHECKSUM  
GO

ALTER DATABASE [LCCHPTestImport] SET DB_CHAINING OFF 
GO

ALTER DATABASE [LCCHPTestImport] SET FILESTREAM( NON_TRANSACTED_ACCESS = FULL, DIRECTORY_NAME = N'LCCHPAttachmentsTestImport' ) 
GO

ALTER DATABASE [LCCHPTestImport] SET TARGET_RECOVERY_TIME = 0 SECONDS 
GO

ALTER DATABASE [LCCHPTestImport] SET  READ_WRITE 
GO
