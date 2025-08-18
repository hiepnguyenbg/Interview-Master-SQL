-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS game_library_health_db;
USE game_library_health_db;

-- Step 2: Create dim_users table
CREATE TABLE IF NOT EXISTS dim_users (
    user_id INT PRIMARY KEY,
    has_game_installed BOOLEAN NOT NULL,
    library_last_updated DATE NOT NULL,
    installed_games_count INT NOT NULL
);

-- Step 3: Create fct_user_game_activity table
CREATE TABLE IF NOT EXISTS fct_user_game_activity (
    user_id INT NOT NULL,
    game_id INT NOT NULL,
    install_date DATE NOT NULL,
    last_played_date DATE NOT NULL,
    PRIMARY KEY (user_id, game_id),
    FOREIGN KEY (user_id) REFERENCES dim_users(user_id)
);

-- Step 4: Insert data into dim_users
INSERT INTO dim_users (user_id, has_game_installed, library_last_updated, installed_games_count) VALUES
(1, 0, '2024-07-05', 0),
(2, 0, '2024-07-10', 0),
(3, 0, '2024-07-15', 0),
(4, 0, '2024-07-20', 0),
(5, 0, '2024-07-25', 0),
(6, 1, '2024-07-30', 4),
(7, 0, '2024-08-04', 0),
(8, 0, '2024-08-10', 0),
(9, 1, '2024-08-15', 3),
(10, 0, '2024-08-20', 0),
(11, 1, '2024-08-25', 6),
(12, 1, '2024-08-30', 4),
(13, 0, '2024-09-05', 0),
(14, 1, '2024-09-10', 3),
(15, 0, '2024-09-15', 0),
(16, 1, '2024-09-20', 5),
(17, 0, '2024-09-25', 0),
(18, 0, '2024-09-30', 0),
(19, 1, '2024-06-20', 4),
(20, 1, '2024-10-05', 5),
(21, 0, '2024-05-15', 0),
(22, 1, '2024-11-01', 3),
(23, 0, '2024-07-12', 0),
(24, 0, '2024-08-22', 0),
(25, 1, '2024-09-02', 4);

-- Step 5: Insert data into fct_user_game_activity
INSERT INTO fct_user_game_activity (game_id, user_id, install_date, last_played_date) VALUES
(101, 2, '2024-07-01', '2024-07-02'),
(101, 4, '2024-07-02', '2024-07-03'),
(101, 6, '2024-07-03', '2024-07-04'),
(101, 8, '2024-07-04', '2024-07-05'),
(101, 10, '2024-07-05', '2024-07-06'),
(101, 12, '2024-07-06', '2024-07-07'),
(101, 14, '2024-07-07', '2024-07-08'),
(101, 16, '2024-07-08', '2024-07-09'),
(101, 18, '2024-07-09', '2024-07-10'),
(101, 20, '2024-07-10', '2024-07-11'),
(101, 22, '2024-07-11', '2024-07-12'),
(101, 23, '2024-07-12', '2024-07-13'),
(101, 24, '2024-07-13', '2024-07-14'),
(101, 25, '2024-07-14', '2024-07-15'),
(102, 1, '2024-08-01', '2024-08-02'),
(102, 3, '2024-08-02', '2024-08-03'),
(102, 5, '2024-08-03', '2024-08-04'),
(102, 7, '2024-08-04', '2024-08-05'),
(102, 9, '2024-08-05', '2024-08-06'),
(102, 11, '2024-08-06', '2024-08-07'),
(102, 13, '2024-08-07', '2024-08-08'),
(102, 15, '2024-08-08', '2024-08-09'),
(102, 17, '2024-08-09', '2024-08-10'),
(102, 19, '2024-08-10', '2024-08-11'),
(102, 21, '2024-08-11', '2024-08-12'),
(102, 22, '2024-08-12', '2024-08-13'),
(103, 2, '2024-09-01', '2024-09-02'),
(103, 4, '2024-09-02', '2024-09-03'),
(103, 6, '2024-09-03', '2024-09-04'),
(103, 8, '2024-09-04', '2024-09-05'),
(103, 10, '2024-09-05', '2024-09-06'),
(103, 12, '2024-09-06', '2024-09-07'),
(103, 14, '2024-09-07', '2024-09-08'),
(103, 16, '2024-09-08', '2024-09-09'),
(103, 18, '2024-09-09', '2024-09-10'),
(103, 20, '2024-09-10', '2024-09-11'),
(104, 1, '2024-07-15', '2024-07-16'),
(104, 3, '2024-07-16', '2024-07-17'),
(104, 5, '2024-07-17', '2024-07-18'),
(104, 7, '2024-07-18', '2024-07-19'),
(104, 9, '2024-07-19', '2024-07-20'),
(104, 11, '2024-07-20', '2024-07-21'),
(104, 13, '2024-07-21', '2024-07-22'),
(104, 15, '2024-07-22', '2024-07-23'),
(104, 17, '2024-07-23', '2024-07-24'),
(105, 2, '2024-09-12', '2024-09-13'),
(105, 4, '2024-09-13', '2024-09-14'),
(105, 6, '2024-09-14', '2024-09-15'),
(105, 8, '2024-09-15', '2024-09-16'),
(105, 10, '2024-09-16', '2024-09-17'),
(105, 12, '2024-09-17', '2024-09-18'),
(105, 14, '2024-09-18', '2024-09-19'),
(105, 16, '2024-09-19', '2024-09-20'),
(106, 3, '2024-06-15', '2024-06-16'),
(106, 7, '2024-10-01', '2024-10-02'),
(106, 11, '2024-10-03', '2024-10-04');






-- You are a Product Analyst on the EA Desktop team investigating user game library engagement patterns. Your team wants 
-- to understand how many games users have installed and actively play on the platform. The goal is to identify 
-- opportunities to improve user retention and platform stickiness.





-- Question 1: How many users have no games installed in their library during the third quarter of 2024? Use the dim_users 
-- table and filter for users where has_game_installed is 0 and the library_last_updated date is between July and September 
-- 2024. This helps identify users that can be targeted for increased engagement.


SELECT COUNT(DISTINCT user_id) AS n_users
FROM dim_users
WHERE has_game_installed = 0
AND library_last_updated BETWEEN '2024-07-01' AND '2024-09-30';



-- Question 2: Which 5 games had the highest number of installs during the third quarter of 2024? This helps reveal 
-- the most popular games among users.

SELECT game_id, COUNT(*) AS n_installs
FROM fct_user_game_activity
WHERE install_date BETWEEN '2024-07-01' AND '2024-09-30'
GROUP BY game_id
ORDER BY n_installs DESC
LIMIT 5;



-- Question 3: How many users, whose libraries were last updated between July and September 2024, have 3 or more games 
-- installed in their library?


SELECT COUNT(user_id) AS n_users
FROM dim_users
WHERE library_last_updated BETWEEN '2024-07-01' AND '2024-09-30'
AND installed_games_count >= 3;



-- Your analyses will help the EA Desktop team understand user engagement by identifying how many users have no games 
-- installed, which games are most popular, and how many users have a substantial number of games installed. This insight 
-- is valuable for targeting users to improve retention and platform stickiness.




