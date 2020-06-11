-- 1.Records’ Count
SELECT COUNT(*) AS [Count]
FROM WizzardDeposits

-- 2.1 Longest Magic Wand
SELECT TOP(1) MagicWandSize AS [LongestMagicWand]
FROM WizzardDeposits
ORDER BY MagicWandSize DESC

-- 2.2
SELECT DepositGroup, MAX(MagicWandSize) AS [LongestMagicWand]
FROM WizzardDeposits
GROUP BY  DepositGroup

-- 2.3* Smallest Deposit Group Per Magic Wand Size
SELECT TOP(2) t.DepositGroup 
        FROM 
            (SELECT DepositGroup, AVG(MagicWandSize) AS LongestMagicWand 
             FROM WizzardDeposits
             GROUP BY DepositGroup
			)AS t
ORDER BY LongestMagicWand

--3. Deposits Sum
SELECT DepositGroup, SUM(DepositAmount) AS [TotalSum] 
FROM WizzardDeposits
GROUP BY DepositGroup

--4. Deposits Sum for Ollivander Family
SELECT DepositGroup, SUM(DepositAmount)AS [TotalSum] 
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup

--5. Deposits Filter
SELECT DepositGroup, SUM(DepositAmount) AS [Total Sum]
FROM WizzardDeposits
WHERE MagicWandCreator = 'Ollivander family'
GROUP BY DepositGroup
HAVING SUM(DepositAmount) < 150000
ORDER BY [Total Sum] DESC

--6. Deposit Charge
SELECT DepositGroup, MagicWandCreator, MIN(DepositCharge) AS [MinDepositCharge]
FROM WizzardDeposits
GROUP BY DepositGroup, MagicWandCreator
ORDER BY MagicWandCreator ASC, DepositGroup

-- 7. Age Groups
SELECT AgeGroup, COUNT(*) AS [WizardCount]
           FROM
               (SELECT 
	             CASE
	        	  WHEN Age <= 10 THEN '[0-10]'
	        	  WHEN Age BETWEEN 11 AND 20 THEN '[11-20]'
	        	  WHEN Age BETWEEN 21 AND 30 THEN '[21-30]'
	        	  WHEN Age BETWEEN 31 AND 40 THEN '[31-40]'
	        	  WHEN AGE BETWEEN 41 AND 50 THEN '[41-50]'
	        	  WHEN AGE BETWEEN 51 AND 60 THEN '[51-60]'
	              ELSE '[61+]'
	             END AS [AgeGroup]
                  FROM WizzardDeposits
	      		)AS AgeGroupQuery	
GROUP BY AgeGroup

-- 8. First Letter
SELECT DISTINCT SUBSTRING(FirstName, 1, 1) AS [FirstLetter]
FROM WizzardDeposits
WHERE DepositGroup = 'Troll Chest'
ORDER BY FirstLetter

-- 9. Average Interest 
SELECT DepositGroup,IsDepositExpired ,AVG(DepositInterest) AS AverageInterest
FROM WizzardDeposits
WHERE DepositStartDate > '1985-01-01'
GROUP BY DepositGroup, IsDepositExpired
ORDER BY DepositGroup DESC, IsDepositExpired ASC

--10. * Rich Wizard, Poor Wizard
SELECT SUM(Difference) FROM
               (
                SELECT FirstName AS [Host Wizard], 
                DepositAmount AS [Host Wizard Deposit],
                LEAD (FirstName) OVER (ORDER BY Id ASC) AS [Guest Wizard],
                LEAD (DepositAmount) OVER (ORDER BY Id ASC) AS [Guest Wizard Deposit],
                DepositAmount - LEAD (DepositAmount) OVER (ORDER BY Id ASC) AS [Difference]
                FROM WizzardDeposits
                ) AS DiffQUERY
WHERE [Guest Wizard] IS NOT NULL

USE SoftUni

--11. Departments Total Salaries
SELECT DepartmentID, SUM(Salary) AS TotalSalary
FROM Employees
GROUP BY DepartmentID
ORDER BY DepartmentID

-- 12. Employees Minimum Salaries
SELECT DepartmentID, MIN(Salary) AS [MinimumSalary]
FROM Employees
WHERE HireDate > '2000-01-01'
GROUP BY DepartmentID
HAVING DepartmentID IN(2, 5, 7)

-- 13. Employees Average Salaries
SELECT * INTO EmployeesWithHighSalary FROM Employees
WHERE Salary > 30000

DELETE EmployeesWithHighSalary
WHERE ManagerID = 42

UPDATE EmployeesWithHighSalary
SET Salary += 5000
WHERE DepartmentID = 1

SELECT DepartmentID, AVG(Salary) AS [AverageSalary]
FROM EmployeesWithHighSalary
GROUP BY DepartmentID

-- 14. Employees Maximum Salaries
SELECT DepartmentID, MAX(Salary) AS [MaxSalary]
FROM Employees
GROUP BY DepartmentID
HAVING MAX(Salary) < 30000 OR MAX(Salary) > 70000

-- 15. Employees Count Salaries
SELECT COUNT(Salary)
FROM Employees
WHERE ManagerID IS NULL

-- 16. *3rd Highest Salary
SELECT DISTINCT DepartmentID, Salary AS [ThirdHighestSalary]
           FROM
               (SELECT DepartmentID, Salary, DENSE_RANK() 
                OVER(PARTITION BY DepartmentID ORDER BY Salary DESC) 
                AS [SalaryRank]
                FROM Employees
			   )AS [RankQuery]
WHERE SalaryRank = 3

-- 17. **Salary Challenge
SELECT TOP(10)
       e1.FirstName,
       e1.LastName,
       e1.DepartmentID
       FROM Employees AS e1
       WHERE e1.Salary > (  
                          SELECT AVG(Salary) AS [AverageSalary] 
                          FROM Employees AS e2
						  WHERE e2.DepartmentID = e1.DepartmentID
                          GROUP BY DepartmentID
			             )
ORDER BY DepartmentID 
