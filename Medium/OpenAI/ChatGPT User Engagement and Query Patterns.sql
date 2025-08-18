-- Create the database
CREATE DATABASE IF NOT EXISTS chatgpt_user_engagement_db;
USE chatgpt_user_engagement_db;

-- Create dim_users table
CREATE TABLE dim_users (
    user_id INT PRIMARY KEY,
    first_name TEXT NOT NULL,
    last_name TEXT NOT NULL
);

-- Create fct_queries table
CREATE TABLE fct_queries (
    query_id INT PRIMARY KEY,
    user_id INT,
    query_text TEXT NOT NULL,
    query_domain TEXT NOT NULL,
    query_timestamp TIMESTAMP NOT NULL,
    FOREIGN KEY (user_id) REFERENCES dim_users(user_id)
);

-- Insert data into dim_users
INSERT INTO dim_users (user_id, first_name, last_name) VALUES
(1, 'Alice', 'Smith'),
(2, 'Bob', 'Johnson'),
(3, 'Charlie', 'Lee'),
(4, 'Dana', 'Brown'),
(5, 'Evan', 'Davis'),
(6, 'Fiona', 'Miller'),
(7, 'George', 'Wilson'),
(8, 'Hannah', 'Moore'),
(9, 'Ian', 'Taylor'),
(10, 'Julia', 'Anderson');

-- Insert data into fct_queries
INSERT INTO fct_queries (query_id, user_id, query_text, query_domain, query_timestamp) VALUES
(1, 1, 'How does ChatGPT work?', 'technology', '2024-07-02 09:15:00'),
(2, 2, 'What is the latest discovery in astrophysics?', 'science', '2024-07-15 12:00:00'),
(3, 3, 'Tell me a joke', 'entertainment', '2024-07-20 16:30:00'),
(4, 1, 'Explain neural networks', 'technology', '2024-08-01 10:05:00'),
(5, 2, 'Quantum mechanics basics', 'science', '2024-08-03 11:00:00'),
(6, 3, 'Art history overview', 'history', '2024-08-10 09:45:00'),
(7, 4, 'Latest trends in technology', 'technology', '2024-08-12 14:30:00'),
(8, 5, 'Biology breakthroughs', 'science', '2024-08-15 15:00:00'),
(9, 1, 'ChatGPT use cases', 'technology', '2024-08-20 08:00:00'),
(10, 4, 'History of computing', 'technology', '2024-08-22 13:15:00'),
(11, 6, 'Science fiction books', 'science', '2024-08-25 18:20:00'),
(12, 2, 'Defining artificial intelligence', 'technology', '2024-08-28 20:45:00'),
(13, 7, 'Latest science news', 'science', '2024-09-03 10:00:00'),
(14, 8, 'Technology breakthrough in AI', 'technology', '2024-09-08 12:30:00'),
(15, 9, 'ChatGPT vs human creativity', 'technology', '2024-09-10 14:45:00'),
(16, 10, 'Understanding climate change', 'environment', '2024-09-15 16:00:00'),
(17, 7, 'Advancements in space travel', 'science', '2024-09-20 09:00:00'),
(18, 5, 'ChatGPT features overview', 'technology', '2024-09-25 19:15:00');




-- As a Product Analyst on the ChatGPT team, you are tasked with understanding user engagement patterns across 
-- different knowledge domains. Your team is particularly interested in identifying the proportion of queries 
-- related to technology and science, understanding monthly query volumes, and recognizing the most active users. 
-- The insights gained will help tailor user experience and prioritize outreach to highly engaged users.



-- Question 1: What percentage of user queries in July 2024 were related to either 'technology' or 'science' domains?


SELECT 
  ROUND(
    100.0 * SUM(CASE WHEN query_domain IN ('technology', 'science') THEN 1 ELSE 0 END) 
    / COUNT(*), 
    2
  ) AS techsci_pct
FROM fct_queries
WHERE date(query_timestamp) BETWEEN '2024-07-01' AND '2024-07-31';


-- Question 2:  Calculate the total number of queries per month in Q3 2024. Which month had the highest number of queries?


SELECT 
  MONTH(query_timestamp) AS month,
  COUNT(query_id) AS total_queries
FROM fct_queries
WHERE query_timestamp BETWEEN '2024-07-01' AND '2024-09-30 23:59:59'
GROUP BY month
ORDER BY total_queries DESC;




-- Question 3:  Identify the top 5 users with the most queries in August 2024 by their first and last name. 
-- We want to interview our most active users and this information will be used in our outreach to these users.

SELECT 
  du.user_id,
  CONCAT(du.first_name, ' ', du.last_name) AS full_name,
  COUNT(fq.query_id) AS n_queries
FROM fct_queries fq
JOIN dim_users du ON fq.user_id = du.user_id
WHERE DATE(fq.query_timestamp) BETWEEN '2024-08-01' AND '2024-08-31'
GROUP BY du.user_id
ORDER BY n_queries DESC
LIMIT 5;





