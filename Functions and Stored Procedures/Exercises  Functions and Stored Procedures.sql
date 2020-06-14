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

-- 5. Salary Level Function
CREATE FUNCTION ufn_GetSalaryLevel(@salary DECIMAL(18, 4))
RETURNS VARCHAR(7)
AS
BEGIN
	DECLARE @salaryLevel VARCHAR(7);
	IF(@salary < 30000)
	 BEGIN
	  SET @salaryLevel = 'Low';
 	 END
	ELSE IF(@salary >= 30000 AND @salary <= 50000)
	 BEGIN
	  SET @salaryLevel = 'Average';
 	 END
	ELSE
	 BEGIN
	  SET @salaryLevel = 'High'
	 END
  RETURN @salaryLevel;
END

SELECT FirstName,
	   LastName,
	   dbo.ufn_GetSalaryLevel(Salary) AS [SalaryLevel]
FROM Employees
						   
-- 6.Employees by Salary Level
CREATE PROC usp_EmployeesBySalaryLevel(@salaryLevel VARCHAR(7))
AS
BEGIN
	SELECT FirstName, LastName
	FROM Employees AS e
	WHERE dbo.ufn_GetSalaryLevel(e.Salary) = @salaryLevel
END
EXEC usp_EmployeesBySalaryLevel 'high'						   

-- 7. Define Function
CREATE FUNCTION ufn_IsWordComprised(@setOfLetters NVARCHAR(50), @word NVARCHAR(50))
RETURNS BIT
AS
BEGIN
    DECLARE @matchCount INT = 0;
	DECLARE @i INT = 1; 

	WHILE(@i <= LEN(@word))
	 BEGIN
	  DECLARE @currChar CHAR = SUBSTRING(@word, @i, 1);
	  DECLARE @charIndex INT = CHARINDEX(@currChar, @setOFletters)

	  IF(@charIndex = 0)
	  BEGIN
	   RETURN 0;
	  END

	  SET @i = @i + 1;
	  
	 END
	 RETURN 1;
END

SELECT dbo.ufn_IsWordComprised('oistmiahf','Sofia')
			
-- 8.* Delete Employees and Departments
CREATE PROC usp_DeleteEmployeesFromDepartment (@departmentId INT)
AS
BEGIN

	DELETE FROM EmployeesProjects
	WHERE EmployeeID IN (
	                      SELECT EmployeeID FROM Employees
                          WHERE DepartmentID = @departmentId
	                    )
	UPDATE Employees
	SET ManagerID = NULL
	WHERE ManagerID IN (
	                     SELECT EmployeeID FROM Employees
                         WHERE DepartmentID = @departmentId
	                   )

	ALTER TABLE Departments
	ALTER COLUMN ManagerID INT


	UPDATE Departments
	SET ManagerID = NULL
	WHERE ManagerID IN (
	                     SELECT EmployeeID FROM Employees
                         WHERE DepartmentID = @departmentId
	                   )

DELETE FROM Employees
WHERE DepartmentID = @departmentId

DELETE FROM Departments
WHERE DepartmentID = @departmentId

SELECT COUNT(*) FROM Employees
WHERE DepartmentID = @departmentId

END

EXEC usp_DeleteEmployeesFromDepartment 1

-- 9.Find Full Name
CREATE PROCEDURE usp_GetHoldersFullName
AS
BEGIN
	SELECT CONCAT(FirstName, ' ', LastName) 
	AS [Full Name]  FROM AccountHolders
END			

-- 10.	People with Balance Higher Than
CREATE PROCEDURE usp_GetHoldersWithBalanceHigherThan(@amount DECIMAL(14,4))
AS
BEGIN

   SELECT FirstName AS [First Name], LastName AS [Last Name]
   FROM Accounts AS a
   JOIN AccountHolders AS ah ON a.AccountHolderId = ah.Id
   GROUP BY FirstName, LastName 
   HAVING SUM(Balance) > @amount
   ORDER BY FirstName, LastName
END

EXEC usp_GetHoldersWithBalanceHigherThan 1000000			

-- 11. Future Value Function
CREATE FUNCTION ufn_CalculateFutureValue
(@sum DECIMAL(18, 4), @yearlyInterestRate FLOAT, @numberOfYears INT )
RETURNS DECIMAL(18, 4)
AS
BEGIN
    DECLARE @result DECIMAL(18, 4);
     SET @result = @sum * POWER(( 1 + @yearlyInterestRate), @numberOfYears);
	    RETURN @result
END

SELECT dbo.ufn_CalculateFutureValue(1000, 0.1, 5)								     
