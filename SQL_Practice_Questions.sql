CREATE DATABASE sql_practice;​
USE sql_practice;


CREATE TABLE departments (
    dept_id INT NOT NULL,
    dept_name VARCHAR(50) NOT NULL,
    location VARCHAR(50) NOT NULL,
    PRIMARY KEY (dept_id)
);

CREATE TABLE employees (
    emp_id INT NOT NULL,
    emp_name VARCHAR(50) NOT NULL,
    dept_id INT NOT NULL,
    manager_id INT NULL,
    salary DECIMAL(10,2) NOT NULL,
    hire_date DATE NOT NULL,
    PRIMARY KEY (emp_id),
    FOREIGN KEY (dept_id) REFERENCES departments(dept_id)
);

CREATE TABLE customers (
    customer_id INT NOT NULL,
    customer_name VARCHAR(50) NOT NULL,
    city VARCHAR(50) NOT NULL,
    PRIMARY KEY (customer_id)
);

CREATE TABLE orders (
    order_id INT NOT NULL,
    customer_id INT NOT NULL,
    order_date DATE NOT NULL,
    amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    PRIMARY KEY (order_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

INSERT INTO departments
(dept_id, dept_name, location)
VALUES
(1, 'IT', 'Chennai'),
(2, 'HR', 'Chennai'),
(3, 'Finance', 'Bangalore'),
(4, 'Sales', 'Hyderabad');

INSERT INTO employees
(emp_id, emp_name, dept_id, manager_id, salary, hire_date)
VALUES
(101, 'Arun', 1, NULL, 75000.00, '2022-01-10'),
(102, 'Bala', 1, 101, 60000.00, '2023-03-15'),
(103, 'Charan', 1, 101, 65000.00, '2021-07-20'),
(104, 'Divya', 2, NULL, 55000.00, '2022-08-01'),
(105, 'Esha', 2, 104, 48000.00, '2024-02-12'),
(106, 'Farhan', 3, NULL, 70000.00, '2020-11-05'),
(107, 'Gokul', 3, 106, 52000.00, '2023-06-18'),
(108, 'Hema', 4, NULL, 62000.00, '2021-09-25'),
(109, 'Isha', 4, 108, 45000.00, '2024-01-08'),
(110, 'Jai', 4, 108, 50000.00, '2023-10-10');

INSERT INTO customers
(customer_id, customer_name, city)
VALUES
(1, 'Kumar', 'Chennai'),
(2, 'Lakshmi', 'Bangalore'),
(3, 'Manoj', 'Chennai'),
(4, 'Nisha', 'Hyderabad'),
(5, 'Praveen', 'Coimbatore'),
(6, 'Ravi', 'Chennai');

INSERT INTO orders
(order_id, customer_id, order_date, amount, status)
VALUES
(1001, 1, '2026-01-05', 2500.00, 'Completed'),
(1002, 1, '2026-02-10', 1800.00, 'Completed'),
(1003, 2, '2026-01-15', 3200.00, 'Completed'),
(1004, 3, '2026-02-01', 1500.00, 'Pending'),
(1005, 3, '2026-03-12', 4000.00, 'Completed'),
(1006, 4, '2026-01-20', 2100.00, 'Completed'),
(1007, 4, '2026-03-05', 2800.00, 'Cancelled'),
(1008, 5, '2026-02-18', 1700.00, 'Completed'),
(1009, 6, '2026-03-10', 3500.00, 'Completed'),
(1010, 6, '2026-03-20', 1200.00, 'Pending');


SELECT * FROM departments;

SELECT * FROM employees;

SELECT * FROM customers;

SELECT * FROM orders;


-- =========================================================
-- SQL PRACTICE QUESTIONS
-- CTAS + JOIN + SUBQUERY + WINDOW FUNCTIONS
-- =========================================================


-- =========================================================
-- QUESTION 1
-- [CTAS] Create a new table named high_salary_employees
-- Store emp_id, emp_name, dept_id and salary
-- for employees whose salary is greater than 60000.
-- =========================================================

CREATE TABLE high_salary_employees AS
SELECT
    emp_id,
    emp_name,
    dept_id,
    salary
FROM employees
WHERE salary > 60000;


-- =========================================================
-- QUESTION 2
-- [CTAS] Create a table named chennai_customers
-- containing customers who are from Chennai.
-- =========================================================


CREATE TABLE chennai_customers AS
SELECT
    customer_id,
    customer_name,
    city
FROM customers
WHERE city = 'Chennai';


-- =========================================================
-- QUESTION 3
-- [CTAS] Create a table named department_salary_summary.
-- It should contain each dept_id and the average salary
-- of employees in that department.
-- =========================================================

CREATE TABLE department_salary_summary AS
SELECT
    dept_id,
    AVG(salary) AS average_salary
FROM employees
GROUP BY dept_id;


-- =========================================================
-- QUESTION 4
-- [CTAS] Create a table named completed_orders
-- containing only completed orders.
-- Include order_id, customer_id, order_date and amount.
-- =========================================================

CREATE TABLE completed_orders AS
SELECT
    order_id,
    customer_id,
    order_date,
    amount
FROM orders
WHERE status = 'Completed';


-- =========================================================
-- QUESTION 5
-- [JOIN] Display employee name, department name and salary
-- for every employee.
-- =========================================================

SELECT
    e.emp_name,
    d.dept_name,
    e.salary
FROM employees AS e
INNER JOIN departments AS d
    ON e.dept_id = d.dept_id;


-- =========================================================
-- QUESTION 6
-- [JOIN] Display every department and the employees
-- working in it.
-- Departments with no employees should also appear.
-- =========================================================

SELECT
    d.dept_id,
    d.dept_name,
    e.emp_name
FROM departments AS d
LEFT JOIN employees AS e
    ON d.dept_id = e.dept_id;


-- =========================================================
-- QUESTION 7
-- [JOIN] Display customer name, order id,
-- order date and order amount.
-- =========================================================

SELECT
    c.customer_name,
    o.order_id,
    o.order_date,
    o.amount
FROM customers AS c
INNER JOIN orders AS o
    ON c.customer_id = o.customer_id;


-- =========================================================
-- QUESTION 8
-- [JOIN] Find total order amount for each customer.
-- Display customer name and total amount.
-- Include customers who have placed no orders.
-- =========================================================

SELECT
    c.customer_name,
    COALESCE(SUM(o.amount), 0) AS total_amount
FROM customers AS c
LEFT JOIN orders AS o
    ON c.customer_id = o.customer_id
GROUP BY
    c.customer_id,
    c.customer_name;


-- =========================================================
-- QUESTION 9
-- [JOIN] Self JOIN on employees table.
-- Display each employee's name and their manager's name.
-- Ignore employees who do not have a manager.
-- =========================================================

SELECT
    e.emp_name AS employee_name,
    m.emp_name AS manager_name
FROM employees AS e
INNER JOIN employees AS m
    ON e.manager_id = m.emp_id;


-- =========================================================
-- QUESTION 10
-- [JOIN / SUBQUERY]
-- Find employees whose salary is greater than the
-- average salary of their own department.
-- Display employee name, department id and salary.
-- =========================================================

SELECT
    e.emp_name,
    e.dept_id,
    e.salary
FROM employees AS e
WHERE e.salary > (
    SELECT AVG(e2.salary)
    FROM employees AS e2
    WHERE e2.dept_id = e.dept_id
);


-- =========================================================
-- QUESTION 11
-- [SUBQUERY] Find employee(s) who have the highest salary
-- in the company.
-- =========================================================

SELECT
    emp_id,
    emp_name,
    dept_id,
    salary
FROM employees
WHERE salary = (
    SELECT MAX(salary)
    FROM employees
);


-- =========================================================
-- QUESTION 12
-- [SUBQUERY] Find all employees whose salary is greater
-- than the overall average salary.
-- =========================================================

SELECT
    emp_id,
    emp_name,
    dept_id,
    salary
FROM employees
WHERE salary > (
    SELECT AVG(salary)
    FROM employees
);


-- =========================================================
-- QUESTION 13
-- [SUBQUERY] Find customers who have placed at least
-- one order.
-- Do not use JOIN.
-- =========================================================

SELECT
    customer_id,
    customer_name,
    city
FROM customers
WHERE customer_id IN (
    SELECT customer_id
    FROM orders
);


-- =========================================================
-- QUESTION 14
-- [SUBQUERY] Find the second-highest salary
-- from the employees table.
-- =========================================================

SELECT MAX(salary) AS second_highest_salary
FROM employees
WHERE salary < (
    SELECT MAX(salary)
    FROM employees
);


-- =========================================================
-- QUESTION 15
-- [WINDOW FUNCTION] Display each employee's salary
-- along with the average salary of their department.
-- =========================================================

SELECT
    emp_name,
    dept_id,
    salary,
    AVG(salary) OVER (
        PARTITION BY dept_id
    ) AS department_average_salary
FROM employees;


-- =========================================================
-- QUESTION 16
-- [WINDOW FUNCTION] Rank employees by salary from
-- highest to lowest across the whole company using RANK().
-- =========================================================

SELECT
    emp_name,
    salary,
    RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees;


-- =========================================================
-- QUESTION 17
-- [WINDOW FUNCTION] Rank employees by salary within
-- each department using DENSE_RANK().
-- =========================================================

SELECT
    emp_name,
    dept_id,
    salary,
    DENSE_RANK() OVER (
        PARTITION BY dept_id
        ORDER BY salary DESC
    ) AS department_rank
FROM employees;


-- =========================================================
-- QUESTION 18
-- [WINDOW FUNCTION] For each customer order, display
-- order amount and customer's previous order amount
-- using LAG().
-- Order by customer_id and order_date.
-- =========================================================

SELECT
    customer_id,
    order_id,
    order_date,
    amount,
    LAG(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
    ) AS previous_order_amount
FROM orders
ORDER BY
    customer_id,
    order_date;


-- =========================================================
-- QUESTION 19
-- [WINDOW FUNCTION] Calculate a running total of
-- order amount for each customer.
-- =========================================================

SELECT
    customer_id,
    order_id,
    order_date,
    amount,
    SUM(amount) OVER (
        PARTITION BY customer_id
        ORDER BY order_date
        ROWS BETWEEN UNBOUNDED PRECEDING AND CURRENT ROW
    ) AS running_total
FROM orders
ORDER BY
    customer_id,
    order_date;


-- =========================================================
-- QUESTION 20
-- [MIXED] Find the top 2 highest-paid employees
-- from each department.
-- Use a window function.
-- Return employee name, dept_id, salary and rank.
-- =========================================================

SELECT
    emp_name,
    dept_id,
    salary,
    department_rank
FROM (
    SELECT
        emp_name,
        dept_id,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY dept_id
            ORDER BY salary DESC
        ) AS department_rank
    FROM employees
) AS ranked_employees
WHERE department_rank <= 2
ORDER BY
    dept_id,
    department_rank,
    salary DESC;