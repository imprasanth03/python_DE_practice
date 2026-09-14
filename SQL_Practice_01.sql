CREATE DATABASE sql_practice1;​
USE sql_practice1;

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

-- LEVEL-1 Null Handling & Basic Window Functiions

-- Q1. Display all employees and replace NULL bonus values with 0 using COALESCE().

SELECT
    emp_name,
    salary,
    COALESCE(bonus, 0) AS bonus
FROM employees;

-- Q2. Display employee name, salary, bonus and total_income.

SELECT
    emp_name,
    salary,
    COALESCE(bonus, 0) AS bonus,
    salary + COALESCE(bonus, 0) AS total_income
FROM employees;

-- Q3. Same as Q2 using IFNULL().

SELECT
    emp_name,
    salary,
    IFNULL(bonus, 0) AS bonus,
    salary + IFNULL(bonus, 0) AS total_income
FROM employees;

-- Q4. NULL manager → Top Level Manager.

SELECT
    emp_name,
    manager_id,
    CASE
        WHEN manager_id IS NULL THEN 'Top Level Manager'
        ELSE 'Reports To Manager'
    END AS manager_status
FROM employees;

-- Q5. Employee salary + department average.

SELECT
    e.emp_name,
    d.dept_name AS department,
    e.salary,
    AVG(e.salary) OVER (
        PARTITION BY e.dept_id
    ) AS department_average_salary
FROM employees AS e
INNER JOIN departments AS d
    ON e.dept_id = d.dept_id;
    
-- Level -2 Ranking

-- Q6. Rank all employees by salary.

SELECT
    emp_name,
    salary,
    RANK() OVER (
        ORDER BY salary DESC
    ) AS salary_rank
FROM employees;

-- Q7. Rank employees within each department.

SELECT
    emp_name,
    dept_id,
    salary,
    RANK() OVER (
        PARTITION BY dept_id
        ORDER BY salary DESC
    ) AS department_rank
FROM employees;

-- Q8. Highest-paid employee in each department.

WITH ranked_employees AS (
    SELECT
        emp_name,
        dept_id,
        salary,
        ROW_NUMBER() OVER (
            PARTITION BY dept_id
            ORDER BY salary DESC
        ) AS rn
    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary
FROM ranked_employees
WHERE rn = 1;

-- Q9. Top 3 highest-paid employees in every department.

WITH ranked_employees AS (
    SELECT
        emp_name,
        dept_id,
        salary,
        DENSE_RANK() OVER (
            PARTITION BY dept_id
            ORDER BY salary DESC
        ) AS department_rank
    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary,
    department_rank
FROM ranked_employees
WHERE department_rank <= 3
ORDER BY dept_id, department_rank;

-- Q10. Compare RANK(), DENSE_RANK(), ROW_NUMBER().

SELECT
    emp_name,
    dept_id,
    salary,

    RANK() OVER (
        PARTITION BY dept_id
        ORDER BY salary DESC
    ) AS rank_number,

    DENSE_RANK() OVER (
        PARTITION BY dept_id
        ORDER BY salary DESC
    ) AS dense_rank_number,

    ROW_NUMBER() OVER (
        PARTITION BY dept_id
        ORDER BY salary DESC
    ) AS row_number
FROM employees
ORDER BY dept_id, salary DESC;

-- LEVEL 3 — SALARY ANALYSIS

-- Q11. Salary difference from department average.
SELECT
    e.emp_name,
    d.dept_name AS department,
    e.salary,

    AVG(e.salary) OVER (
        PARTITION BY e.dept_id
    ) AS department_average_salary,

    e.salary -
    AVG(e.salary) OVER (
        PARTITION BY e.dept_id
    ) AS salary_difference

FROM employees AS e
INNER JOIN departments AS d
    ON e.dept_id = d.dept_id;
    
-- Q12. Salary greater than department average.

WITH salary_analysis AS (
    SELECT
        emp_name,
        dept_id,
        salary,
        AVG(salary) OVER (
            PARTITION BY dept_id
        ) AS department_average
    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary,
    department_average
FROM salary_analysis
WHERE salary > department_average;

-- Q13. Salary less than department average.

WITH salary_analysis AS (
    SELECT
        emp_name,
        dept_id,
        salary,
        AVG(salary) OVER (
            PARTITION BY dept_id
        ) AS department_average
    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary,
    department_average
FROM salary_analysis
WHERE salary < department_average;

-- Q14. Percentage of department total salary.

SELECT
    emp_name,
    dept_id,
    salary,

    ROUND(
        salary * 100.0 /
        SUM(salary) OVER (
            PARTITION BY dept_id
        ),
        2
    ) AS salary_percentage
    
    From employees;
    
-- Q15. Cumulative salary within department.

SELECT
    emp_name,
    dept_id,
    salary,

    SUM(salary) OVER (
        PARTITION BY dept_id
        ORDER BY salary ASC
        ROWS BETWEEN UNBOUNDED PRECEDING
        AND CURRENT ROW
    ) AS cumulative_salary

FROM employees
ORDER BY dept_id, salary ASC;

-- LEVEL 4 — LAG & LEAD

-- Q16. Previous employee salary.

SELECT
    emp_name,
    dept_id,
    salary,

    LAG(salary) OVER (
        PARTITION BY dept_id
        ORDER BY salary
    ) AS previous_salary

FROM employees;
-- Q17. Difference from previous employee salary.

SELECT
    emp_name,
    dept_id,
    salary,

    LAG(salary) OVER (
        PARTITION BY dept_id
        ORDER BY salary
    ) AS previous_salary,

    salary -
    LAG(salary) OVER (
        PARTITION BY dept_id
        ORDER BY salary
    ) AS salary_difference

FROM employees;

-- Q18. Salary greater than previous employee.

WITH salary_comparison AS (
    SELECT
        emp_name,
        dept_id,
        salary,

        LAG(salary) OVER (
            PARTITION BY dept_id
            ORDER BY salary
        ) AS previous_salary

    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary,
    previous_salary
FROM salary_comparison
WHERE previous_salary IS NOT NULL
  AND salary > previous_salary;

-- Q19. Next employee salary.

SELECT
    emp_name,
    dept_id,
    salary,

    LEAD(salary) OVER (
        PARTITION BY dept_id
        ORDER BY salary
    ) AS next_salary

FROM employees;

-- Q20. Salary greater than both previous and next salary.

WITH salary_comparison AS (
    SELECT
        emp_name,
        dept_id,
        salary,

        LAG(salary) OVER (
            PARTITION BY dept_id
            ORDER BY salary
        ) AS previous_salary,

        LEAD(salary) OVER (
            PARTITION BY dept_id
            ORDER BY salary
        ) AS next_salary

    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary,
    previous_salary,
    next_salary
FROM salary_comparison
WHERE previous_salary IS NOT NULL
  AND next_salary IS NOT NULL
  AND salary > previous_salary
  AND salary > next_salary;
  
-- LEVEL 5 — CTE + WINDOW FUNCTIONS

-- Q21. CTE employee_salary.

WITH employee_salary AS (
    SELECT
        emp_name,
        dept_id,
        salary,

        AVG(salary) OVER (
            PARTITION BY dept_id
        ) AS department_average

    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary,
    department_average
FROM employee_salary
WHERE salary > department_average;

-- Q22. Highest-paid employee from every department.

WITH ranked_employees AS (
    SELECT
        emp_name,
        dept_id,
        salary,

        ROW_NUMBER() OVER (
            PARTITION BY dept_id
            ORDER BY salary DESC
        ) AS rn

    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary
FROM ranked_employees
WHERE rn = 1;

-- Q23. Second-highest salary in each department.

WITH ranked_employees AS (
    SELECT
        emp_name,
        dept_id,
        salary,

        DENSE_RANK() OVER (
            PARTITION BY dept_id
            ORDER BY salary DESC
        ) AS salary_rank

    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary
FROM ranked_employees
WHERE salary_rank = 2;

-- Q24. Third-highest employee in every department.

WITH ranked_employees AS (
    SELECT
        emp_name,
        dept_id,
        salary,

        DENSE_RANK() OVER (
            PARTITION BY dept_id
            ORDER BY salary DESC
        ) AS salary_rank

    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary,
    salary_rank
FROM ranked_employees
WHERE salary_rank = 3;

-- Q25. Top 5 employees based on total income.

WITH employee_income AS (
    SELECT
        emp_name,
        dept_id,
        salary,
        bonus,

        salary + COALESCE(bonus, 0) AS total_income

    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary,
    bonus,
    total_income
FROM employee_income
ORDER BY total_income DESC
LIMIT 5;

-- LEVEL 6 — ADVANCED PRACTICE

-- Q26. Top 2 employees by performance score.

WITH ranked_employees AS (
    SELECT
        emp_name,
        dept_id,
        salary,
        performance_score,

        DENSE_RANK() OVER (
            PARTITION BY dept_id
            ORDER BY performance_score DESC,
                     salary DESC
        ) AS performance_rank

    FROM employees
    WHERE performance_score IS NOT NULL
)
SELECT
    emp_name,
    dept_id,
    salary,
    performance_score,
    performance_rank
FROM ranked_employees
WHERE performance_rank <= 2
ORDER BY dept_id, performance_rank;

-- Q27. Performance score greater than department average.

WITH performance_analysis AS (
    SELECT
        emp_name,
        dept_id,
        performance_score,

        AVG(performance_score) OVER (
            PARTITION BY dept_id
        ) AS department_average_score

    FROM employees
    WHERE performance_score IS NOT NULL
)
SELECT
    emp_name,
    dept_id,
    performance_score,
    department_average_score
FROM performance_analysis
WHERE performance_score > department_average_score;
WHERE performance_score > department_average_score;

-- Q28. Employees contributing more than 10% of department salary.

WITH salary_analysis AS (
    SELECT
        emp_name,
        dept_id,
        salary,

        SUM(salary) OVER (
            PARTITION BY dept_id
        ) AS department_salary,

        salary * 100.0 /
        SUM(salary) OVER (
            PARTITION BY dept_id
        ) AS salary_percentage

    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary,
    department_salary,
    ROUND(salary_percentage, 2) AS salary_percentage
FROM salary_analysis
WHERE salary_percentage > 10;

-- Q29. Salary higher than previous but lower than next.

WITH salary_comparison AS (
    SELECT
        emp_name,
        dept_id,
        salary,

        LAG(salary) OVER (
            PARTITION BY dept_id
            ORDER BY salary
        ) AS previous_salary,

        LEAD(salary) OVER (
            PARTITION BY dept_id
            ORDER BY salary
        ) AS next_salary

    FROM employees
)
SELECT
    emp_name,
    dept_id,
    salary,
    previous_salary,
    next_salary
FROM salary_comparison
WHERE previous_salary IS NOT NULL
  AND next_salary IS NOT NULL
  AND salary > previous_salary
  AND salary < next_salary;
  
-- Q30 — FINAL CHALLENGE 

-- Top 3 employees from each department based on total compensation.

WITH employee_compensation AS (
    SELECT
        emp_name,
        dept_id,
        salary,
        bonus,

        salary + COALESCE(bonus, 0) AS total_compensation

    FROM employees
),

ranked_employees AS (
    SELECT
        emp_name,
        dept_id,
        salary,
        bonus,
        total_compensation,

        DENSE_RANK() OVER (
            PARTITION BY dept_id
            ORDER BY total_compensation DESC
        ) AS compensation_rank

    FROM employee_compensation
)

SELECT
    emp_name,
    dept_id,
    salary,
    bonus,
    total_compensation,
    compensation_rank
FROM ranked_employees
WHERE compensation_rank <= 3
ORDER BY
    dept_id,
    compensation_rank;