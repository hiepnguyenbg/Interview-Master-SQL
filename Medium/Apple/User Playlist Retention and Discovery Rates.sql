-- Create the database
CREATE DATABASE IF NOT EXISTS user_playlist_retention_db;
USE user_playlist_retention_db;

-- Create `users` table
CREATE TABLE users (
    user_id INT PRIMARY KEY,
    user_name VARCHAR(100)
);

-- Insert data into `users`
INSERT INTO users (user_id, user_name) VALUES
(101, 'Alice'),
(102, 'Bob'),
(103, 'Charlie'),
(104, 'Dawn'),
(105, 'Eve'),
(106, 'Frank');

-- Create `tracks_added` table
CREATE TABLE tracks_added (
    interaction_id INT PRIMARY KEY,
    user_id INT,
    track_id INT,
    added_date DATE,
    is_recommended BOOLEAN,
    FOREIGN KEY (user_id) REFERENCES users(user_id)
);

-- Insert data into `tracks_added`
INSERT INTO tracks_added (interaction_id, user_id, track_id, added_date, is_recommended) VALUES
(1, 101, 1001, '2024-10-02', TRUE),
(2, 102, 1002, '2024-10-03', TRUE),
(3, 101, 1003, '2024-10-05', FALSE),
(4, 103, 1004, '2024-10-06', TRUE),
(5, 104, 1005, '2024-10-07', TRUE),
(6, 102, 1006, '2024-10-08', FALSE),
(7, 101, 1007, '2024-10-09', TRUE),
(8, 105, 1008, '2024-10-10', TRUE),
(9, 104, 1009, '2024-10-11', FALSE),
(10, 106, 1010, '2024-10-12', TRUE),
(11, 102, 1011, '2024-10-13', TRUE),
(12, 103, 1012, '2024-10-14', TRUE),
(13, 104, 1013, '2024-10-15', TRUE),
(14, 105, 1014, '2024-10-16', TRUE),
(15, 106, 1015, '2024-10-17', FALSE),
(16, 101, 1016, '2024-10-18', TRUE),
(17, 102, 1017, '2024-10-19', TRUE),
(18, 103, 1018, '2024-10-20', TRUE),
(19, 104, 1019, '2024-10-21', TRUE),
(20, 105, 1020, '2024-10-22', TRUE),
(21, 106, 1021, '2024-10-02', FALSE),
(22, 101, 1022, '2024-10-03', TRUE),
(23, 104, 1023, '2024-10-05', TRUE),
(24, 102, 1024, '2024-10-06', FALSE),
(25, 105, 1025, '2024-10-07', TRUE),
(26, 103, 1026, '2024-10-08', TRUE),
(27, 101, 1027, '2024-10-09', TRUE),
(28, 106, 1028, '2024-10-10', FALSE),
(29, 102, 1029, '2024-10-11', TRUE),
(30, 104, 1030, '2024-10-12', TRUE);


-- You are a Data Scientist on the Apple Music Personalization Team, tasked with evaluating the 
-- effectiveness of recommendation algorithms in engaging users with new music. Your goal is to 
-- analyze user playlist interactions to determine how many users add recommended tracks to their 
-- playlists, the average number of recommended tracks added per user, and identify users who 
-- add non-recommended tracks. This analysis will help your team decide if the recommendation 
-- engine needs refinement to enhance user engagement and retention.



-- Question 1: How many unique users have added at least one recommended track to their playlists in October 2024?

SELECT COUNT(*) AS user_count
FROM (
    SELECT user_id
    FROM tracks_added
    WHERE added_date BETWEEN '2024-10-01' AND '2024-10-31'
    GROUP BY user_id
    HAVING SUM(is_recommended) > 0
) AS oct_users;


-- Question 2: Among the users who added recommended tracks in October 2024, what is the average number 
-- of recommended tracks added to their playlists? Please round this to 1 decimal place for better readability.

WITH oct_users AS (
    SELECT 
        user_id, 
        SUM(is_recommended) AS total_recommended
    FROM tracks_added
    WHERE added_date BETWEEN '2024-10-01' AND '2024-10-31'
    GROUP BY user_id
    HAVING SUM(is_recommended) > 0
)
SELECT 
    ROUND(SUM(total_recommended) * 1.0 / COUNT(user_id), 1) AS avg_recommended
FROM oct_users;

-- Question 3: Can you give us the name(s) of users who added a non-recommended track to their playlist on October 2nd, 2024?

SELECT DISTINCT user_name
FROM tracks_added ta
JOIN users u ON ta.user_id = u.user_id
WHERE added_date = '2024-10-02'
  AND is_recommended = 0;


