-- 1. Create the database
CREATE DATABASE IF NOT EXISTS code_suggestions_quality_db;
USE code_suggestions_quality_db;

-- 2. Create the table
CREATE TABLE fct_code_suggestions (
    suggestion_id INT PRIMARY KEY,
    developer_id INT,
    programming_language VARCHAR(50),
    complexity_level VARCHAR(20),
    coding_speed_improvement DECIMAL(5,2),
    error_reduction_percentage DECIMAL(5,2),
    suggestion_date DATE
);

-- 3. Insert the data
INSERT INTO fct_code_suggestions 
(suggestion_id, developer_id, suggestion_date, complexity_level, programming_language, coding_speed_improvement, error_reduction_percentage)
VALUES 
(1, 101, '2024-04-03', 'Easy', 'Python', 12.5, 18),
(2, 102, '2024-04-05', 'Medium', 'Python', 10, 17.5),
(3, 103, '2024-04-07', 'Hard', 'Python', 9, 15),
(4, 104, '2024-04-02', 'Easy', 'JavaScript', 14, 13),
(5, 101, '2024-04-08', 'Medium', 'JavaScript', 16.5, 14.5),
(6, 105, '2024-04-12', 'Hard', 'JavaScript', 15, 12),
(7, 106, '2024-04-03', 'Easy', 'Java', 11, 16),
(8, 107, '2024-04-06', 'Medium', 'Java', 13, 20),
(9, 108, '2024-04-10', 'Hard', 'Java', 12, 19.5),
(10, 109, '2024-04-04', 'Easy', 'C++', 8, 14),
(11, 110, '2024-04-09', 'Medium', 'C++', 7.5, 11),
(12, 105, '2024-04-11', 'Hard', 'C++', 9.5, 16),
(13, 111, '2024-04-15', 'Medium', 'Python', 15, 19),
(14, 112, '2024-04-16', 'Easy', 'JavaScript', 18, 16),
(15, 113, '2024-04-18', 'Medium', 'Java', 17, 21);




-- You are a Product Analyst on the OpenAI Codex team, focusing on optimizing AI-driven code suggestions. 
-- Your team aims to enhance developer productivity by improving coding speed and reducing errors across 
-- various programming languages. By analyzing current performance metrics, you will identify areas for 
-- improvement and validate the effectiveness of existing code suggestions.




-- Question 1: What is the average coding speed improvement percentage for each programming language in April 2024? 
-- This analysis will help us determine if current suggestions are effectively boosting coding speed.


SELECT 
  programming_language, 
  ROUND(AVG(coding_speed_improvement), 2) AS avg_improvement
FROM fct_code_suggestions
WHERE suggestion_date BETWEEN '2024-04-01' AND '2024-04-30'
GROUP BY programming_language;



-- Question 2: For each programming language in April 2024, what is the minimum error reduction percentage observed 
-- across all AI-driven code suggestions? This will help pinpoint languages where error reduction is lagging and 
-- may need targeted improvements.


SELECT 
  programming_language, 
  MIN(error_reduction_percentage) AS min_error
FROM fct_code_suggestions
WHERE suggestion_date BETWEEN '2024-04-01' AND '2024-04-30'
GROUP BY programming_language;



-- Question 3: For April 2024, first concatenate the programming language and complexity level to form a unique identifier. 
-- Then, using the average of coding speed improvement and error reduction percentage as a combined metric, which 
-- concatenated combination shows the highest aggregated improvement? This final analysis directly informs efforts 
-- to achieve a targeted increase in developer productivity and error reduction.

SELECT 
  CONCAT(programming_language, ' ', complexity_level) AS identifier,
  ROUND(AVG((coding_speed_improvement + error_reduction_percentage) / 2), 2) AS avg_combined_metric
FROM fct_code_suggestions
WHERE suggestion_date BETWEEN '2024-04-01' AND '2024-04-30'
GROUP BY identifier
ORDER BY avg_combined_metric DESC
LIMIT 1;




