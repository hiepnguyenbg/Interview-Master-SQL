-- Create the database
CREATE DATABASE IF NOT EXISTS prime_video_content_performance_db;
USE prime_video_content_performance_db;

-- Create the table
CREATE TABLE content_views_daily_agg (
    content_id INT,
    category VARCHAR(50),
    view_date DATE,
    views INT
);

-- Insert data
INSERT INTO content_views_daily_agg (views, category, view_date, content_id) VALUES
(60000, 'Action', '2024-07-15', 101),
(50000, 'Action', '2024-08-05', 101),
(300000, 'Action', '2024-09-10', 101),
(250000, 'Action', '2024-09-20', 101),
(40000, 'Drama', '2024-08-12', 102),
(35000, 'Drama', '2024-09-15', 102),
(45000, 'Drama', '2024-09-25', 102),
(15000, 'Drama', '2024-07-20', 102),
(25000, 'Comedy', '2024-08-18', 103),
(30000, 'Comedy', '2024-08-28', 103),
(20000, 'Comedy', '2024-09-05', 103),
(15000, 'Comedy', '2024-07-22', 103),
(120000, 'Thriller', '2024-08-31', 104),
(150000, 'Thriller', '2024-09-12', 104),
(50000, 'Thriller', '2024-07-10', 104),
(20000, 'Documentary', '2024-08-22', 105),
(30000, 'Documentary', '2024-09-25', 105),
(10000, 'Documentary', '2024-07-30', 105);





-- As a Product Analyst on the Prime Video team, you are tasked with evaluating content engagement across various 
-- movie and show categories. Your team aims to identify which genres are most engaging to viewers to prioritize 
-- content acquisition and enhance recommendation strategies. The end goal is to optimize content investments and 
-- improve viewer satisfaction by focusing on high-performing categories.




-- Question 1: What is the aggregated view events across each content category in August 2024? This information will 
-- help the Prime Video team understand which content genres are engaging users during that month.

SELECT category, SUM(views) AS total_views
FROM content_views_daily_agg
WHERE view_date BETWEEN '2024-08-01' AND '2024-08-31'
GROUP BY category
ORDER BY total_views DESC;



-- Question 2: Which content categories accumulated over 100,000 total views during the third quarter of 2024? 
-- This analysis will help identify the genres that are attracting a high volume of viewer engagement.


SELECT category, SUM(views) AS total_views
FROM content_views_daily_agg
WHERE view_date BETWEEN '2024-07-01' AND '2024-09-30'
GROUP BY category
HAVING SUM(views) > 100000; 



-- Question 3: In September 2024, for content categories that received more than 500,000 aggregated views, 
-- what is the total views for the month for each content category?


SELECT category, SUM(views) AS total_views
FROM content_views_daily_agg
WHERE view_date BETWEEN '2024-09-01' AND '2024-09-30'
GROUP BY category
HAVING SUM(views) > 500000;





-- Your analyses will help the Prime Video team understand which content genres are most engaging during specific time frames, 
-- allowing them to prioritize content acquisition and improve recommendation strategies. This ultimately supports optimizing 
-- content investments and enhancing viewer satisfaction.




