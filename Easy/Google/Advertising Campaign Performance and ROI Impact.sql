-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS ad_campaign_performance_roi_db;

-- Step 2: Use the database
USE ad_campaign_performance_roi_db;

-- Step 3: Create the ad_campaigns table
CREATE TABLE ad_campaigns (
    campaign_id INT PRIMARY KEY,
    campaign_name VARCHAR(100),
    start_date DATE,
    conversions INT,
    revenue DECIMAL(10,2),
    ad_type VARCHAR(50)
);

-- Step 4: Insert data into ad_campaigns
INSERT INTO ad_campaigns (campaign_id, campaign_name, start_date, conversions, revenue, ad_type)
VALUES
(1, 'Spring Sale', '2024-04-01', 150, 1200.50, 'Search'),
(2, 'Summer Launch', '2024-05-05', 130, 950.00, 'Display'),
(3, 'April Discounts', '2024-04-10', 200, 1800.75, 'Video'),
(4, 'May Madness', '2024-05-15', 110, 500.00, 'Search'),
(5, 'June Offers', '2024-06-01', 0, 0.00, 'Display'),
(6, 'April Promo', '2024-04-20', 180, 1500.00, 'Shopping'),
(7, 'May Deals', '2024-05-10', 105, 400.00, 'Video'),
(8, 'June Bonanza', '2024-06-10', 0, 0.00, 'Search'),
(9, 'April Flash Sale', '2024-04-15', 160, 1300.00, 'Display'),
(10, 'May Extravaganza', '2024-05-20', 115, 600.00, 'Shopping'),
(11, 'June Surprise', '2024-06-15', 0, 0.00, 'Video');





-- As a Data Analyst on the Google Ads Performance Analytics team, you are tasked with evaluating the performance 
-- of recent ad campaigns to identify trends in conversions and revenue generation. Your team aims to uncover 
-- high-performing campaigns, recognize effective ad types, and pinpoint campaigns that failed to generate revenue. 
-- By leveraging these insights, you will guide strategic recommendations to enhance overall campaign performance.



-- Question 1: What are the top 5 ad campaign IDs with the highest number of conversions, that started in April 2024?


SELECT campaign_id, conversions
FROM ad_campaigns
WHERE start_date BETWEEN '2024-04-01' AND '2024-04-30'
ORDER BY conversions DESC
LIMIT 5;



-- Question 2: Identify the distinct ad types with more than 100 conversions that started in May 2024.


SELECT ad_type, SUM(conversions) AS total_conversions
FROM ad_campaigns
WHERE start_date BETWEEN '2024-05-01' AND '2024-05-31'
GROUP BY ad_type
HAVING SUM(conversions) > 100;





-- Question 3: Of the campaigns that started in June 2024, find the ones that did not generate any revenue. 
-- Please list the campaign names and start dates.


SELECT campaign_name, start_date
FROM ad_campaigns
WHERE start_date BETWEEN '2024-06-01' AND '2024-06-30'
AND revenue = 0;



-- Your analyses will help the Google Ads Performance Analytics team identify which campaigns are driving the 
-- most conversions, which ad types are effective, and which campaigns are underperforming in terms of revenue. 
-- These insights are crucial for making strategic decisions to optimize future ad campaigns and improve overall performance.
