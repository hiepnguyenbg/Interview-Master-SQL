-- Create a new database
CREATE DATABASE IF NOT EXISTS subscriber_growth_emerging_markets_db;
USE subscriber_growth_emerging_markets_db;

-- Drop existing tables (if any)
DROP TABLE IF EXISTS fact_marketing_spend;
DROP TABLE IF EXISTS fact_daily_subscriptions;
DROP TABLE IF EXISTS dimension_country;

-- Create dimension_country table
CREATE TABLE dimension_country (
    country_id INT PRIMARY KEY,
    country_name VARCHAR(100)
);

-- Insert data into dimension_country
INSERT INTO dimension_country (country_id, country_name) VALUES
(1, 'India'),
(2, 'Brazil'),
(3, 'South Africa'),
(4, 'Indonesia');

-- Create fact_marketing_spend table
CREATE TABLE fact_marketing_spend (
    spend_id INT PRIMARY KEY,
    country_id INT,
    amount_spent DECIMAL(12,2),
    campaign_date DATE,
    FOREIGN KEY (country_id) REFERENCES dimension_country(country_id)
);

-- Insert data into fact_marketing_spend
INSERT INTO fact_marketing_spend (spend_id, country_id, amount_spent, campaign_date) VALUES
(1, 1, 150000.50, '2024-01-15'),
(2, 2, 200000.75, '2024-02-10'),
(3, 3, 175000.00, '2024-03-05'),
(4, 1, 80000.00, '2024-01-25'),
(5, 2, 95000.50, '2024-02-20'),
(6, 3, 120000.00, '2024-03-15'),
(7, 4, 50000.00, '2024-01-30'),
(8, 4, 70000.00, '2024-03-10'),
(9, 1, 60000.00, '2024-02-05'),
(10, 2, 110000.00, '2024-03-25');

-- Create fact_daily_subscriptions table
CREATE TABLE fact_daily_subscriptions (
    subscription_id INT PRIMARY KEY,
    country_id INT,
    signup_date DATE,
    num_new_subscribers INT,
    FOREIGN KEY (country_id) REFERENCES dimension_country(country_id)
);

-- Insert data into fact_daily_subscriptions
INSERT INTO fact_daily_subscriptions (subscription_id, country_id, signup_date, num_new_subscribers) VALUES
(1, 1, '2024-01-16', 3000),
(2, 2, '2024-02-11', 4000),
(3, 3, '2024-03-06', 3500),
(4, 1, '2024-01-26', 2000),
(5, 2, '2024-02-21', 2500),
(6, 3, '2024-03-16', 2800),
(7, 4, '2024-01-31', 1500),
(8, 4, '2024-03-11', 1800),
(9, 1, '2024-02-06', 1700),
(10, 2, '2024-03-26', 3000);



-- As a Data Analyst on the Netflix Marketing Data Team, you are tasked with analyzing the 
-- efficiency of marketing spend in various emerging markets. Your analysis will focus on 
-- understanding the allocation of marketing budgets and the resulting subscriber acquisition. The 
-- end goal is to provide insights that will guide the team in optimizing marketing strategies and 
-- budget distribution across different countries.


-- Question 1: Retrieve the total marketing spend in each country for Q1 2024 to help inform budget distribution across regions.


SELECT country_name, SUM(amount_spent) AS total_spent
FROM fact_marketing_spend fms
JOIN dimension_country dc ON fms.country_id = dc.country_id
WHERE campaign_date BETWEEN '2024-01-01' AND '2024-03-31'
GROUP BY 1
ORDER BY 2 DESC;


-- Question 2: List the number of new subscribers acquired in each country (with name) during January 2024, 
-- renaming the subscriber count column to 'new_subscribers' for clearer reporting purposes.

SELECT country_name, SUM(num_new_subscribers) AS new_subscribers
FROM fact_daily_subscriptions fds
JOIN dimension_country dc ON fds.country_id = dc.country_id
WHERE signup_date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY 1
ORDER BY 2 DESC;


-- Question 3: Determine the average marketing spend per new subscriber for each country in Q1 2024 by 
-- rounding up to the nearest whole number to evaluate campaign efficiency.

WITH total_spend AS (
    SELECT country_id, SUM(amount_spent) AS total_spend
    FROM fact_marketing_spend
    WHERE campaign_date BETWEEN '2024-01-01' AND '2024-03-31'
    GROUP BY country_id
),
total_subs AS (
    SELECT country_id, SUM(num_new_subscribers) AS total_subs
    FROM fact_daily_subscriptions
    WHERE signup_date BETWEEN '2024-01-01' AND '2024-03-31'
    GROUP BY country_id
)
SELECT 
    dc.country_name,
    CEIL(ts.total_spend / tsb.total_subs) AS spend_per_subscriber
FROM total_spend ts
JOIN total_subs tsb ON ts.country_id = tsb.country_id
JOIN dimension_country dc ON dc.country_id = ts.country_id
ORDER BY spend_per_subscriber DESC;




