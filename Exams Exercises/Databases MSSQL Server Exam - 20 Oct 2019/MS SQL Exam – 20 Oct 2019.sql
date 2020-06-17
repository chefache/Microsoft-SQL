CREATE DATABASE [Service]

-- Section 1. DDL 
CREATE TABLE [Users](
[Id] INT PRIMARY KEY IDENTITY,
[Username] NVARCHAR(30) UNIQUE NOT NULL,
[Password] NVARCHAR(50) NOT NULL,
[Name] NVARCHAR(50),
[Birthdate] DATETIME2,
[Age] INT CHECK(Age BETWEEN 14 AND 110),
[Email] NVARCHAR(50) NOT NULL
)


CREATE TABLE [Departments](
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL,
)

CREATE TABLE [Employees](
[Id] INT PRIMARY KEY IDENTITY,
[FirstName] NVARCHAR(25),
[LastName] NVARCHAR(25),
[Birthdate] DATETIME2,
[Age] INT CHECK (Age BETWEEN 18 AND 110),
[DepartmentId] INT NOT NULL FOREIGN KEY REFERENCES Departments(Id)
)


CREATE TABLE [Categories](
[Id] INT PRIMARY KEY IDENTITY,
[Name] NVARCHAR(50) NOT NULL,
[DepartmentId] INT NOT NULL FOREIGN KEY REFERENCES Departments(Id)
)

CREATE TABLE [Status](
[Id] INT PRIMARY KEY IDENTITY,
[Label] NVARCHAR(30) NOT NULL
)

CREATE TABLE [Reports](
[Id] INT PRIMARY KEY IDENTITY,
[CategoryId] INT NOT NULL FOREIGN KEY REFERENCES Categories(Id),
[StatusId] INT NOT NULL FOREIGN KEY REFERENCES [Status](Id),
[OpenDate] DATETIME2 NOT NULL,
[CloseDate] DATETIME2,
[Description] NVARCHAR(200) NOT NULL,
[UserId] INT NOT NULL FOREIGN KEY REFERENCES Users(Id),
[EmployeeId] INT FOREIGN KEY REFERENCES Employees(Id)
)

-- 2. Insert
INSERT INTO Employees(FirstName, LastName, Birthdate, DepartmentId)
	VALUES
	('Marlo', 'O''Malley', '1958-9-21', 1),
	('Niki', 'Stanaghan', '1969-11-26', 4),
	('Ayrton', 'Senna', '1960-03-21', 9),
	('Ronnie', 'Peterson', '1944-02-14', 9),
	('Giovanna', 'Amati', '1959-07-20', 5)

INSERT INTO Reports(CategoryId, StatusId, OpenDate, CloseDate, [Description], UserId, EmployeeId)
	VALUES
			(1, 1, '2017-04-13', NULL, 'Stuck Road on Str.133', 6, 2),
			(6, 3, '2015-09-05', '2015-12-06', 'Charity trail running', 3, 5),
			(14, 2, '2015-09-07', NULL, 'Falling bricks on Str.58', 5, 2),
			(4, 3, '2017-07-03', '2017-07-06', 'Cut off streetlight on Str.11', 1, 1)


-- 3. Update
UPDATE Reports
SET CloseDate = GETDATE()
WHERE CloseDate IS NULL

--4. Delete
DELETE Reports
WHERE StatusId = 4

-- 5. Unassigned Reports
SELECT [Description], FORMAT(OpenDate, 'dd-MM-yyyy') AS [OpenDate] FROM Reports
WHERE EmployeeId IS NULL
ORDER BY DATEPART(YEAR, OpenDate) ASC, 
DATEPART(MONTH, OpenDate) ASC, 
DATEPART(DAY, OpenDate) ASC, 
[Description] ASC 

-- 6. Reports & Categories
SELECT [Description], c.[Name] AS [CategoryName] FROM Reports AS r
JOIN Categories AS c ON c.Id = r.CategoryId
WHERE CategoryId IS NOT NULL
ORDER BY [Description] ASC, c.[Name] ASC

-- 7. Most Reported Category
SELECT u.Username, c.[Name] FROM Users AS u
JOIN Reports AS r ON r.UserId = u.Id
JOIN Categories AS c ON c.Id = r.CategoryId
WHERE DATEPART(MONTH, u.Birthdate) = DATEPART(MONTH, r.OpenDate)
AND
DATEPART(DAY, u.Birthdate) = DATEPART(DAY, r.OpenDate)
ORDER BY u.Username ASC, c.[Name] ASC

-- 8.Birthday Report

-- 9.Users per Employee 
SELECT FullName, COUNT(UserId)  AS UserCount
          FROM (SELECT CONCAT(e.FirstName, ' ', e.LastName) AS [FullName],
		             r.UserId
                     FROM Employees AS e
                     LEFT JOIN Reports AS r ON r.EmployeeId = e.Id 
			   ) AS FullNameQuery
GROUP BY FullName
ORDER BY UserCount DESC, FullName ASC
