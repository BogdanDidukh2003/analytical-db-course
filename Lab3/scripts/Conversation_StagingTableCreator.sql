-- Script to crate staging table for ConversationDB

DROP TABLE IF EXISTS [conversation_staging]

CREATE TABLE [conversation_staging] (
	[id] [int] IDENTITY(1,1) NOT NULL,

	[time_id] [int] NULL,
	[region_id] [int] NULL,
	[demographic_id] [int] NULL,
	[operator_id] [int] NULL,

	[average_rating] [float] NULL,
	[reported_issues] [int] NOT NULL,
	[resolved_issues] [int] NOT NULL,
	[total_calls] [int] NOT NULL,

	[customer_birth_year] [int] NOT NULL,
	[customer_gender] [varchar](50) NOT NULL,

	[country] [varchar](50) NOT NULL,
	[region] [varchar](50) NOT NULL,

	[email] [varchar](50) NOT NULL,
	[operator_birth_year] [int] NOT NULL,
	[operator_gender] [varchar](50) NOT NULL,
	[department_name] [varchar](50) NOT NULL,
	[department_country] [varchar](50) NOT NULL,
	[department_region] [varchar](50) NOT NULL,
	[department_city] [varchar](50) NOT NULL,
	[department_street] [varchar](50) NOT NULL,
	
	[year] [int] NOT NULL,
	[month] [int] NOT NULL,
	[day] [int] NOT NULL,
	[hour] [int] NOT NULL,
)

ALTER TABLE [conversation_staging]
	ADD CONSTRAINT [PK_conversation_staging] PRIMARY KEY CLUSTERED ([id] ASC);
GO
