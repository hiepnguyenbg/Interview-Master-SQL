-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS user_engagement_search_quality_db;
USE user_engagement_search_quality_db;

-- Step 2: Create the `users` table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100),
    signup_date DATE
);

-- Step 3: Create the `search_queries` table
CREATE TABLE search_queries (
    query_id INT PRIMARY KEY,
    user_id INT,
    clicks BOOLEAN,
    dwell_time_seconds INT,
    query_date DATE,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Step 4: Insert data into `users`
INSERT INTO users (user_id, user_name, signup_date) VALUES
(1, 'Alice Smith', '2024-10-02'),
(2, 'Bob Johnson', '2024-10-05'),
(3, 'Carol Williams', '2024-10-10'),
(4, 'David Brown', '2024-10-15'),
(5, 'Eva Davis', '2024-10-20'),
(6, 'Frank Miller', '2024-10-25'),
(7, 'Grace Wilson', '2024-10-28'),
(8, 'Henry Moore', '2024-10-30'),
(9, 'Irene Taylor', '2024-10-12'),
(10, 'Jack Anderson', '2024-10-18'),
(11, 'Liam Edwards', '2024-09-05'),
(12, 'Sophia Martinez', '2024-09-15'),
(13, 'Oliver Clark', '2024-11-01'),
(14, 'Mia Walker', '2024-11-10');

-- Step 5: Insert data into `search_queries`
INSERT INTO search_queries (query_id, user_id, clicks, dwell_time_seconds, query_date) VALUES
(1, 1, 1, 45, '2024-10-03'),
(2, 2, 0, 25, '2024-10-06'),
(3, 3, 1, 35, '2024-10-11'),
(4, 4, 0, 15, '2024-10-16'),
(5, 5, 1, 50, '2024-10-21'),
(6, 6, 0, 40, '2024-10-26'),
(7, 7, 1, 20, '2024-10-29'),
(8, 8, 0, 10, '2024-10-31'),
(9, 9, 1, 60, '2024-10-13'),
(10, 10, 0, 5, '2024-10-19'),
(11, 1, 0, 31, '2024-10-04'),
(12, 2, 1, 29, '2024-10-07'),
(13, 3, 0, 45, '2024-10-12'),
(14, 4, 1, 50, '2024-10-17'),
(15, 5, 0, 20, '2024-10-22'),
(16, 6, 1, 10, '2024-10-27'),
(17, 7, 0, 35, '2024-10-30'),
(18, 8, 1, 55, '2024-10-30'),
(19, 9, 0, 15, '2024-10-14'),
(20, 10, 1, 40, '2024-10-20'),
(21, 11, 1, 35, '2024-09-06'),
(22, 12, 0, 45, '2024-09-18'),
(23, 13, 1, 20, '2024-11-03'),
(24, 14, 0, 30, '2024-11-12');



-- As a Data Analyst on the Google Search Quality team, you are tasked with understanding user engagement with search results. 
-- Your goal is to analyze how different user interactions, such as clicking on links and spending time on the results page, 
-- impact overall satisfaction. By leveraging query data, your team aims to identify areas for improving search result 
-- relevance and enhancing the user experience.




-- Question 1: How many search queries were made by users who either clicked on a link or spent more than 30 seconds on 
-- the search results page in October 2024?

SELECT COUNT(query_id) AS n_queries
FROM search_queries
WHERE (clicks = 1 OR dwell_time_seconds > 30)
  AND query_date BETWEEN '2024-10-01' AND '2024-10-31';




-- Question 2: Can you find out how many search queries in October 2024 were made by users who clicked on a link and 
-- spent more than 30 seconds on the search results page?


SELECT COUNT(query_id) AS n_queries
FROM search_queries
WHERE (clicks = 1 AND dwell_time_seconds > 30)
  AND query_date BETWEEN '2024-10-01' AND '2024-10-31';


-- Question 3: For users who signed up in the first week of October 2024 (e.g. October 1 - 7), 
-- how many search queries did they make in total?



SELECT COUNT(sq.query_id) AS n_queries
FROM search_queries sq
JOIN users u ON sq.user_id = u.user_id
WHERE u.signup_date BETWEEN '2024-10-01' AND '2024-10-07';




-- Your analyses will help the Google Search Quality team understand user engagement patterns, such as how clicking 
-- on links and spending time on search results relate to user satisfaction. This insight can guide improvements in 
-- search result relevance and overall user experience.