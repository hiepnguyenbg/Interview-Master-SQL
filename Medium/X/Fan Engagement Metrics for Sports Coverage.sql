-- Create the database
CREATE DATABASE IF NOT EXISTS fan_engagement_metrics_db;
USE fan_engagement_metrics_db;

-- Create dim_sports_categories table
CREATE TABLE dim_sports_categories (
    category_id INT PRIMARY KEY,
    category_name VARCHAR(100)
);

-- Insert data into dim_sports_categories
INSERT INTO dim_sports_categories (category_id, category_name) VALUES
(1, 'Football'),
(2, 'Basketball'),
(3, 'Baseball'),
(4, 'Tennis'),
(5, 'Hockey'),
(6, 'Soccer'),
(7, 'Cricket'),
(8, 'Rugby'),
(9, 'Golf'),
(10, 'Formula 1');

-- Create fct_user_interactions table
CREATE TABLE fct_user_interactions (
    interaction_id INT PRIMARY KEY,
    user_id INT,
    content_type VARCHAR(100),
    interaction_duration INT,
    interaction_date DATE,
    category_id INT,
    FOREIGN KEY (category_id) REFERENCES dim_sports_categories(category_id)
);

-- Insert data into fct_user_interactions
INSERT INTO fct_user_interactions (user_id, content_type, interaction_id, interaction_date, interaction_duration, category_id) VALUES
(1, 'live sports commentary', 1, '2024-04-05', 130, 1),
(2, 'live sports commentary', 2, '2024-04-12', 138, 2),
(3, 'live sports commentary', 3, '2024-04-15', 140, 3),
(4, 'live sports commentary', 4, '2024-04-18', 136, 4),
(5, 'live sports commentary', 5, '2024-04-28', 136, 5),
(6, 'live sports commentary', 6, '2024-05-02', 150, 6),
(7, 'highlights', 7, '2024-05-03', 80, 7),
(8, 'live sports commentary', 8, '2024-05-04', 120, 8),
(9, 'highlights', 9, '2024-05-05', 90, 9),
(10, 'live sports commentary', 10, '2024-05-06', 130, 10),
(11, 'live sports commentary', 11, '2024-05-07', 140, 1),
(12, 'highlights', 12, '2024-05-08', 70, 2),
(13, 'live sports commentary', 13, '2024-05-09', 155, 3),
(14, 'highlights', 14, '2024-05-10', 85, 4),
(15, 'live sports commentary', 15, '2024-05-11', 145, 5),
(16, 'highlights', 16, '2024-05-12', 95, 6),
(17, 'live sports commentary', 17, '2024-05-13', 125, 7),
(18, 'highlights', 18, '2024-05-14', 100, 8),
(19, 'live sports commentary', 19, '2024-05-15', 135, 9),
(20, 'highlights', 20, '2024-05-16', 110, 10),
(21, 'live sports commentary', 21, '2024-05-17', 132, 1),
(22, 'highlights', 22, '2024-05-18', 88, 2),
(23, 'live sports commentary', 23, '2024-05-19', 142, 3),
(24, 'highlights', 24, '2024-05-20', 77, 4),
(25, 'live sports commentary', 25, '2024-05-21', 138, 5),
(26, 'highlights', 26, '2024-05-22', 83, 6),
(27, 'live sports commentary', 27, '2024-05-23', 147, 7),
(28, 'highlights', 28, '2024-05-24', 92, 8),
(29, 'live sports commentary', 29, '2024-05-25', 136, 9),
(30, 'highlights', 30, '2024-05-26', 99, 10);






-- As a Product Analyst for the X sports updates platform, your team is focused on enhancing user engagement 
-- with live sports content. You need to analyze user interactions with both live sports commentary and highlights 
-- to identify patterns and preferences. The insights will help prioritize content strategies and improve the user 
-- experience during live events.



-- Question 1: What is the average duration of user interactions with live sports commentary during April 2024? 
-- Round the result to the nearest whole number.


SELECT 
    ROUND(AVG(interaction_duration)) AS avg_duration
FROM fct_user_interactions
WHERE interaction_date BETWEEN '2024-04-01' AND '2024-04-30'
  AND content_type = 'live sports commentary';


-- Question 2: For the month of May 2024, determine the total number of users who interacted with live sports 
-- commentary and highlights. Ensure to include users who interacted with either or both content types.



SELECT 
   COUNT(DISTINCT user_id) AS n_user
FROM fct_user_interactions
WHERE interaction_date BETWEEN '2024-05-01' AND '2024-05-31'
  AND (content_type = 'live sports commentary' OR content_type = 'highlights');


-- Question 3: Identify the top 3 performing sports categories for live sports commentary based on user engagement
--  in May 2024. Focus on those with the highest total interaction time.


SELECT category_name, SUM(interaction_duration) AS total_interaction_time
FROM fct_user_interactions fsi
JOIN dim_sports_categories dsc ON fsi.category_id = dsc.category_id
WHERE interaction_date BETWEEN '2024-05-01' AND '2024-05-31'
  AND content_type = 'live sports commentary'
GROUP BY category_name
ORDER BY total_interaction_time DESC
LIMIT 3;


-- Your analyses will help the X sports updates platform understand which sports categories drive the most engagement during live 
-- commentary, allowing the team to prioritize content strategies and improve user experience during live events.
