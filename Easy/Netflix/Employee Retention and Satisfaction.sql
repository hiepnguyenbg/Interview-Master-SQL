-- Create the database
CREATE DATABASE IF NOT EXISTS employee_retention_satisfaction_db;
USE employee_retention_satisfaction_db;

-- Create the table
CREATE TABLE employee_satisfaction (
  employee_id INT,
  department_id INT,
  job_category_id INT,
  satisfaction_score FLOAT,
  evaluation_date DATE
);

-- Insert the data
INSERT INTO employee_satisfaction (employee_id, department_id, evaluation_date, job_category_id, satisfaction_score) VALUES
(1, 1, '2024-10-15', 1, 4.5),
(2, 1, '2024-10-15', 2, 3.8),
(3, 2, '2024-10-15', 1, 4.2),
(4, 2, '2024-10-15', 3, 3.5),
(5, 3, '2024-10-15', 2, 4.9),
(6, 3, '2024-10-15', 3, 3.7),
(7, 1, '2024-10-15', 1, 4.0),
(8, 2, '2024-10-15', 2, 3.9),
(9, 3, '2024-10-15', 1, 4.6),
(10, 1, '2024-10-15', 3, 3.4);






-- As a member of the Netflix HR team, you are tasked with addressing employee retention challenges by analyzing employee 
-- satisfaction data. Your goal is to identify the average satisfaction scores across different departments and job 
-- categories to pinpoint areas for improvement. By understanding these metrics, your team can develop targeted strategies 
-- to enhance employee engagement and reduce turnover.



-- Question 1: The HR team wants to understand the average satisfaction score of employees across different departments. 
-- Can you provide the average satisfaction score rounded down to the nearest whole number for each department?

SELECT department_id, FLOOR(AVG(satisfaction_score)) AS avg_score
FROM employee_satisfaction
GROUP BY department_id
ORDER BY avg_score DESC;


-- Question 2: In addition to the previous analysis, the HR team is interested in knowing the average satisfaction score 
-- rounded up to the nearest whole number for each job category. Can you calculate this using the same data?

SELECT job_category_id, CEIL(AVG(satisfaction_score)) AS avg_score
FROM employee_satisfaction
GROUP BY job_category_id
ORDER BY avg_score DESC;


-- Question 3: The HR team wants a consolidated report that includes both the rounded down and rounded up average satisfaction 
-- scores for each department and job category. Please rename the columns appropriately to 
-- 'Floor_Avg_Satisfaction' and 'Ceil_Avg_Satisfaction'.


SELECT department_id, job_category_id, 
FLOOR(AVG(satisfaction_score)) AS Floor_Avg_Satisfaction, 
CEIL(AVG(satisfaction_score)) AS Ceil_Avg_Satisfaction
FROM employee_satisfaction
GROUP BY department_id, job_category_id;





