-- Create a new database
CREATE DATABASE IF NOT EXISTS user_engagement_artist_recommendations_db;
USE user_engagement_artist_recommendations_db;

-- Drop tables if they already exist (optional safety step)
DROP TABLE IF EXISTS user_streams;
DROP TABLE IF EXISTS artist_recommendations;

-- Create artist_recommendations table
CREATE TABLE artist_recommendations (
    recommendation_id INT PRIMARY KEY,
    user_id INT,
    artist_id INT,
    recommendation_date DATE
);

-- Create user_streams table
CREATE TABLE user_streams (
    stream_id INT PRIMARY KEY,
    user_id INT,
    artist_id INT,
    stream_date DATE
);

-- Insert data into artist_recommendations
INSERT INTO artist_recommendations (recommendation_id, user_id, artist_id, recommendation_date) VALUES
(1, 101, 201, '2024-05-01'),
(2, 102, 202, '2024-05-02'),
(3, 103, 203, '2024-05-03'),
(4, 104, 204, '2024-05-04'),
(5, 105, 205, '2024-05-05'),
(6, 106, 206, '2024-05-06'),
(7, 107, 207, '2024-05-07'),
(8, 108, 208, '2024-05-08'),
(9, 109, 209, '2024-05-09'),
(10, 110, 210, '2024-05-10');

-- Insert data into user_streams
INSERT INTO user_streams (stream_id, user_id, artist_id, stream_date) VALUES
(1, 101, 201, '2024-05-01'),
(2, 102, 202, '2024-05-02'),
(3, 101, 203, '2024-05-03'),
(4, 103, 201, '2024-05-04'),
(5, 104, 204, '2024-05-05'),
(6, 105, 205, '2024-05-06'),
(7, 102, 202, '2024-05-07'),
(8, 101, 201, '2024-05-08'),
(9, 106, 206, '2024-05-09'),
(10, 107, 207, '2024-05-10'),
(11, 108, 208, '2024-05-11'),
(12, 109, 209, '2024-05-12'),
(13, 110, 210, '2024-05-13'),
(14, 101, 201, '2024-05-14'),
(15, 102, 202, '2024-05-15'),
(16, 103, 203, '2024-05-16'),
(17, 104, 204, '2024-05-17'),
(18, 105, 205, '2024-05-18'),
(19, 106, 206, '2024-05-19'),
(20, 107, 207, '2024-05-20');




-- You are a Data Analyst on the Apple Music Personalization Team. Your team is focused on 
-- evaluating the effectiveness of the recommendation algorithm for artist discovery. The goal is to 
-- analyze user interactions with recommended artists to enhance the recommendation engine and improve user engagement.


-- Question 1: How many unique users have streamed an artist on or after the date it was recommended to them?


SELECT COUNT(DISTINCT us.user_id)
FROM user_streams us
JOIN artist_recommendations ar 
  ON us.user_id = ar.user_id AND us.artist_id = ar.artist_id
WHERE us.stream_date >= ar.recommendation_date;


-- Question 2: What is the average number of times a recommended artist is streamed by users in May 2024? 
-- Similar to the previous question, only include streams on or after the date the artist was recommended to them.


WITH number_streamed AS (
    SELECT 
        us.user_id,
        us.artist_id, 
        COUNT(*) AS n_streamed
    FROM user_streams us
    JOIN artist_recommendations ar 
        ON us.user_id = ar.user_id 
        AND us.artist_id = ar.artist_id
    WHERE us.stream_date >= ar.recommendation_date
      AND us.stream_date BETWEEN '2024-05-01' AND '2024-05-31'
    GROUP BY us.user_id, us.artist_id
)

SELECT 
    ROUND(AVG(n_streamed), 2) AS avg_streams_per_user_artist
FROM number_streamed;



-- Question 3: Across users who listened to at least one recommended artist, what is the average number of distinct recommended artists 
-- they listened to? As in the previous question, only include streams that occurred on or after the date the artist was 
-- recommended to the user.



WITH at_least_one AS (
    SELECT 
        us.user_id, 
        COUNT(DISTINCT us.artist_id) AS n_distinct_artist
    FROM user_streams us
    JOIN artist_recommendations ar 
        ON us.user_id = ar.user_id 
        AND us.artist_id = ar.artist_id
    WHERE us.stream_date >= ar.recommendation_date
    GROUP BY us.user_id
    HAVING COUNT(us.artist_id) >= 1
)
SELECT ROUND(AVG(n_distinct_artist), 2) 
FROM at_least_one;




-- WITH user_artist_streams AS (
--     SELECT
--         us.user_id,
--         us.artist_id
--     FROM user_streams us
--     JOIN artist_recommendations ar 
--         ON us.user_id = ar.user_id 
--         AND us.artist_id = ar.artist_id
--     WHERE us.stream_date >= ar.recommendation_date
-- ),
-- user_artist_counts AS (
--     SELECT
--         user_id,
--         COUNT(DISTINCT artist_id) AS n_distinct_artists
--     FROM user_artist_streams
--     GROUP BY user_id
-- )
-- SELECT 
--     ROUND(AVG(n_distinct_artists), 1) AS avg_distinct_recommended_artists
-- FROM user_artist_counts;




