-- Create database
CREATE DATABASE IF NOT EXISTS pro_content_creator_mac_usage_db;
USE pro_content_creator_mac_usage_db;

-- Drop table if it exists
DROP TABLE IF EXISTS fct_multimedia_usage;

-- Create table
CREATE TABLE fct_multimedia_usage (
    user_id INT,
    usage_date DATE,
    hours_spent DECIMAL(5,2)
);

-- Insert data
INSERT INTO fct_multimedia_usage (user_id, usage_date, hours_spent) VALUES
(101, '2024-07-31', 2.3),
(102, '2024-07-31', 3.0),
(103, '2024-07-31', 1.5),
(101, '2024-07-30', 1.0),
(104, '2024-07-29', 4.0),
(105, '2024-07-31', 2.0),
(101, '2024-08-01', 3.4),
(102, '2024-08-01', 2.6),
(103, '2024-08-02', 5.0),
(104, '2024-08-03', 1.0),
(102, '2024-08-05', 4.5),
(105, '2024-08-05', 3.5),
(106, '2024-08-07', 2.0),
(107, '2024-08-07', 6.0),
(101, '2024-09-01', 3.0),
(102, '2024-09-01', 2.0),
(103, '2024-09-02', 1.5),
(104, '2024-09-02', 3.5),
(105, '2024-09-03', 4.0),
(106, '2024-09-03', 2.0),
(107, '2024-09-03', 1.0),
(108, '2024-09-04', 7.0),
(109, '2024-09-04', 2.0),
(101, '2024-09-04', 1.0),
(110, '2024-09-05', 5.0),
(111, '2024-09-05', 4.0),
(112, '2024-09-05', 3.0);



-- As a Product Analyst on the Mac software team, you are tasked with understanding user engagement with multimedia 
-- tools. Your team aims to identify key usage patterns and determine how much time users spend on these tools. The 
-- end goal is to use these insights to enhance product features and improve user experience.


-- Question 1: As a Product Analyst on the Mac software team, you need to understand the engagement of professional 
-- content creators with multimedia tools. What is the number of distinct users on the last day in July 2024?


SELECT COUNT(DISTINCT user_id) AS n_user
FROM fct_multimedia_usage
WHERE usage_date = '2024-07-31';


-- Question 2: As a Product Analyst on the Mac software team, you are assessing how much time professional content 
-- creators spend using multimedia tools. What is the average number of hours spent by users during August 2024? 
-- Round the result up to the nearest whole number.

WITH total_hours AS (
  SELECT user_id, SUM(hours_spent) AS hours_spent
  FROM fct_multimedia_usage
  WHERE usage_date BETWEEN '2024-08-01' AND '2024-08-31'
  GROUP BY user_id
)
SELECT CEIL(AVG(hours_spent)) AS avg_hours_spent
FROM total_hours;


-- Question 3: As a Product Analyst on the Mac software team, you are investigating exceptional daily usage patterns 
-- in September 2024. For each day, determine the distinct user count and the total hours spent using multimedia tools. 
-- Which days have both metrics above the respective average daily values for September 2024?

WITH daily_usage AS (
  SELECT 
    usage_date, 
    COUNT(DISTINCT user_id) AS n_user, 
    SUM(hours_spent) AS hours_spent
  FROM fct_multimedia_usage
  WHERE usage_date BETWEEN '2024-09-01' AND '2024-09-30'
  GROUP BY usage_date
)
SELECT *
FROM daily_usage
WHERE n_user > (SELECT AVG(n_user) FROM daily_usage)
  AND hours_spent > (SELECT AVG(hours_spent) FROM daily_usage);


