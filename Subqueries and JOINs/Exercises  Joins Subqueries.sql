-- 1.Employee Address
SELECT TOP(5) EmployeeID, JobTitle, e.AddressID, AddressText  FROM Employees AS e
JOIN Addresses AS a ON a.AddressID  = e.AddressID
ORDER BY AddressID ASC

-- 2.Addresses with Towns
SELECT TOP(50) FirstName, LastName, t.Name, AddressText FROM Employees AS e
JOIN Addresses AS a ON a.AddressID  = e.AddressID
JOIN Towns AS t ON t.TownID = a.TownID
ORDER BY FirstName ASC, LastName

-- 3.Sales Employee
SELECT EmployeeID, FirstName, LastName, d.Name FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = E.DepartmentID
WHERE d.Name = 'Sales'
ORDER BY EmployeeID ASC

-- 4.Employee Departments
SELECT TOP(5) EmployeeID, FirstName, Salary, d.Name FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE e.Salary > 15000
ORDER BY e.DepartmentID ASC

-- 5.Employees Without Project
SELECT TOP(3) e.EmployeeID, FirstName
FROM Employees AS e
LEFT JOIN EmployeesProjects AS ep ON ep.EmployeeID = e.EmployeeID
LEFT JOIN Projects AS p ON p.ProjectID = ep.ProjectID
WHERE ep.ProjectID IS NULL
ORDER BY e.EmployeeID ASC

-- 6.Employees Hired After
SELECT FirstName, LastName, HireDate, d.Name
FROM Employees AS e
JOIN Departments AS d ON d.DepartmentID = e.DepartmentID
WHERE e.HireDate > DATEPART(YEAR, '1999-01-01') 
AND d.Name IN ('Finance', 'Sales')
ORDER BY HireDate
