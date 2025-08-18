-- Create the database
CREATE DATABASE IF NOT EXISTS linkedin_messaging_user_engagement_db;

-- Use the database
USE linkedin_messaging_user_engagement_db;

-- Create the fct_messages table
CREATE TABLE fct_messages (
    message_id INT PRIMARY KEY,
    user_id INT NOT NULL,
    message_sent_date DATE NOT NULL
);

-- Insert the data
INSERT INTO fct_messages (user_id, message_id, message_sent_date) VALUES
(1, 1, '2024-04-01'), (1, 2, '2024-04-02'), (1, 3, '2024-04-03'), (1, 4, '2024-04-04'), (1, 5, '2024-04-05'),
(1, 6, '2024-04-06'), (1, 7, '2024-04-07'), (1, 8, '2024-04-08'), (1, 9, '2024-04-09'), (1, 10, '2024-04-10'),
(1, 11, '2024-04-11'), (1, 12, '2024-04-12'), (1, 13, '2024-04-13'), (1, 14, '2024-04-14'), (1, 15, '2024-04-15'),
(1, 16, '2024-04-16'), (1, 17, '2024-04-17'), (1, 18, '2024-04-18'), (1, 19, '2024-04-19'), (1, 20, '2024-04-20'),
(1, 21, '2024-04-21'), (1, 22, '2024-04-22'), (1, 23, '2024-04-23'), (1, 24, '2024-04-24'), (1, 25, '2024-04-25'),
(1, 26, '2024-04-26'), (1, 27, '2024-04-27'), (1, 28, '2024-04-28'), (1, 29, '2024-04-29'), (1, 30, '2024-04-30'),
(1, 31, '2024-04-01'), (1, 32, '2024-04-02'), (1, 33, '2024-04-03'), (1, 34, '2024-04-04'), (1, 35, '2024-04-05'),
(1, 36, '2024-04-06'), (1, 37, '2024-04-07'), (1, 38, '2024-04-08'), (1, 39, '2024-04-09'), (1, 40, '2024-04-10'),
(1, 41, '2024-04-11'), (1, 42, '2024-04-12'), (1, 43, '2024-04-13'), (1, 44, '2024-04-14'), (1, 45, '2024-04-15'),
(1, 46, '2024-04-16'), (1, 47, '2024-04-17'), (1, 48, '2024-04-18'), (1, 49, '2024-04-19'), (1, 50, '2024-04-20'),
(1, 51, '2024-04-21'), (1, 52, '2024-04-22'), (1, 53, '2024-04-23'), (1, 54, '2024-04-24'), (1, 55, '2024-04-25'),
(2, 56, '2024-04-10'), (2, 57, '2024-04-18'), (2, 58, '2024-04-25'), (3, 59, '2024-04-12'), (3, 60, '2024-04-22'),
(4, 61, '2024-05-05'), (5, 62, '2024-06-10'), (6, 63, '2024-03-30'), (7, 64, '2024-07-01'), (2, 65, '2024-05-15');






-- You are a Product Analyst on the LinkedIn Messaging team focused on understanding user engagement with messaging 
-- features. Your team is interested in analyzing messaging patterns to identify key metrics that reflect user 
-- interaction and engagement levels. The aim is to leverage these insights to enhance the professional communication 
-- experience on the platform.





-- Question 1: What is the total number of messages sent during April 2024? This information will help us quantify 
-- overall engagement as a baseline for targeted product enhancements.


SELECT COUNT(*) AS total_messages
FROM fct_messages
WHERE message_sent_date BETWEEN '2024-04-01' AND '2024-04-30'; 


-- Question 2: What is the average number of messages sent per user during April 2024? Round your result to the 
-- nearest whole number. This metric provides insight into individual engagement levels for refining our communication features.


SELECT ROUND(COUNT(*) / COUNT(DISTINCT user_id)) AS avg_messages
FROM fct_messages
WHERE message_sent_date BETWEEN '2024-04-01' AND '2024-04-30';




-- Question 3: What percentage of users sent more than 50 messages during April 2024? 
-- This calculation will help identify highly engaged users and support recommendations for enhancing messaging interactions.

WITH message_count AS (
  SELECT user_id, COUNT(*) AS total_messages
  FROM fct_messages
  WHERE message_sent_date BETWEEN '2024-04-01' AND '2024-04-30'
  GROUP BY user_id
)
SELECT ROUND(100.0 * COUNT(CASE WHEN total_messages > 50 THEN 1 END) / COUNT(*), 2) AS over_fifty_pct
FROM message_count;



-- Your analyses will help the LinkedIn Messaging team understand overall engagement, average user activity, and identify 
-- highly engaged users. These insights are valuable for tailoring product enhancements to improve professional 
-- communication on the platform.










