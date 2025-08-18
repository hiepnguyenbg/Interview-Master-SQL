-- Create database and use it
CREATE DATABASE IF NOT EXISTS ar_filter_engagement_metrics_db;
USE ar_filter_engagement_metrics_db;

-- Drop tables if they exist
DROP TABLE IF EXISTS ar_filter_engagements;
DROP TABLE IF EXISTS ar_filters;

-- Create ar_filters table
CREATE TABLE ar_filters (
  filter_id INT PRIMARY KEY,
  filter_name VARCHAR(100) NOT NULL
);

-- Create ar_filter_engagements table
CREATE TABLE ar_filter_engagements (
  engagement_id INT PRIMARY KEY,
  filter_id INT,
  interaction_count INT,
  engagement_date DATE,
  FOREIGN KEY (filter_id) REFERENCES ar_filters(filter_id)
);

-- Insert data into ar_filters
INSERT INTO ar_filters (filter_id, filter_name) VALUES
(1, 'Summer Vibes'),
(2, 'Golden Hour Glow'),
(3, 'Tropical Escape'),
(4, 'City Lights'),
(5, 'Retro Film'),
(6, 'Artistic Strokes'),
(7, 'Nature Bloom'),
(8, 'Sparkling Dust'),
(9, 'Dreamy Haze'),
(10, 'Neon Dreams'),
(11, 'Ocean Breeze'),
(12, 'Vintage Look'),
(13, 'Abstract Lines'),
(14, 'Rainbow Effect'),
(15, 'Glitter Bomb');

-- Insert data into ar_filter_engagements
INSERT INTO ar_filter_engagements (filter_id, engagement_id, engagement_date, interaction_count) VALUES
(1, 1, '2024-07-05', 150),
(2, 2, '2024-07-10', 200),
(1, 3, '2024-07-12', 180),
(3, 4, '2024-07-15', 120),
(2, 6, '2024-07-25', 220),
(5, 7, '2024-07-28', 110),
(1, 8, '2024-07-30', 160),
(6, 9, '2024-08-02', 130),
(7, 10, '2024-08-05', 1050),
(6, 12, '2024-08-12', 150),
(9, 14, '2024-08-20', 950),
(10, 16, '2024-08-25', 1010),
(9, 18, '2024-08-30', 800),
(11, 19, '2024-09-03', 1400),
(12, 20, '2024-09-07', 1550),
(11, 21, '2024-09-10', 1450),
(13, 22, '2024-09-12', 1250),
(14, 23, '2024-09-15', 1180),
(12, 24, '2024-09-18', 1600),
(15, 25, '2024-09-20', 1320),
(11, 26, '2024-09-23', 1380),
(13, 27, '2024-09-25', 1200),
(14, 28, '2024-09-28', 1100),
(1, 29, '2024-07-01', 95),
(2, 30, '2024-07-03', 110),
(3, 31, '2024-07-08', 85),
(5, 33, '2024-07-16', 98),
(6, 34, '2024-07-19', 105),
(9, 37, '2024-07-29', 150),
(10, 38, '2024-08-01', 165),
(11, 39, '2024-08-06', 980),
(12, 40, '2024-08-09', 890),
(13, 41, '2024-08-14', 920),
(14, 42, '2024-08-18', 850),
(15, 43, '2024-08-23', 990),
(1, 44, '2024-09-01', 80),
(2, 45, '2024-09-05', 90),
(3, 46, '2024-09-09', 75),
(5, 48, '2024-09-17', 88),
(6, 49, '2024-09-21', 95);


-- As a member of the Marketing Analytics team at Meta, you are tasked with evaluating the 
-- performance of branded AR filters. Your goal is to identify which filters are driving the highest 
-- user interactions and shares to inform future campaign strategies for brands using the Spark AR 
-- platform. By analyzing engagement data, your team aims to provide actionable insights that will 
-- enhance campaign effectiveness and audience targeting.


-- Question 1: Which AR filters have generated user interactions in July 2024? List the filters by name.

SELECT DISTINCT af.filter_name
FROM ar_filter_engagements afe
JOIN ar_filters af ON afe.filter_id = af.filter_id
WHERE engagement_date BETWEEN '2024-07-01' AND '2024-07-31'
ORDER BY af.filter_name;


-- Question 2: How many total interactions did each AR filter receive in August 2024? Return only filter 
-- names that received over 1000 interactions, and their respective interaction counts.


SELECT 
    af.filter_name, SUM(interaction_count) AS total_interactions
FROM
    ar_filter_engagements afe
        JOIN
    ar_filters af ON afe.filter_id = af.filter_id
WHERE
    engagement_date BETWEEN '2024-08-01' AND '2024-08-31'
GROUP BY 1
HAVING total_interactions > 1000
ORDER BY 2 DESC;



-- Question 3: What are the top 3 AR filters with the highest number of interactions in September 2024, and 
-- how many interactions did each receive?

SELECT 
    af.filter_name, SUM(interaction_count) AS total_interactions
FROM
    ar_filter_engagements afe
        JOIN
    ar_filters af ON afe.filter_id = af.filter_id
WHERE
    engagement_date BETWEEN '2024-09-01' AND '2024-09-30'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 3;



