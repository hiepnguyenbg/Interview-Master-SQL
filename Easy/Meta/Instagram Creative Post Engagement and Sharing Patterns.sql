-- Create the database
CREATE DATABASE IF NOT EXISTS instagram_creative_post_engagement_db;
USE instagram_creative_post_engagement_db;

-- Create the table
CREATE TABLE agg_daily_creative_shares (
    user_id INT,
    content_type VARCHAR(50),
    share_count INT,
    share_date DATE
);

-- Insert the data
INSERT INTO agg_daily_creative_shares (user_id, share_date, share_count, content_type) VALUES
(101, '2024-04-05', 6, 'photo'),
(101, '2024-04-20', 7, 'video'),
(101, '2024-05-08', 5, 'photo'),
(101, '2024-05-21', 4, 'video'),
(101, '2024-06-10', 6, 'photo'),
(102, '2024-04-08', 3, 'photo'),
(102, '2024-05-11', 6, 'photo'),
(102, '2024-06-05', 2, 'video'),
(103, '2024-04-12', 11, 'video'),
(103, '2024-05-12', 3, 'photo'),
(103, '2024-05-15', 3, 'video'),
(103, '2024-06-06', 5, 'video'),
(104, '2024-04-20', 5, 'photo'),
(104, '2024-04-25', 6, 'photo'),
(104, '2024-05-10', 2, 'photo'),
(104, '2024-05-18', 8, 'video'),
(104, '2024-06-30', 3, 'video'),
(105, '2024-04-02', 2, 'video'),
(105, '2024-05-22', 2, 'video'),
(105, '2024-06-10', 2, 'video'),
(106, '2024-04-01', 10, 'photo'),
(106, '2024-04-10', 1, 'video'),
(106, '2024-05-05', 7, 'photo'),
(106, '2024-05-25', 7, 'video'),
(106, '2024-06-15', 8, 'photo');






-- You are a Product Analyst on the Instagram Stories team focused on understanding user engagement with creative 
-- content sharing. Your team wants to identify highly engaged users and analyze sharing patterns to enhance 
-- features that promote content sharing. Your insights will guide product managers in improving user interaction 
-- and content distribution on the platform.




-- Question 1: Which users shared creative photos or videos (i.e. total sum of shares) more than 10 times in April 2024? 
-- This analysis will help determine which users are highly engaged in content sharing.


SELECT user_id, SUM(share_count) AS total_shares
FROM agg_daily_creative_shares
WHERE share_date BETWEEN '2024-04-01' AND '2024-04-30'
GROUP BY user_id
HAVING total_shares > 10;



-- Question 2: What is the average number of shares for creative content by users in May 2024, among users who 
-- shared at least once? We want to first get the aggregated shares per user in May 2024, and then calculate 
-- the average over all the users.

WITH total_shares AS (
SELECT user_id, SUM(share_count) AS total_shares
FROM agg_daily_creative_shares
WHERE share_date BETWEEN '2024-05-01' AND '2024-05-31'
GROUP BY user_id)
SELECT AVG(total_shares) AS avg_shares
FROM total_shares;



-- Question 3: For each Instagram user who shared creative content, what is the floor value of their average daily 
-- shares during the second quarter of 2024? Only include users with an average of at least 5 shares per day.

-- Note: The agg_daily_creative_shares table is at the grain of content type, user, and day. So make sure you're 
-- aggregating to the user-day level before calculating the average.

SELECT user_id, 
  FLOOR(SUM(share_count) / COUNT(DISTINCT share_date)) AS avg_daily_shares
FROM agg_daily_creative_shares
WHERE share_date BETWEEN '2024-04-01' AND '2024-06-30'
GROUP BY user_id
HAVING FLOOR(SUM(share_count) / COUNT(DISTINCT share_date)) >= 5
ORDER BY avg_daily_shares DESC;





-- WITH user_day_shares AS (
--   SELECT user_id, share_date, SUM(share_count) AS daily_total
--   FROM agg_daily_creative_shares
--   WHERE share_date BETWEEN '2024-04-01' AND '2024-06-30'
--   GROUP BY user_id, share_date
-- )
-- SELECT 
--   user_id,
--   FLOOR(AVG(daily_total)) AS avg_daily_shares
-- FROM user_day_shares
-- GROUP BY user_id
-- HAVING FLOOR(AVG(daily_total)) >= 5
-- ORDER BY avg_daily_shares DESC;


-- Your analysis of average daily shares per user during the second quarter of 2024, filtering for those with at 
-- least 5 shares per day, will help the Instagram Stories team identify highly engaged users. These insights can 
-- guide product managers in enhancing features that encourage content sharing and improve user interaction on the platform.


