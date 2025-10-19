-- Create a new database
CREATE DATABASE IF NOT EXISTS user_playlist_engagement_discovery_db;
USE user_playlist_engagement_discovery_db;

-- Drop tables if they already exist
DROP TABLE IF EXISTS playlist_engagement;
DROP TABLE IF EXISTS playlists;

-- Create playlists table
CREATE TABLE playlists (
    playlist_id INT PRIMARY KEY,
    playlist_name VARCHAR(100),
    number_of_tracks INT
);

-- Create playlist_engagement table
CREATE TABLE playlist_engagement (
    user_id INT,
    playlist_id INT,
    engagement_date DATE,
    listening_time_minutes FLOAT,
    FOREIGN KEY (playlist_id) REFERENCES playlists(playlist_id)
);

-- Insert data into playlists
INSERT INTO playlists (playlist_id, playlist_name, number_of_tracks) VALUES
(1, 'Chill Vibes', 15),
(2, 'Workout Hits', 10),
(3, 'Top 50', 50),
(4, 'Indie Discoveries', 8),
(5, 'Jazz Essentials', 20),
(6, 'Classical Mornings', 12),
(7, 'Party Anthems', 25),
(8, 'Acoustic Sessions', 18),
(9, 'Rock Classics', 30),
(10, 'Pop Culture', 22);

-- Insert data into playlist_engagement
INSERT INTO playlist_engagement (user_id, playlist_id, engagement_date, listening_time_minutes) VALUES
(101, 1, '2024-10-05', 45),
(102, 1, '2024-10-06', 30),
(103, 2, '2024-10-07', 25),
(104, 2, '2024-10-08', 20),
(105, 3, '2024-10-09', 120),
(106, 3, '2024-10-10', 110),
(107, 4, '2024-10-11', 15),
(108, 4, '2024-10-12', 10),
(109, 5, '2024-10-13', 60),
(110, 5, '2024-10-14', 55),
(111, 6, '2024-10-15', 40),
(112, 6, '2024-10-16', 35),
(113, 7, '2024-10-17', 75),
(114, 7, '2024-10-18', 70),
(115, 8, '2024-10-19', 50),
(116, 8, '2024-10-20', 45),
(117, 9, '2024-10-21', 95),
(118, 9, '2024-10-22', 90),
(119, 10, '2024-10-23', 65),
(120, 10, '2024-10-24', 60);




-- You are a Data Analyst on the Amazon Music Recommendation Team focused on understanding 
-- the impact of playlists on user engagement. Your team wants to identify how the number of 
-- tracks in a playlist and user listening time correlate to optimize playlist recommendations. The 
-- end goal is to enhance user experience by tailoring playlists that maximize listening time and music discovery.


-- Question 1: The Amazon Music Recommendation Team wants to know which playlists have the least number 
-- of tracks. Can you find out the playlist with the minimum number of tracks?

SELECT playlist_id, playlist_name
FROM playlists
WHERE number_of_tracks = (
    SELECT MIN(number_of_tracks) 
    FROM playlists
);


-- Question 2: We are interested in understanding the engagement level of playlists. Specifically, we want to 
-- identify which playlist has the lowest average listening time per track. This means calculating the 
-- total listening time for each playlist in October 2024 and then normalizing it by the number of 
-- tracks in that playlist. Can you provide the name of the playlist with the lowest value based on this calculation?


WITH total_listening AS (
    SELECT playlist_id, SUM(listening_time_minutes) AS total_min
    FROM playlist_engagement
    WHERE engagement_date BETWEEN '2024-10-01' AND '2024-10-31'
    GROUP BY playlist_id
)

SELECT 
    pl.playlist_name, 
    ROUND(tl.total_min * 1.0 / pl.number_of_tracks, 2) AS avg_listening_time_per_track
FROM playlists pl
JOIN total_listening tl ON pl.playlist_id = tl.playlist_id
ORDER BY avg_listening_time_per_track
LIMIT 1;


-- SELECT 
--     pl.playlist_name,
--     ROUND(SUM(pe.listening_time_minutes)::numeric / pl.number_of_tracks, 2) AS avg_listening_time_per_track
-- FROM playlists pl
-- JOIN playlist_engagement pe 
--     ON pe.playlist_id = pl.playlist_id
-- WHERE pe.engagement_date BETWEEN DATE '2024-10-01' AND DATE '2024-10-31'
-- GROUP BY pl.playlist_name, pl.number_of_tracks
-- ORDER BY avg_listening_time_per_track
-- LIMIT 1;




-- Question 3: To optimize our recommendations, we need the average monthly listening time per listener for
--  each playlist in October 2024. For readability, please round down the average listening time to the nearest whole number.

-- WITH listening_time_per_user AS (
--     SELECT 
--         playlist_id, 
--         user_id, 
--         SUM(listening_time_minutes) AS total_listening_time
--     FROM playlist_engagement
--     WHERE engagement_date BETWEEN '2024-10-01' AND '2024-10-31'
--     GROUP BY playlist_id, user_id
-- )

-- SELECT 
--     pl.playlist_name,
--     FLOOR(AVG(l.total_listening_time)) AS avg_monthly_listening_per_user
-- FROM listening_time_per_user l
-- JOIN playlists pl ON l.playlist_id = pl.playlist_id
-- GROUP BY pl.playlist_id, pl.playlist_name
-- ORDER BY 2 DESC;


SELECT playlist_id, 
    FLOOR( SUM(listening_time_minutes) / COUNT(DISTINCT user_id)) as avg_listening
FROM playlist_engagement
WHERE engagement_date BETWEEN '2024-10-01' AND '2024-10-31'
GROUP BY playlist_id;





