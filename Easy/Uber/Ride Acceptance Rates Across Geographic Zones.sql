-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS ride_acceptance_rates_db;
USE ride_acceptance_rates_db;

-- Step 2: Create the table
CREATE TABLE fct_zone_daily_rides (
    zone_name VARCHAR(50),
    ride_date DATE,
    total_requests INT,
    accepted_requests INT,
    declined_requests INT,
    acceptance_rate FLOAT
);

-- Step 3: Insert the data
INSERT INTO fct_zone_daily_rides (ride_date, zone_name, total_requests, acceptance_rate, accepted_requests, declined_requests) VALUES
('2024-04-10', 'Downtown', 100, 0.8, 80, 20),
('2024-05-01', 'Downtown', 90, 0.4444444444, 40, 50),
('2024-06-20', 'Downtown', 100, 0.9, 90, 10),
('2024-04-05', 'Suburban', 80, 0.75, 60, 20),
('2024-05-10', 'Suburban', 80, 0.375, 30, 50),
('2024-06-25', 'Suburban', 80, 0.625, 50, 30),
('2024-04-15', 'Airport', 110, 0.9090909091, 100, 10),
('2024-05-20', 'Airport', 32, 0.625, 20, 12),
('2024-06-05', 'Airport', 17, 0.2941176471, 5, 12),
('2024-04-20', 'Midtown', 80, 0.875, 70, 10),
('2024-05-15', 'Midtown', 80, 0.375, 30, 50),
('2024-05-30', 'Uptown', 80, 0.75, 60, 20),
('2024-06-10', 'Uptown', 80, 0.375, 30, 50),
('2024-04-25', 'Uptown', 80, 0.6875, 55, 25),
('2024-06-15', 'Uptown', 90, 0.7777777778, 70, 20);




-- You are a Product Analyst working to understand driver ride selection challenges across different geographic zones. 
-- The team wants to identify areas where drivers are less likely to accept ride requests. Your analysis will help 
-- optimize driver matching and improve ride acceptance strategies.





-- Question 1: For each geographic zone, what is the minimum acceptance rate observed during Quarter 2 2024? 
-- This information will help assess the worst-case driver acceptance performance by zone.


SELECT 
    zone_name, 
    MIN(acceptance_rate) AS min_acceptance_rate
FROM fct_zone_daily_rides
WHERE ride_date BETWEEN '2024-04-01' AND '2024-06-30'
GROUP BY zone_name;



-- Question 2: List the distinct geographic zones that had at least one day in Quarter 2 2024 with an acceptance rate below 50%. 
-- This list will be used to identify zones where drivers are generally more reluctant to accept rides.


SELECT DISTINCT zone_name
FROM fct_zone_daily_rides
WHERE ride_date BETWEEN '2024-04-01' AND '2024-06-30'
AND acceptance_rate < 0.5;




-- Question 3: Which geographic zone had the lowest ride acceptance rate on a single day in Q2 2024, while 
-- also having at least 10 declined ride requests on that same day? Recall that each row in the table 
-- represents data for a single day in a single geographic region.

-- This helps us identify specific zone-day combinations where acceptance was especially poor, to guide targeted improvements.


SELECT zone_name, acceptance_rate
FROM fct_zone_daily_rides
WHERE ride_date BETWEEN '2024-04-01' AND '2024-06-30'
  AND declined_requests >= 10
  AND acceptance_rate = (
    SELECT MIN(acceptance_rate)
    FROM fct_zone_daily_rides
    WHERE ride_date BETWEEN '2024-04-01' AND '2024-06-30'
      AND declined_requests >= 10
);



-- Your analyses will help Uber identify geographic zones and specific days where driver ride acceptance was particularly low, 
-- especially in areas with significant declined requests. This insight is valuable for optimizing driver matching and 
-- improving ride acceptance strategies.




