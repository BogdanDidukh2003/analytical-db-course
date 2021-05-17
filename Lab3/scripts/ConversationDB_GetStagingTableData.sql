-- ConversationDB script to get all data for staging table

SELECT
	NULL AS [time_id],
	NULL AS [region_id],
	NULL AS [demographic_id],
	NULL AS [operator_id],

	AVG([average_rating]) AS [average_rating],
	SUM([reported_issues]) AS [reported_issues],
	SUM([resolved_issues]) AS [resolved_issues],
	SUM([total_calls]) AS [total_calls],

	[customer_birth_year], [customer_gender], [country], [region],
	[email], [operator_birth_year], [operator_gender],
	[department_name], [department_country], [department_region], [department_city], [department_street],
	[year], [month], [day], [hour]
FROM (
SELECT [conversation].[id], [conversation].[customer_id], [conversation].[operator_id], 

	[rating].[rating] AS [average_rating],
	(CASE WHEN [issue].[is_resolved] IS NOT NULL THEN 1 ELSE 0 END) AS [reported_issues],
	(CASE WHEN [issue].[is_resolved] = 1 THEN 1 ELSE 0 END) AS [resolved_issues],
	1 AS [total_calls],

	[customer].[birth_year] AS [customer_birth_year], [customer].[gender] AS [customer_gender],
	[customer].[country] AS [country], [customer].[region] AS [region],

	[operator].[email], [operator].[birth_year] AS [operator_birth_year], [operator].[gender] AS [operator_gender],
	[operator].[department_name], [operator].[department_country], [operator].[department_region],
	[operator].[department_city], [operator].[department_street],

	DATEPART(YEAR, [start_time]) AS [year], DATEPART(MONTH, [start_time]) AS [month], 
	DATEPART(DAY, [start_time]) AS [day], DATEPART(HOUR, [start_time]) AS [hour]
FROM [conversation]
INNER JOIN (
	SELECT [customer].[id], [birth_year], [gender].[name] AS [gender], [country], [region]
	FROM [customer]
	INNER JOIN [personal_info] ON [customer].[id] = [personal_info].[id]
	INNER JOIN [gender] ON [personal_info].[gender_id] = [gender].[id]
	INNER JOIN [location] ON [personal_info].[location_id] = [location].[id]
) AS [customer] ON [conversation].[customer_id] = [customer].[id]
INNER JOIN (
	SELECT [operator].[id], [email], [birth_year], [gender].[name] AS [gender], 
		[department].[name] AS [department_name], [country] AS [department_country], 
		[region] AS [department_region], [city] AS [department_city],
		[department].[street] AS [department_street]
	FROM [operator]
	INNER JOIN [personal_info] ON [operator].[id] = [personal_info].[id]
	INNER JOIN [gender] ON [personal_info].[gender_id] = [gender].[id]
	INNER JOIN [department] ON [operator].[department_id] = [department].[id]
	INNER JOIN [location] ON [department].[location_id] = [location].[id]
) AS [operator] ON [conversation].[operator_id] = [operator].[id]
LEFT JOIN (
	SELECT [customer_id], [rating].[value] as [rating]
	FROM [feedback]
	INNER JOIN [rating] ON [feedback].[rating_id] = [rating].[id]
) AS [rating] ON [conversation].[customer_id] = [rating].customer_id
LEFT JOIN (
	SELECT [customer_id], [operator_id], [is_resolved]
	FROM [issue]
) AS [issue] ON (
	[conversation].[customer_id] = [issue].[customer_id] 
	AND [conversation].[operator_id] = [issue].[operator_id]
	)
) AS [staging_table]
GROUP BY 
	[operator_id], [customer_birth_year], [customer_gender], [country], [region], 
	[email], [operator_birth_year], [operator_gender], [department_name], [department_country],
	[department_region], [department_city], [department_street],
	[year], [month], [day], [hour]
;
