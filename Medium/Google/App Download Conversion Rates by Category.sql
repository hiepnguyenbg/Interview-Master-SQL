-- Create database
CREATE DATABASE IF NOT EXISTS app_download_conversion_db;
USE app_download_conversion_db;

-- Drop tables if they already exist
DROP TABLE IF EXISTS fct_app_downloads;
DROP TABLE IF EXISTS fct_app_browsing;
DROP TABLE IF EXISTS dim_app;

-- Create dim_app table
CREATE TABLE dim_app (
    app_id INT PRIMARY KEY,
    app_name VARCHAR(100),
    app_type VARCHAR(20),
    category VARCHAR(50)
);

-- Create fct_app_browsing table
CREATE TABLE fct_app_browsing (
    app_id INT,
    browse_date DATE,
    browse_count INT,
    FOREIGN KEY (app_id) REFERENCES dim_app(app_id)
);

-- Create fct_app_downloads table
CREATE TABLE fct_app_downloads (
    app_id INT,
    download_date DATE,
    download_count INT,
    FOREIGN KEY (app_id) REFERENCES dim_app(app_id)
);

-- Insert data into dim_app
INSERT INTO dim_app (app_id, app_name, app_type, category) VALUES
(1, 'FunPlay', 'Free', 'Games'),
(2, 'TaskMaster', 'Premium', 'Productivity'),
(3, 'HealthPlus', 'Free', 'Health'),
(4, 'EduLearn', 'Premium', 'Education'),
(5, 'StreamFun', 'Free', 'Entertainment'),
(6, 'FinancePro', 'Premium', 'Finance'),
(7, 'TravelEasy', 'Free', 'Travel'),
(8, 'LifeStyleHub', 'Premium', 'Lifestyle'),
(9, 'UtilityMax', 'Free', 'Utilities'),
(10, 'SocialConnect', 'Free', 'Social'),
(11, 'PhotoSnap', 'Premium', 'Photography'),
(12, 'NewsFlash', 'Free', 'News'),
(13, 'BookReader', 'Premium', 'Books'),
(14, 'MusicMix', 'Free', 'Music'),
(15, 'WeatherNow', 'Premium', 'Weather');

-- Insert data into fct_app_browsing
INSERT INTO fct_app_browsing (app_id, browse_date, browse_count) VALUES
(1, '2024-10-05', 150),
(2, '2024-10-15', 200),
(3, '2024-11-01', 0),
(4, '2024-11-20', 120),
(5, '2024-12-10', 300),
(6, '2024-12-15', 80),
(7, '2024-10-25', 50),
(8, '2024-11-05', 0),
(9, '2024-11-25', 90),
(10, '2024-12-20', 250),
(11, '2024-10-10', 130),
(12, '2024-11-15', 0),
(13, '2024-12-05', 70),
(14, '2024-10-20', 180),
(15, '2024-11-30', 60),
(1, '2024-12-01', 100),
(2, '2024-12-12', 150),
(4, '2024-12-18', 110),
(5, '2024-10-30', 220),
(10, '2024-11-22', 160);

-- Insert data into fct_app_downloads
INSERT INTO fct_app_downloads (app_id, download_date, download_count) VALUES
(1, '2024-10-06', 30),
(2, '2024-10-16', 50),
(3, '2024-11-02', 0),
(4, '2024-11-21', 40),
(5, '2024-12-11', 90),
(6, '2024-12-16', 20),
(7, '2024-10-26', 10),
(8, '2024-11-06', 0),
(9, '2024-11-26', 15),
(10, '2024-12-21', 45),
(11, '2024-10-11', 35),
(12, '2024-11-16', 0),
(13, '2024-12-06', 25),
(14, '2024-10-21', 40),
(15, '2024-11-30', 18),
(1, '2024-12-02', 25),
(2, '2024-12-13', 35),
(4, '2024-12-19', 30),
(5, '2024-10-31', 60),
(10, '2024-11-23', 40);



-- You are on the Google Play store's App Marketplace team. You and your team want to 
-- understand how different app categories convert from browsing to actual downloads. This 
-- analysis is critical in informing future product placement and marketing strategies for app developers and users.


-- Question 1: The marketplace team wants to identify high and low performing app categories. Provide the total 
-- downloads for the app categories for November 2024. If there were no downloads for that category, return the value as 0.

WITH download_category AS (
    SELECT 
        da.category,
        IFNULL(fad.download_count, 0) AS download_count
    FROM dim_app da
    LEFT JOIN fct_app_downloads fad 
        ON da.app_id = fad.app_id
        AND fad.download_date BETWEEN '2024-11-01' AND '2024-11-30'
)

SELECT 
    category, 
    SUM(download_count) AS total_download
FROM download_category
GROUP BY category
ORDER BY total_download DESC;




-- Question 2: Our team's goal is download conversion rate — defined as downloads per browse event. For each 
-- app category, calculate the download conversion rate in December, removing categories where browsing counts are zero.



WITH total_browsing AS (
    SELECT app_id, SUM(browse_count) AS total_browsing
    FROM fct_app_browsing
    WHERE browse_date BETWEEN '2024-12-01' AND '2024-12-31'
    GROUP BY app_id
),
total_downloads AS (
    SELECT app_id, SUM(download_count) AS total_downloads
    FROM fct_app_downloads
    WHERE download_date BETWEEN '2024-12-01' AND '2024-12-31'
    GROUP BY app_id
)
SELECT 
    da.category, 
    SUM(COALESCE(td.total_downloads, 0)) / SUM(tb.total_browsing) AS conversion_rate
FROM dim_app da
JOIN total_browsing tb ON da.app_id = tb.app_id
LEFT JOIN total_downloads td ON da.app_id = td.app_id
GROUP BY da.category
HAVING SUM(tb.total_browsing) > 0
ORDER BY conversion_rate DESC;


-- Question 3: The team wants to compare conversion rates between free and premium apps across all 
-- categories. Combine the conversion data for both app types to present a unified view for Q4 2024.


WITH total_browsing AS (
    SELECT app_id, SUM(browse_count) AS total_browsing
    FROM fct_app_browsing
    WHERE browse_date BETWEEN '2024-10-01' AND '2024-12-31'
    GROUP BY app_id
),
total_downloads AS (
    SELECT app_id, SUM(download_count) AS total_downloads
    FROM fct_app_downloads
    WHERE download_date BETWEEN '2024-10-01' AND '2024-12-31'
    GROUP BY app_id
)
SELECT 
    da.app_type, 
    SUM(COALESCE(td.total_downloads, 0)) / SUM(tb.total_browsing) AS conversion_rate
FROM dim_app da
JOIN total_browsing tb ON da.app_id = tb.app_id
LEFT JOIN total_downloads td ON da.app_id = td.app_id
GROUP BY da.app_type
ORDER BY conversion_rate DESC;

