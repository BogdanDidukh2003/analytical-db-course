-- ConversationDB script for automated creation of database

-- INITIAL CLEAN UP --
USE master
GO
DROP DATABASE IF EXISTS ConversationDB;
GO

-- Located at C:\Program Files\Microsoft SQL Server\MSSQL15.MSSQLSERVER\MSSQL\DATA
CREATE DATABASE ConversationDB
GO

USE ConversationDB
GO

-- CREATION OF TABLES --

CREATE TABLE [rating] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[value] [int] NOT NULL,
)

ALTER TABLE [rating]
	ADD CONSTRAINT [PK_rating] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE TABLE [gender] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
)

ALTER TABLE [gender]
	ADD CONSTRAINT [PK_gender] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE TABLE [location] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[country] [varchar](50) NOT NULL,
	[region] [varchar](50) NOT NULL,
	[city] [varchar](50) NOT NULL,
)

ALTER TABLE [location]
	ADD CONSTRAINT [PK_location] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE TABLE [personal_info] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[first_name] [varchar](50) NOT NULL,
	[last_name] [varchar](50) NOT NULL,
	[birth_year] [int] NOT NULL,
	[phone] [decimal](12, 0) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[gender_id] [int] NOT NULL,
	[location_id] [int] NOT NULL,
)

ALTER TABLE [personal_info]
	ADD CONSTRAINT [PK_personal_info] PRIMARY KEY CLUSTERED ([id] ASC),
		CONSTRAINT [UQ_personal_info_email] UNIQUE NONCLUSTERED ([email] ASC),
		CONSTRAINT [UQ_personal_info_phone] UNIQUE NONCLUSTERED ([phone] ASC);
GO

CREATE TABLE [customer] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[personal_info_id] [int] NOT NULL,
)

ALTER TABLE [customer]
	ADD CONSTRAINT [PK_customer] PRIMARY KEY CLUSTERED ([id] ASC),
		CONSTRAINT [UQ_customer_personal_info_id] UNIQUE NONCLUSTERED ([personal_info_id] ASC);
GO

CREATE TABLE [department] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[name] [varchar](50) NOT NULL,
	[location_id] [int] NOT NULL,
	[street] [varchar](50) NOT NULL,
)

ALTER TABLE [department]
	ADD CONSTRAINT [PK_department] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE TABLE [operator] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[personal_info_id] [int] NOT NULL,
	[department_id] [int] NOT NULL,
	[is_available] [bit] DEFAULT 1,
)

ALTER TABLE [operator]
	ADD CONSTRAINT [PK_operator] PRIMARY KEY CLUSTERED ([id] ASC),
		CONSTRAINT [UQ_operator_personal_info_id] UNIQUE NONCLUSTERED ([personal_info_id] ASC);
GO

CREATE TABLE [conversation] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NOT NULL,
	[operator_id] [int] NOT NULL,
	[start_time] [datetime] NOT NULL,
	[end_time] [datetime] NULL,
)

ALTER TABLE [conversation]
	ADD CONSTRAINT [PK_conversation] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE TABLE [feedback] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[customer_id] [int] NOT NULL,
	[rating_id] [int] NOT NULL,
	[comment] [varchar](50) NULL,
)

ALTER TABLE [feedback]
	ADD CONSTRAINT [PK_feedback] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE TABLE [issue] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[description] [varchar](max) NOT NULL,
	[reported_date] [date] NOT NULL,
	[is_resolved] [bit] DEFAULT 0,
	[customer_id] [int] NOT NULL,
	[operator_id] [int] NOT NULL,
)

ALTER TABLE [issue]
	ADD CONSTRAINT [PK_issue] PRIMARY KEY CLUSTERED ([id] ASC);
GO

-- ADDING FOREIGN KEY CONSTRAINTS --

ALTER TABLE [personal_info]  WITH CHECK ADD  CONSTRAINT [FK_personal_info_gender] FOREIGN KEY([gender_id])
REFERENCES [gender] ([id])
GO
ALTER TABLE [personal_info] CHECK CONSTRAINT [FK_personal_info_gender]
GO

ALTER TABLE [personal_info]  WITH CHECK ADD  CONSTRAINT [FK_personal_info_location] FOREIGN KEY([location_id])
REFERENCES [location] ([id])
GO
ALTER TABLE [personal_info] CHECK CONSTRAINT [FK_personal_info_location]
GO

ALTER TABLE [conversation]  WITH CHECK ADD  CONSTRAINT [FK_conversation_customer] FOREIGN KEY([customer_id])
REFERENCES [customer] ([id])
GO
ALTER TABLE [conversation] CHECK CONSTRAINT [FK_conversation_customer]
GO

ALTER TABLE [conversation]  WITH CHECK ADD  CONSTRAINT [FK_conversation_operator] FOREIGN KEY([operator_id])
REFERENCES [operator] ([id])
GO
ALTER TABLE [conversation] CHECK CONSTRAINT [FK_conversation_operator]
GO

ALTER TABLE [customer]  WITH CHECK ADD  CONSTRAINT [FK_customer_personal_info] FOREIGN KEY([personal_info_id])
REFERENCES [personal_info] ([id])
GO
ALTER TABLE [customer] CHECK CONSTRAINT [FK_customer_personal_info]
GO

ALTER TABLE [department]  WITH CHECK ADD  CONSTRAINT [FK_department_location] FOREIGN KEY([location_id])
REFERENCES [location] ([id])
GO
ALTER TABLE [department] CHECK CONSTRAINT [FK_department_location]
GO

ALTER TABLE [feedback]  WITH CHECK ADD  CONSTRAINT [FK_feedback_customer] FOREIGN KEY([customer_id])
REFERENCES [customer] ([id])
GO
ALTER TABLE [feedback] CHECK CONSTRAINT [FK_feedback_customer]
GO

ALTER TABLE [feedback]  WITH CHECK ADD  CONSTRAINT [FK_feedback_rating] FOREIGN KEY([rating_id])
REFERENCES [rating] ([id])
GO
ALTER TABLE [feedback] CHECK CONSTRAINT [FK_feedback_rating]
GO

ALTER TABLE [issue]  WITH CHECK ADD  CONSTRAINT [FK_issue_customer] FOREIGN KEY([customer_id])
REFERENCES [customer] ([id])
GO
ALTER TABLE [issue] CHECK CONSTRAINT [FK_issue_customer]
GO

ALTER TABLE [issue]  WITH CHECK ADD  CONSTRAINT [FK_issue_operator] FOREIGN KEY([operator_id])
REFERENCES [operator] ([id])
GO
ALTER TABLE [issue] CHECK CONSTRAINT [FK_issue_operator]
GO

ALTER TABLE [operator]  WITH CHECK ADD  CONSTRAINT [FK_operator_department] FOREIGN KEY([department_id])
REFERENCES [department] ([id])
GO
ALTER TABLE [operator] CHECK CONSTRAINT [FK_operator_department]
GO

ALTER TABLE [operator]  WITH CHECK ADD  CONSTRAINT [FK_operator_personal_info] FOREIGN KEY([personal_info_id])
REFERENCES [personal_info] ([id])
GO
ALTER TABLE [operator] CHECK CONSTRAINT [FK_operator_personal_info]
GO
