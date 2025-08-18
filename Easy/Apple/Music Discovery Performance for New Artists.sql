CREATE DATABASE IF NOT EXISTS music_discovery_performance_db;
USE music_discovery_performance_db;

CREATE TABLE fct_artist_recommendations (
    recommendation_id INT PRIMARY KEY,
    user_id INT,
    artist_id INT,
    recommendation_date DATE,
    is_new_artist BOOLEAN
);

INSERT INTO fct_artist_recommendations (user_id, artist_id, is_new_artist, recommendation_id, recommendation_date) VALUES
(101, 201, 0, 1, '2024-04-01'),
(102, 202, 1, 2, '2024-04-02'),
(101, 203, 1, 3, '2024-04-15'),
(103, 201, 0, 4, '2024-04-20'),
(104, 204, 1, 5, '2024-04-25'),
(101, 205, 1, 6, '2024-05-03'),
(105, 206, 1, 7, '2024-05-04'),
(106, 205, 1, 8, '2024-05-17'),
(107, 207, 0, 9, '2024-05-23'),
(102, 208, 1, 10, '2024-05-25'),
(108, 209, 1, 11, '2024-06-02'),
(103, 210, 0, 12, '2024-06-10'),
(109, 205, 1, 13, '2024-06-15'),
(104, 211, 1, 14, '2024-06-20'),
(110, 212, 0, 15, '2024-06-25'),
(110, 211, 1, 16, '2024-06-27');






-- You are a Product Analyst on the Apple Music discovery team focused on enhancing artist recommendation algorithms. 
-- Your team aims to evaluate the diversity and effectiveness of new artist recommendations across different genres. 
-- The goal is to refine the recommendation system to boost user engagement and support emerging artists.





-- Question 1: How many unique artists were recommended to users in April 2024? This analysis will help determine 
-- the diversity of recommendations during that month.


SELECT COUNT(DISTINCT artist_id) AS n_artists
FROM fct_artist_recommendations
WHERE recommendation_date BETWEEN '2024-04-01' AND '2024-04-30';



-- Question 2: What is the total number of recommendations for new artists in May 2024? This insight will help 
-- assess if our focus on emerging talent is working effectively.

SELECT COUNT(*) AS total_recommendations
FROM fct_artist_recommendations
WHERE recommendation_date BETWEEN '2024-05-01' AND '2024-05-31'
AND is_new_artist = 1;



-- Question 3: For each month in Quarter 2 2024 (April through June 2024), how many distinct new artists were 
-- recommended to users? This breakdown will help identify trends in new artist recommendations over the quarter.


SELECT MONTH(recommendation_date) AS month_recommendations,
       COUNT(DISTINCT artist_id) AS n_new_artists
FROM fct_artist_recommendations
WHERE recommendation_date BETWEEN '2024-04-01' AND '2024-06-30'
  AND is_new_artist = 1
GROUP BY month_recommendations
ORDER BY month_recommendations;



-- Your analyses will help Apple Music's discovery team understand how the recommendation system is performing in terms 
-- of promoting new artists over time. This insight is crucial for refining the algorithm to boost user engagement and 
-- support emerging talent effectively.






