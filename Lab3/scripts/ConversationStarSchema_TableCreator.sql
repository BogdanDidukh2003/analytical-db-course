-- ConversationStarSchema script for deleting and recreating tables

-- DELETING TABLES --

DROP TABLE IF EXISTS [conversation_fact];
DROP TABLE IF EXISTS [time_dim];
DROP TABLE IF EXISTS [region_dim];
DROP TABLE IF EXISTS [demographic_dim];
DROP TABLE IF EXISTS [operator_dim];
GO

-- CREATING TABLES --

CREATE TABLE [time_dim] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[year] [int] NOT NULL,
	[month] [int] NOT NULL,
	[day] [int] NOT NULL,
	[hour] [int] NOT NULL,
)

ALTER TABLE [time_dim]
	ADD CONSTRAINT [PK_time_dim] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE TABLE [region_dim] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[country] [varchar](50) NOT NULL,
	[region] [varchar](50) NOT NULL,
)

ALTER TABLE [region_dim]
	ADD CONSTRAINT [PK_region_dim] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE TABLE [demographic_dim] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[age] [int] NOT NULL,
	[gender] [varchar](50) NOT NULL,
)

ALTER TABLE [demographic_dim]
	ADD CONSTRAINT [PK_demographic_dim] PRIMARY KEY CLUSTERED ([id] ASC);
GO

CREATE TABLE [operator_dim] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[email] [varchar](50) NOT NULL,
	[age] [int] NOT NULL,
	[gender] [varchar](50) NOT NULL,
	[department_name] [varchar](50) NOT NULL,
	[department_country] [varchar](50) NOT NULL,
	[department_region] [varchar](50) NOT NULL,
	[department_city] [varchar](50) NOT NULL,
	[department_street] [varchar](50) NOT NULL,
)

ALTER TABLE [operator_dim]
	ADD CONSTRAINT [PK_operator_dim] PRIMARY KEY CLUSTERED ([id] ASC),
		CONSTRAINT [UQ_operator_dim_email] UNIQUE NONCLUSTERED ([email] ASC);
GO

CREATE TABLE [conversation_fact] (
	[id] [int] IDENTITY(1,1) NOT NULL,
	[time_id] [int] NOT NULL,
	[region_id] [int] NOT NULL,
	[demographic_id] [int] NOT NULL,
	[operator_id] [int] NOT NULL,
	[average_rating] [float] NOT NULL,
	[reported_issues] [int] NOT NULL,
	[resolved_issues] [int] NOT NULL,
	[total_calls] [int] NOT NULL,
)

ALTER TABLE [conversation_fact]
	ADD CONSTRAINT [PK_conversation_fact] PRIMARY KEY CLUSTERED ([id] ASC);
GO

-- ADDING FOREIGN KEY CONSTRAINTS --

ALTER TABLE [conversation_fact]  WITH CHECK ADD  CONSTRAINT [FK_conversation_fact_time_dim] FOREIGN KEY([time_id])
REFERENCES [time_dim] ([id])
GO
ALTER TABLE [conversation_fact] CHECK CONSTRAINT [FK_conversation_fact_time_dim]
GO

ALTER TABLE [conversation_fact]  WITH CHECK ADD  CONSTRAINT [FK_conversation_fact_region_dim] FOREIGN KEY([region_id])
REFERENCES [region_dim] ([id])
GO
ALTER TABLE [conversation_fact] CHECK CONSTRAINT [FK_conversation_fact_region_dim]
GO

ALTER TABLE [conversation_fact]  WITH CHECK ADD  CONSTRAINT [FK_conversation_fact_demographic_dim] FOREIGN KEY([demographic_id])
REFERENCES [demographic_dim] ([id])
GO
ALTER TABLE [conversation_fact] CHECK CONSTRAINT [FK_conversation_fact_demographic_dim]
GO

ALTER TABLE [conversation_fact]  WITH CHECK ADD  CONSTRAINT [FK_conversation_fact_operator_dim] FOREIGN KEY([operator_id])
REFERENCES [operator_dim] ([id])
GO
ALTER TABLE [conversation_fact] CHECK CONSTRAINT [FK_conversation_fact_operator_dim]
GO
