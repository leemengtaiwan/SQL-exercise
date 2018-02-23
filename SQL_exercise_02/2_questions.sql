-- LINK : https://en.wikibooks.org/wiki/SQL_Exercises/Employee_management
-- 2.1 Select the last name of all employees.
SELECT LastName FROM Employees;

-- 2.2 Select the last name of all employees, without duplicates.
SELECT DISTINCT LastName FROM Employees;

-- 2.3 Select all the data of employees whose last name is "Smith".
SELECT * FROM Employees
WHERE LastName = 'Smith';

-- 2.4 Select all the data of employees whose last name is "Smith" or "Doe".
SELECT * FROM Employees
WHERE LastName = 'Smith' OR LastName = 'Doe';

SELECT * FROM Employees
WHERE LastName IN ('Smith', 'Doe');

-- 2.5 Select all the data of employees that work in department 14.
SELECT * FROM Employees
WHERE Department = 14;

-- 2.6 Select all the data of employees that work in department 37 or department 77.
SELECT * FROM Employees
WHERE Department IN (37, 77);

-- 2.7 Select all the data of employees whose last name begins with an "S".
SELECT * FROM Employees
WHERE LastName LIKE 'S%';

-- 2.8 Select the sum of all the departments' budgets.
SELECT SUM(Budget) FROM Departments;

-- 2.9 Select the number of employees in each department (you only need to show the department code and the number of employees).
SELECT department, COUNT(*) AS Num_Employees
FROM Employees
GROUP BY department;

-- 2.10 Select all the data of employees, including each employee's department's data.
SELECT *
FROM Employees E INNER JOIN Departments D
ON E.Department = D.Code;

-- 2.11 Select the name and last name of each employee, along with the name and budget of the employee's department.
SELECT E.Name AS E_Name, E.LastName AS E_LastName,
        D.Name AS D_Name, D.Budget
FROM Employees E, Departments D
WHERE E.Department = D.Code;

-- 2.12 Select the name and last name of employees working for departments with a budget greater than $60,000.
-- JOIN ver
SELECT E.Name AS E_Name, E.LastName AS E_LastName
FROM Employees E, Departments D
WHERE E.Department = D.Code AND D.Budget > 60000;

-- Subquery ver
SELECT Name, Lastname
FROM Employees E
WHERE E.Department IN
  (
    SELECT Code
    FROM Departments D
    WHERE D.Budget > 60000
  );

-- 2.13 Select the departments with a budget larger than the average budget of all the departments.
SELECT *
FROM Departments
WHERE Budget > (SELECT AVG(Budget) FROM Departments);

-- 2.14 Select the names of departments with more than two employees.
-- JOIN ver
SELECT D.Name
FROM Departments D, Employees E
WHERE D.Code = E.Department
GROUP BY E.Department
HAVING COUNT(*) > 2;

-- Subquery ver
SELECT Name FROM Departments
  WHERE Code IN
  (
    SELECT Department
      FROM Employees
      GROUP BY Department
      HAVING COUNT(*) > 2
  );

-- 2.15 Very Important - Select the name and last name of employees working for departments with second lowest budget.
-- 自己寫的畫蛇添足版 subquery , 其實根本不用 JOIN 的 part!
SELECT E.Name, E.LastName
FROM Employees E, Departments D
WHERE E.Department = D.Code
  AND D.Code =
  (
    SELECT Code FROM Departments
    WHERE Budget > (SELECT MIN(Budget) FROM Departments)
    ORDER BY Budget
    LIMIT 1
  );

-- 改善版：純 subquery
SELECT E.Name, E.LastName
FROM Employees E
WHERE E.Department =
  (
    SELECT Code FROM Departments
    WHERE Budget > (SELECT MIN(Budget) FROM Departments)
    ORDER BY Budget
    LIMIT 1
  );

-- 2.16  Add a new department called "Quality Assurance", with a budget of $40,000 and departmental code 11.
-- And Add an employee called "Mary Moore" in that department, with SSN 847-21-9811.

INSERT INTO Departments(Code, Name, Budget)
  VALUES (11, 'Quality Assurance', 40000);

INSERT INTO Employees(SSN, Name, LastName, Department)
  VALUES (847219811, 'Mary', 'Moore', 11);

-- 2.17 Reduce the budget of all departments by 10%.
UPDATE Departments SET Budget = Budget * 0.9;

-- 2.18 Reassign all employees from the Research department (code 77) to the IT department (code 14).
UPDATE Employees SET Department = 14 WHERE Department = 77;

-- 2.19 Delete from the table all employees in the IT department (code 14).
DELETE FROM Employees
  WHERE Department = 14;

-- 2.20 Delete from the table all employees who work in departments with a budget greater than or equal to $60,000.
DELETE FROM Employees
  WHERE Department IN
  (
    SELECT Code FROM Departments
      WHERE Budget >= 60000
  );

-- 2.21 Delete from the table all employees.
DELETE FROM Employees;