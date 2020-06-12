-- 1. Employees with Salary Above 35000
CREATE PROC usp_GetEmployeesSalaryAbove35000
AS
BEGIN
SELECT FirstName, LastName 
FROM Employees AS e
WHERE e.Salary > 35000
END

-- 2.Employees with Salary Above Number
CREATE PROC usp_GetEmployeesSalaryAboveNumber(@chaeckAmount DECIMAL(18,4))
AS
BEGIN
SELECT FirstName, LastName
FROM Employees AS e
WHERE e.Salary >= @chaeckAmount
END

EXEC usp_GetEmployeesSalaryAboveNumber 48100


-- 3. Town Names Starting With
CREATE PROC usp_GetTownsStartingWith (@string NVARCHAR(50))
AS
BEGIN
SELECT Name
FROM Towns AS t
WHERE t.Name LIKE @string + '%'
END

EXEC usp_GetTownsStartingWith 'b'

-- 4.Employees from Town
CREATE PROC usp_GetEmployeesFromTown(@townName NVARCHAR(50))
AS
BEGIN
SELECT e.FirstName AS [First Name], e.LastName AS [Last Name]
FROM Employees AS e
JOIN Addresses AS a ON a.AddressID = e.AddressID
JOIN Towns AS t ON t.TownID = a.TownID
WHERE t.Name = @townName
END

EXEC usp_GetEmployeesFromTown 'Sofia'
