USE [master]
GO
/****** Object:  Database [TypetoRace]    Script Date: 8/26/2022 6:26:19 PM ******/
CREATE DATABASE [TypetoRace]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'TypetoRace', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\DATA\TypetoRace.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'TypetoRace_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL13.SQL2016\MSSQL\DATA\TypetoRace_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
GO
ALTER DATABASE [TypetoRace] SET COMPATIBILITY_LEVEL = 130
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [TypetoRace].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [TypetoRace] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [TypetoRace] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [TypetoRace] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [TypetoRace] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [TypetoRace] SET ARITHABORT OFF 
GO
ALTER DATABASE [TypetoRace] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [TypetoRace] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [TypetoRace] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [TypetoRace] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [TypetoRace] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [TypetoRace] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [TypetoRace] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [TypetoRace] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [TypetoRace] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [TypetoRace] SET  ENABLE_BROKER 
GO
ALTER DATABASE [TypetoRace] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [TypetoRace] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [TypetoRace] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [TypetoRace] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [TypetoRace] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [TypetoRace] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [TypetoRace] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [TypetoRace] SET RECOVERY FULL 
GO
ALTER DATABASE [TypetoRace] SET  MULTI_USER 
GO
ALTER DATABASE [TypetoRace] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [TypetoRace] SET DB_CHAINING OFF 
GO
ALTER DATABASE [TypetoRace] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [TypetoRace] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [TypetoRace] SET DELAYED_DURABILITY = DISABLED 
GO
EXEC sys.sp_db_vardecimal_storage_format N'TypetoRace', N'ON'
GO
ALTER DATABASE [TypetoRace] SET QUERY_STORE = OFF
GO
USE [TypetoRace]
GO
ALTER DATABASE SCOPED CONFIGURATION SET MAXDOP = 0;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET MAXDOP = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET LEGACY_CARDINALITY_ESTIMATION = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET LEGACY_CARDINALITY_ESTIMATION = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET PARAMETER_SNIFFING = ON;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET PARAMETER_SNIFFING = PRIMARY;
GO
ALTER DATABASE SCOPED CONFIGURATION SET QUERY_OPTIMIZER_HOTFIXES = OFF;
GO
ALTER DATABASE SCOPED CONFIGURATION FOR SECONDARY SET QUERY_OPTIMIZER_HOTFIXES = PRIMARY;
GO
USE [TypetoRace]
GO
/****** Object:  Table [dbo].[Player_score]    Script Date: 8/26/2022 6:26:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[Player_score](
	[Score_id] [int] IDENTITY(1,1) NOT NULL,
	[wpm] [int] NOT NULL,
	[cpm] [int] NOT NULL,
	[timeelapsed] [int] NOT NULL,
	[Aquracy] [int] NOT NULL,
	[PlayerId] [int] NOT NULL,
	[DateCreated] [datetime] NULL,
PRIMARY KEY CLUSTERED 
(
	[Score_id] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
/****** Object:  Table [dbo].[players]    Script Date: 8/26/2022 6:26:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[players](
	[PlayerId] [int] IDENTITY(1,1) NOT NULL,
	[Player_name] [varchar](10) NOT NULL,
	[Player_email] [varchar](20) NOT NULL,
	[Player_password] [char](13) NOT NULL,
	[C_Status] [bit] NULL,
	[Player_role] [int] NULL,
	[ImageUrl] [varchar](100) NULL,
PRIMARY KEY CLUSTERED 
(
	[PlayerId] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON) ON [PRIMARY]
) ON [PRIMARY]

GO
ALTER TABLE [dbo].[Player_score] ADD  DEFAULT (getdate()) FOR [DateCreated]
GO
ALTER TABLE [dbo].[Player_score]  WITH CHECK ADD FOREIGN KEY([PlayerId])
REFERENCES [dbo].[players] ([PlayerId])
GO
/****** Object:  StoredProcedure [dbo].[Highscore]    Script Date: 8/26/2022 6:26:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Highscore]
as
begin
select top 3 P.Player_name, P.ImageUrl, ps.wpm from players p
inner join Player_score ps on p.PlayerId = ps.PlayerId
where ps.wpm IN (select distinct top 3  max(wpm) from Player_score group by PlayerId order by max(wpm) desc)
order by wpm desc
end


GO
/****** Object:  StoredProcedure [dbo].[myhighscore]    Script Date: 8/26/2022 6:26:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[myhighscore]

@id int
as
begin
select top(1) * from Player_score
where  wpm = (select max(wpm) from Player_score where PlayerId = @id) 
end


GO
/****** Object:  StoredProcedure [dbo].[PlayerScore]    Script Date: 8/26/2022 6:26:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[PlayerScore]
as
begin
select top 3 P.Player_name, P.ImageUrl, ps.wpm from players p
inner join Player_score ps on p.PlayerId = ps.PlayerId
where ps.wpm IN (select distinct top 3  max(wpm) from Player_score group by PlayerId order by max(wpm) desc)
order by wpm desc
end



GO
/****** Object:  StoredProcedure [dbo].[Top#3]    Script Date: 8/26/2022 6:26:19 PM ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
create procedure [dbo].[Top#3]
as
begin
select top 3 p.PlayerId, P.Player_name, P.ImageUrl, ps.wpm from players p
inner join Player_score ps on p.PlayerId = ps.PlayerId
where ps.wpm IN (select distinct top 3  max(wpm) from Player_score group by PlayerId order by max(wpm) desc)
order by wpm desc
end



GO
USE [master]
GO
ALTER DATABASE [TypetoRace] SET  READ_WRITE 
GO
