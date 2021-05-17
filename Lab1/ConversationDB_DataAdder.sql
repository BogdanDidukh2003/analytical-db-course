-- ConversationDB script for filling up database
USE ConversationDB
GO

-- DELETING DATA AND RESETTING IDENTITY --
DELETE FROM [feedback];
GO
DBCC CHECKIDENT ('[feedback]', RESEED, 0);
GO
DELETE FROM [issue];
GO
DBCC CHECKIDENT ('[issue]', RESEED, 0);
GO
DELETE FROM [conversation];
GO
DBCC CHECKIDENT ('[conversation]', RESEED, 0);
GO
DELETE FROM [customer];
GO
DBCC CHECKIDENT ('[customer]', RESEED, 0);
GO
DELETE FROM [operator];
GO
DBCC CHECKIDENT ('[operator]', RESEED, 0);
GO
DELETE FROM [department];
GO
DBCC CHECKIDENT ('[department]', RESEED, 0);
GO
DELETE FROM [personal_info];
GO
DBCC CHECKIDENT ('[personal_info]', RESEED, 0);
GO
DELETE FROM [location];
GO
DBCC CHECKIDENT ('[location]', RESEED, 0);
GO
DELETE FROM [rating];
GO
DBCC CHECKIDENT ('[rating]', RESEED, 0);
GO
DELETE FROM [gender];
GO
DBCC CHECKIDENT ('[gender]', RESEED, 0);
GO

-- INSERTING DATA --

INSERT INTO [gender]
	([name])
VALUES
	('MALE'),
	('FEMALE')
GO

INSERT INTO [rating]
	([name], [value])
VALUES
	('VERY BAD', 1),
	('BAD', 2),
	('AVERAGE', 3),
	('GOOD', 4),
	('EXCELLENT', 5)
GO

INSERT INTO [location]
	([country], [region], [city])
VALUES
	('Ukraine', 'Lviv', 'Lviv'),
	('Ukraine', 'Lviv', 'Drohobych'),
	('Ukraine', 'Kyiv', 'Kyiv'),
	('Ukraine', 'Kyiv', 'Brovary'),
	('Ukraine', 'Kyiv', 'Pereiaslav'),
	('Ukraine', 'Kharkiv', 'Lviv'),
	('Ukraine', 'Kharkiv', 'Izyum')
GO

INSERT INTO [personal_info]
	([first_name], [last_name], [birth_year], [phone], [email], [gender_id], [location_id])
VALUES
	('Jimm', 'Ank', 1992, 380921223344, 'asf@gmail.com', 1, 2),
	('John', 'Keil', 1996, 380997821469, 'asdfn@gmail.com', 1, 4),
	('Lea', 'Foe', 1999, 380977777787, 'a23rn@gmail.com', 2, 1),
	('Ron', 'Var', 1993, 380991123541, 'a3nf@gmail.com', 1, 5),
	('Dan', 'Alner', 1993, 380964858458, 'n234nn@gmail.com', 1, 3),
	('Lucy', 'Coil', 2000, 380961122445, 'qwnef@gmail.com', 2, 2),
	('Amber', 'Melst', 2001, 380981144778, 'dsnq12@gmail.com', 2, 6),
	('Aron', 'Free', 2000, 380954862159, 'jien3@gmail.com', 1, 4),
	('Lisa', 'Unir', 1998, 380941351456, 'alknf.e@gmail.com', 2, 2),
	('Peter', 'Ton', 1999, 380938468168, 'ttoonn@gmail.com', 1, 7)
GO

INSERT INTO [department]
	([name], [location_id], [street])
VALUES
	('Main Department 1', 3, 'EWjfinnefi'),
	('Department N32', 1, 'AWENFin'),
	('Department N234', 6, '--')
GO

INSERT INTO [operator]
	([personal_info_id], [department_id])
VALUES
	(1, 1),
	(2, 2),
	(3, 1),
	(4, 3)
GO

INSERT INTO [customer]
	([personal_info_id])
VALUES
	(5),
	(6),
	(7),
	(8),
	(9),
	(10)
GO

INSERT INTO [conversation]
	([customer_id], [operator_id], [start_time], [end_time])
VALUES
	(1, 1, '20210128 10:34:09', '20210128 10:34:50'),
	(2, 3, '20210208 15:22:42', '20210208 15:24:12'),
	(3, 4, '20210208 15:45:01', '20210208 15:48:40'),
	(4, 2, '20210221 11:12:32', '20210221 11:13:32'),
	(5, 2, '20210227 13:13:31', '20210227 13:15:31'),
	(6, 3, '20210319 16:20:01', '20210319 16:23:01'),
	(1, 1, '20210330 14:20:10', '20210330 14:20:59'),
	(2, 1, '20210330 14:26:10', '20210330 14:29:59'),
	(3, 2, '20210330 14:20:10', '20210330 14:20:59'),
	(4, 4, '20210414 11:15:10', '20210414 11:17:10'),
	(5, 3, '20210416 11:19:10', '20210416 11:25:01'),
	(6, 4, '20210428 17:18:25', '20210428 17:19:25'),
	(1, 2, '20210429 17:23:25', '20210429 17:24:55'),
	(2, 2, '20210512 14:23:23', '20210512 14:28:23'),
	(3, 1, '20210513 15:21:20', '20210513 15:23:20'),
	(4, 3, '20210513 15:21:20', '20210513 15:22:10'),
	(5, 1, '20210519 11:20:10', '20210519 11:22:10'),
	(6, 4, '20210519 16:24:12', '20210519 16:24:12')
GO

INSERT INTO [issue]
	([description], [reported_date], [customer_id], [operator_id], [is_resolved])
VALUES
	('Fix button on home page', '20210319', 6, 3, 0),
	('Card transaction failed while shopping', '20210330', 2, 1, 1),
	('Account banned', '20210513', 3, 1, 0)
GO

INSERT INTO [feedback]
	([customer_id], [rating_id])
VALUES
	(1, 5),
	(2, 4),
	(3, 1),
	(4, 4),
	(6, 3)
GO
