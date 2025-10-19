-- Create database
CREATE DATABASE IF NOT EXISTS content_recommendation_algo_performance_db;
USE content_recommendation_algo_performance_db;

-- Drop tables if they already exist
DROP TABLE IF EXISTS fct_watch_history;
DROP TABLE IF EXISTS fct_recommendations;
DROP TABLE IF EXISTS dim_content;

-- Create dim_content table
CREATE TABLE dim_content (
    content_id INT PRIMARY KEY,
    title VARCHAR(255),
    genre VARCHAR(50),
    release_date DATE
);

-- Create fct_watch_history table
CREATE TABLE fct_watch_history (
    watch_id INT PRIMARY KEY,
    user_id INT,
    content_id INT,
    watch_time_minutes INT,
    watch_date DATE
);

-- Create fct_recommendations table
CREATE TABLE fct_recommendations (
    recommendation_id INT PRIMARY KEY,
    user_id INT,
    content_id INT,
    recommended_date DATE
);

-- Insert data into dim_content
INSERT INTO dim_content (content_id, title, genre, release_date) VALUES
(1, 'The Great Adventure', 'Action', '2023-11-15'),
(2, 'Love & Laughs', 'Comedy', '2022-07-22'),
(3, 'Mystery of the Lost City', 'Thriller', '2024-01-10'),
(4, 'Nature''s Wonders', 'Documentary', '2021-05-05'),
(5, 'Space Odyssey', 'Sci-Fi', '2023-03-30'),
(6, 'Dawn''s Early Light', 'Drama', '2024-02-14'),
(7, 'The Culinary Journey', 'Reality', '2022-10-18'),
(8, 'Haunted Manor', 'Horror', '2023-08-09'),
(9, 'Robot Uprising', 'Action', '2024-01-25'),
(10, 'Stand-Up Nights', 'Comedy', '2022-12-12'),
(11, 'Deep Sea Secrets', 'Documentary', '2023-06-20'),
(12, 'The Last Frontier', 'Sci-Fi', '2024-03-05'),
(13, 'Urban Legends', 'Horror', '2022-09-30'),
(14, 'Comedy Central', 'Comedy', '2023-02-28'),
(15, 'Historical Battles', 'Documentary', '2021-11-11');

-- Insert data into fct_watch_history
INSERT INTO fct_watch_history (watch_id, user_id, content_id, watch_time_minutes, watch_date) VALUES
(1, 1, 1, 120, '2024-01-05'),
(2, 2, 2, 45, '2024-01-15'),
(3, 3, 3, 90, '2024-02-10'),
(4, 1, 4, 60, '2024-02-20'),
(5, 4, 5, 150, '2024-03-01'),
(6, 5, 6, 30, '2024-03-10'),
(7, 2, 7, 80, '2024-01-25'),
(8, 3, 8, 50, '2024-02-05'),
(9, 4, 9, 100, '2024-03-15'),
(10, 5, 10, 40, '2024-03-20'),
(11, 6, 11, 70, '2024-01-18'),
(12, 7, 12, 110, '2024-02-22'),
(13, 8, 13, 55, '2024-03-08'),
(14, 9, 14, 35, '2024-01-30'),
(15, 10, 15, 65, '2024-02-14'),
(16, 1, 3, 95, '2024-02-28'),
(17, 2, 5, 145, '2024-03-25'),
(18, 3, 7, 75, '2024-01-12'),
(19, 4, 9, 105, '2024-03-18'),
(20, 5, 11, 85, '2024-02-08'),
(21, 6, 12, 115, '2024-03-12'),
(22, 7, 14, 38, '2024-01-22'),
(23, 8, 1, 125, '2024-02-16'),
(24, 9, 4, 58, '2024-03-05'),
(25, 10, 2, 42, '2024-01-28');

-- Insert data into fct_recommendations
INSERT INTO fct_recommendations (recommendation_id, user_id, content_id, recommended_date) VALUES
(1, 1, 1, '2024-01-04'),
(2, 2, 2, '2024-01-10'),
(3, 3, 3, '2024-02-08'),
(4, 1, 4, '2024-02-18'),
(5, 4, 5, '2024-03-02'),
(6, 5, 6, '2024-03-09'),
(7, 2, 7, '2024-01-20'),
(8, 3, 8, '2024-02-03'),
(9, 4, 9, '2024-03-14'),
(10, 5, 10, '2024-03-19'),
(11, 6, 11, '2024-01-17'),
(12, 7, 12, '2024-02-20'),
(13, 8, 13, '2024-03-07'),
(14, 9, 14, '2024-01-29'),
(15, 10, 15, '2024-02-13'),
(16, 1, 3, '2024-02-27'),
(17, 2, 5, '2024-03-24'),
(18, 3, 7, '2024-01-11'),
(19, 4, 9, '2024-03-17'),
(20, 5, 11, '2024-02-07');




-- You are a Data Analyst on the Content Discovery Team at Netflix, tasked with evaluating the 
-- impact of the recommendation algorithm on user engagement. Your team is focused on 
-- assessing how recommendations affect total watch time and categorizing user watch sessions to 
-- identify engagement patterns. The end goal is to refine the recommendation engine to enhance 
-- user satisfaction and drive more diverse content exploration.


-- Question 1: What is the total watch time for content after it was recommended to users? To correctly 
-- attribute watch time to the recommendation, it is critical to only include watch time after the 
-- recommendation was made to the user. A content could get recommended to a user multiple times. If so, 
-- we want to use the first date that the content was recommended to a user.


WITH first_recommendation AS (
  SELECT user_id, content_id, MIN(recommended_date) AS earliest_recommended_date
  FROM fct_recommendations
  GROUP BY user_id, content_id
)
SELECT SUM(fwh.watch_time_minutes) AS total_watch_time
FROM fct_watch_history fwh
JOIN first_recommendation fr
  ON fwh.user_id = fr.user_id
 AND fwh.content_id = fr.content_id
WHERE fwh.watch_date >= fr.earliest_recommended_date;



-- Question 2: The team wants to know the total watch time for each genre in first quarter of 2024, 
-- split by whether or not the content was recommended vs. non-recommended to a user.

-- Watch time should be bucketed into 'Recommended' by joining on both user and content, regardless of 
-- when they watched it vs. when they received the recommendation.


WITH watch_with_recommendation_flag AS (
  SELECT 
    dc.genre,
    fwh.watch_time_minutes,
    CASE 
      WHEN fr.user_id IS NOT NULL THEN 'Recommended'
      ELSE 'Not Recommended'
    END AS recommended_flag
  FROM fct_watch_history fwh
  JOIN dim_content dc 
    ON fwh.content_id = dc.content_id
  LEFT JOIN fct_recommendations fr
    ON fwh.user_id = fr.user_id 
   AND fwh.content_id = fr.content_id
  WHERE fwh.watch_date BETWEEN '2024-01-01' AND '2024-03-31'
)

SELECT 
  genre,
  recommended_flag AS recommended,
  SUM(watch_time_minutes) AS total_watch_time
FROM watch_with_recommendation_flag
GROUP BY genre, recommended
ORDER BY genre, recommended;


-- Question 3: The team aims to categorize user watch sessions into 'Short', 'Medium', or 'Long' based 
-- on watch time for recommended content to identify engagement patterns.

-- 'Short' for less than 60 minutes, 'Medium' for 60 to 120 minutes, and 'Long' for more than 120 minutes. 
-- Can you classify and count the sessions in Q1 2024 accordingly?

WITH length_classification AS (
  SELECT 
    CASE
      WHEN watch_time_minutes < 60 THEN 'Short'
      WHEN watch_time_minutes BETWEEN 60 AND 120 THEN 'Medium'
      ELSE 'Long'
    END AS category
  FROM fct_watch_history fwh
  JOIN dim_content dc 
    ON fwh.content_id = dc.content_id
  JOIN fct_recommendations fr
    ON fwh.user_id = fr.user_id 
   AND fwh.content_id = fr.content_id
  WHERE fwh.watch_date BETWEEN '2024-01-01' AND '2024-03-31'
)

SELECT category, COUNT(*) AS count
FROM length_classification
GROUP BY category
ORDER BY 2 DESC;


