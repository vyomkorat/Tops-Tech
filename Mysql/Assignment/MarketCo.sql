-- Create database
CREATE DATABASE MarketCo;

-- Create Company table
CREATE TABLE Company (
    CompanyID INT PRIMARY KEY,
    CompanyName VARCHAR(45),
    Street VARCHAR(45),
    City VARCHAR(45),
    State VARCHAR(2),
    Zip VARCHAR(10)
);

-- 2) Statement to create the Employee table
CREATE TABLE Employee (
    EmployeeID VARCHAR(10) PRIMARY KEY,
    FirstName VARCHAR(45),
    LastName VARCHAR(45),
    Salary DECIMAL(10,2),
    HireDate DATE,
    JobTitle VARCHAR(25),
    Email VARCHAR(45),
    Phone VARCHAR(12)
);

-- 1) Statement to create the Contact table
CREATE TABLE Contact (
    ContactID INT PRIMARY KEY,
    CompanyID INT,
    FirstName VARCHAR(45),
    LastName VARCHAR(45),
    Street VARCHAR(45),
    City VARCHAR(45),
    State VARCHAR(2),
    Zip VARCHAR(10),
    IsMain BOOLEAN,
    Email VARCHAR(45),
    Phone VARCHAR(12),
    FOREIGN KEY (CompanyID) REFERENCES Company(CompanyID)
);

-- 3) Statement to create the ContactEmployee table
CREATE TABLE ContactEmployee (
    ContactEmployeeID VARCHAR(10) PRIMARY KEY,
    ContactID INT,
    EmployeeID VARCHAR(10),
    ContactDate DATE,
    Description VARCHAR(100),
    FOREIGN KEY (ContactID) REFERENCES Contact(ContactID),
    FOREIGN KEY (EmployeeID) REFERENCES Employee(EmployeeID)
);

-- Insert values into Company table
INSERT INTO Company (CompanyID, CompanyName, Street, City, State, Zip) VALUES
(101, 'Urban Outfitters, Inc.', '350 North Street', 'Philadelphia', 'PA', '19107'),
(102, 'Toll Brothers', '470 W Broad Street', 'Horsham', 'PA', '19044'),
(103, 'Comcast Corporation', '1701 JFK Blvd', 'Philadelphia', 'PA', '19103'),
(104, 'Kuhlman, Coleman and Rios', '27080 Logan Run Apt. 745', 'East Joestad', 'UT', '30649'),
(105, 'Smith LLC', '5747 Bernier Hollow Apt. 748', 'Port Jacobstad', 'VA', '38209'),
(106, 'Rowe LLC', '981 Rice Ports', 'Georgetown', 'VA', '04328'),
(107, 'Romero, Daniel and Harmon', '51099 Caleb Views', 'South Danielle', 'ID', '27078'),
(108, 'Stone, Tran and Norman', '35130 Laurie Locks Suite 648', 'Jonesmouth', 'OH', '78970');

-- insert values into Employee table
INSERT INTO Employee (EmployeeID, FirstName, LastName, Salary, HireDate, JobTitle, Email, Phone) VALUES
('xyz1', 'Jack', 'Lee', 65000.00, '2020-03-01', 'Account Manager', 'jlee@company.com', '215-555-4321'),
('xyz2', 'Lesley', 'Bland', 75000.00, '2019-06-15', 'Sales Rep', 'lbland@company.com', '215-555-8800'),
('xyz3', 'Emma', 'Wilson', 82000.00, '2021-07-10', 'Analyst', 'emma.wilson@example.com', '654-555-7890'),
('xyz4', 'Carolyn', 'Lewis', 61000.00, '2018-09-12', 'Support Lead', 'clewis@example.com', '452-555-9090'),
('xyz5', 'Joshua', 'Scott', 70000.00, '2020-11-05', 'Sales Rep', 'jscott@example.com', '333-555-1010'),
('xyz6', 'Ashley', 'Taylor', 90000.00, '2019-01-25', 'Consultant', 'ataylor@example.com', '646-555-1414'),
('xyz7', 'Michael', 'Evans', 94000.00, '2022-03-10', 'Analyst', 'mevans@example.com', '646-555-1551'),
('xyz8', 'Olivia', 'Mitchell', 58000.00, '2020-04-18', 'Support Lead', 'omitchell@example.com', '789-555-3412'),
('xyz9', 'David', 'Campbell', 78000.00, '2021-06-23', 'Sales Rep', 'dcampbell@example.com', '645-555-2310'),
('xyz10', 'Sophia', 'Green', 83000.00, '2020-10-09', 'Tech Consultant', 'sgreen@example.com', '234-555-8723'),
('xyz11', 'Daniel', 'Perry', 86000.00, '2019-02-11', 'Account Manager', 'dperry@example.com', '721-555-9182'),
('xyz12', 'Emily', 'James', 91500.00, '2023-01-19', 'Analyst', 'ejames@example.com', '423-555-3129');


-- insert value into Contact table
INSERT INTO Contact (ContactID, CompanyID, FirstName, LastName, Street, City, State, Zip, IsMain, Email, Phone) VALUES
(1001, 101, 'Dianne', 'Connor', '501 Market Street', 'Philadelphia', 'PA', '19106', TRUE, 'dconnor@urban.com', '215-555-1212'),
(1002, 102, 'Martin', 'Lee', '128 Walnut Lane', 'Horsham', 'PA', '19044', FALSE, 'mlee@tollbrothers.com', '215-555-2233'),
(1003, 103, 'Sandra', 'Nguyen', '2400 Arch Street', 'Philadelphia', 'PA', '19103', TRUE, 'snguyen@comcast.com', '215-555-3344'),
(1004, 104, 'Margaret', 'Wright', '27080 Logan Run Apt. 745', 'East Joestad', 'UT', '30649', FALSE, 'wright@example.com', '789-555-0192'),
(1005, 105, 'Danielle', 'Simmons', '5747 Bernier Hollow Apt. 748', 'Port Jacobstad', 'VA', '38209', TRUE, 'dsimmons@example.com', '646-555-5677'),
(1006, 106, 'Jennifer', 'Gonzalez', '981 Rice Ports', 'Georgetown', 'VA', '04328', TRUE, 'jennifer.g@example.com', '789-555-1122'),
(1007, 107, 'Christopher', 'Smith', '51099 Caleb Views', 'South Danielle', 'ID', '27078', FALSE, 'csmith@example.com', '654-555-9234'),
(1008, 108, 'Sarah', 'Lee', '35130 Laurie Locks Suite 648', 'Jonesmouth', 'OH', '78970', TRUE, 'sarah.lee@example.com', '756-555-4399'),
(1009, 101, 'Jacob', 'Morgan', '101 North Broad', 'Philadelphia', 'PA', '19107', FALSE, 'jmorgan@urban.com', '215-555-7766'),
(1010, 102, 'Rachel', 'Stone', '420 City Ave', 'Horsham', 'PA', '19044', FALSE, 'rstone@tollbrothers.com', '215-555-8899'),
(1011, 102, 'Ben', 'Turner', '525 Main Blvd', 'Horsham', 'PA', '19044', FALSE, 'bturner@tollbrothers.com', '215-555-9090'),
(1012, 106, 'Karen', 'Vega', '9327 Elm Court', 'Georgetown', 'VA', '04328', FALSE, 'kvega@example.com', '876-555-6744');

-- insert value contactemployee
INSERT INTO ContactEmployee (ContactEmployeeID, ContactID, EmployeeID, ContactDate, Description) VALUES
('abc1', 1001, 'xyz1', '2024-07-01', 'Dianne Connor contacted Jack Lee.'),
('abc2', 1003, 'xyz3', '2024-05-15', 'Requested broadband services.'),
('abc3', 1004, 'xyz4', '2024-03-01', 'Initial sales inquiry.'),
('abc4', 1005, 'xyz5', '2024-02-18', 'Support call follow-up.'),
('abc5', 1006, 'xyz6', '2024-03-25', 'Consultation on system upgrade.'),
('abc6', 1007, 'xyz7', '2024-04-20', 'Analyzed data performance.'),
('abc7', 1008, 'xyz8', '2024-06-11', 'Resolved product return issue.'),
('abc8', 1009, 'xyz9', '2024-07-09', 'General inquiry.'),
('abc9', 1010, 'xyz10', '2024-01-22', 'Discussed warranty coverage.'),
('abc10', 1011, 'xyz11', '2024-03-30', 'Scheduled follow-up.');

-- 4) In the Employee table, the statement that changes Lesley Bland's phone number to 215-555-8300
UPDATE Employee 
SET Phone = '215-555-8300' 
WHERE EmployeeID = (SELECT EmployeeID FROM (SELECT EmployeeID FROM Employee WHERE FirstName = 'Lesley' AND LastName = 'Bland') AS temp);

-- 5) In the Company table, the statement that changes the name of "Urban Outfitters, Inc." to "Urban Outfitters"
UPDATE Company 
SET CompanyName = 'Urban Outfitters' 
WHERE CompanyID = (SELECT CompanyID FROM (SELECT CompanyID FROM Company WHERE CompanyName = 'Urban Outfitters, Inc.') AS temp);

-- 6) In ContactEmployee table, the statement that removes Dianne Connor's contact event with Jack Lee
-- HINT: Use the primary key of the ContactEmployee table to specify the correct record to remove
DELETE FROM ContactEmployee 
WHERE ContactEmployeeID = (
    SELECT ContactEmployeeID FROM (
        SELECT ce.ContactEmployeeID 
        FROM ContactEmployee ce
        JOIN Contact c ON ce.ContactID = c.ContactID
        JOIN Employee e ON ce.EmployeeID = e.EmployeeID
        WHERE c.FirstName = 'Dianne' AND c.LastName = 'Connor'
        AND e.FirstName = 'Jack' AND e.LastName = 'Lee'
    ) AS temp 
);

-- 7) Write the SQL SELECT query that displays the names of the employees that have contacted Toll Brothers
SELECT DISTINCT e.FirstName, e.LastName
FROM Employee e
JOIN ContactEmployee ce ON e.EmployeeID = ce.EmployeeID
JOIN Contact c ON ce.ContactID = c.ContactID
JOIN Company comp ON c.CompanyID = comp.CompanyID
WHERE comp.CompanyName = 'Toll Brothers';