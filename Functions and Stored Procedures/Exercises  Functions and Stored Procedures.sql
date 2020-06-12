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
