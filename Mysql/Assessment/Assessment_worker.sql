create database worker;

-- Create the Worker table
CREATE TABLE Worker (
    WORKER_ID INT PRIMARY KEY,
    FIRST_NAME VARCHAR(50),
    LAST_NAME VARCHAR(50),
    SALARY DECIMAL(10,2),
    JOINING_DATE DATETIME,
    DEPARTMENT VARCHAR(50)
);

-- Insert sample data
INSERT INTO Worker (WORKER_ID, FIRST_NAME, LAST_NAME, SALARY, JOINING_DATE, DEPARTMENT) VALUES
(1, 'Monika', 'Arora', 100000, '2014-02-20 09:00:00', 'HR'),
(2, 'Niharika', 'Verma', 80000, '2014-06-11 09:00:00', 'Admin'),
(3, 'Vishal', 'Singhal', 300000, '2014-02-20 09:00:00', 'HR'),
(4, 'Amitabh', 'Singh', 500000, '2014-02-20 09:00:00', 'Admin'),
(5, 'Vivek', 'Bhati', 500000, '2014-06-11 09:00:00', 'Admin'),
(6, 'Vipul', 'Diwan', 200000, '2014-06-11 09:00:00', 'Account'),
(7, 'Satish', 'Kumar', 75000, '2014-01-20 09:00:00', 'Account'),
(8, 'Geetika', 'Chauhan', 90000, '2014-04-11 09:00:00', 'Admin');

-- 1. Write an SQL query to print all Worker details from the Worker table order by FIRST_NAME Ascending and DEPARTMENT Descending.
SELECT * FROM Worker 
ORDER BY FIRST_NAME ASC, DEPARTMENT DESC;

-- 2. Write an SQL query to print details for Workers with the first names "Vipul" and "Satish" from the Worker table.
SELECT * FROM Worker 
WHERE FIRST_NAME IN ('Vipul', 'Satish');

-- 3. Write an SQL query to print details of the Workers whose FIRST_NAME ends with 'h' and contains six alphabets.
SELECT * FROM Worker 
WHERE FIRST_NAME LIKE '_____h' AND LENGTH(FIRST_NAME) = 6;

-- 4. Write an SQL query to print details of the Workers whose SALARY lies between 1.
SELECT * FROM Worker 
WHERE SALARY BETWEEN 100000 AND 500000;

-- 5. Write an SQL query to fetch duplicate records having matching data in some fields of a table.
SELECT w1.* FROM Worker w1
INNER JOIN (
    SELECT SALARY 
    FROM Worker 
    GROUP BY SALARY 
    HAVING COUNT(*) > 1
) w2 ON w1.SALARY = w2.SALARY
ORDER BY w1.SALARY;

-- 6. Write an SQL query to show the top 6 records of a table.
SELECT * FROM Worker 
LIMIT 6;

-- 7. Write an SQL query to fetch the departments that have less than five people in them.
SELECT DEPARTMENT, COUNT(*) as employee_count
FROM Worker 
GROUP BY DEPARTMENT 
HAVING COUNT(*) < 5;

-- 8. Write an SQL query to show all departments along with the number of people in there.
SELECT DEPARTMENT, COUNT(*) as employee_count
FROM Worker 
GROUP BY DEPARTMENT 
ORDER BY employee_count DESC;

-- 9. Write an SQL query to print the name of employees having the highest salary in each department.
SELECT w1.FIRST_NAME, w1.LAST_NAME, w1.DEPARTMENT, w1.SALARY
FROM Worker w1
INNER JOIN (
    SELECT DEPARTMENT, MAX(SALARY) as max_salary
    FROM Worker 
    GROUP BY DEPARTMENT
) w2 ON w1.DEPARTMENT = w2.DEPARTMENT AND w1.SALARY = w2.max_salary
ORDER BY w1.DEPARTMENT;