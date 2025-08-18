-- Create database
CREATE DATABASE IF NOT EXISTS device_integration_amazon_services_db;
USE device_integration_amazon_services_db;

-- Drop tables if they exist
DROP TABLE IF EXISTS fct_device_usage;
DROP TABLE IF EXISTS dim_device;
DROP TABLE IF EXISTS dim_service;

-- Create dim_device table
CREATE TABLE dim_device (
    device_id INT PRIMARY KEY,
    device_name VARCHAR(100)
);

-- Create dim_service table
CREATE TABLE dim_service (
    service_id INT PRIMARY KEY,
    service_name VARCHAR(100)
);

-- Create fct_device_usage table
CREATE TABLE fct_device_usage (
    usage_id INT PRIMARY KEY,
    device_id INT,
    service_id INT,
    usage_date DATE,
    usage_duration_minutes INT,
    FOREIGN KEY (device_id) REFERENCES dim_device(device_id),
    FOREIGN KEY (service_id) REFERENCES dim_service(service_id)
);

-- Insert data into dim_device
INSERT INTO dim_device (device_id, device_name) VALUES
(1, 'Echo Dot 4th Gen'),
(2, 'Fire TV Stick 4K'),
(3, 'Kindle Paperwhite 11th'),
(4, 'Echo Show 10'),
(5, 'Fire HD 10 Tablet');

-- Insert data into dim_service
INSERT INTO dim_service (service_id, service_name) VALUES
(1, 'Prime Video'),
(2, 'Amazon Music'),
(3, 'Alexa Skills');

-- Insert data into fct_device_usage
INSERT INTO fct_device_usage (usage_id, device_id, service_id, usage_date, usage_duration_minutes) VALUES
(1, 1, 1, '2024-07-05', 30),
(2, 2, 1, '2024-07-10', 45),
(3, 3, 2, '2024-07-15', 60),
(4, 4, 1, '2024-08-01', 120),
(5, 5, 2, '2024-08-05', 15),
(6, 1, 3, '2024-08-10', 25),
(7, 2, 2, '2024-08-15', 35),
(8, 3, 1, '2024-09-01', 50),
(9, 4, 2, '2024-09-05', 80),
(10, 5, 3, '2024-09-10', 10),
(11, 1, 1, '2024-07-20', 40),
(12, 2, 3, '2024-07-25', 20),
(13, 3, 2, '2024-08-20', 70),
(14, 4, 1, '2024-08-25', 90),
(15, 5, 2, '2024-09-15', 55),
(16, 1, 2, '2024-09-20', 35),
(17, 2, 1, '2024-09-25', 65),
(18, 3, 3, '2024-07-30', 5),
(19, 4, 2, '2024-08-30', 75),
(20, 5, 1, '2024-09-30', 85);




-- As a Data Analyst on the Amazon Devices team, you are tasked with evaluating the usage patterns 
-- of Amazon services on devices like Echo, Fire TV, and Kindle. Your goal is to categorize device usage, 
-- assess overall engagement levels, and analyze the contribution of Prime Video and Amazon Music to total usage. 
-- This analysis will inform strategies to optimize service offerings and improve customer satisfaction.


-- Question 1: The team wants to identify the total usage duration of the services for each device type by 
-- extracting the primary device category from the device name for the period from July 1, 2024 to September 30, 2024. 
-- The primary device category is derived from the first word of the device name.


SELECT 
    SUBSTRING_INDEX(dd.device_name, ' ', 1) AS device_category,
    SUM(fdu.usage_duration_minutes) AS total_usage
FROM fct_device_usage fdu
JOIN dim_device dd ON fdu.device_id = dd.device_id
WHERE fdu.usage_date BETWEEN '2024-07-01' AND '2024-09-30'
GROUP BY device_category
ORDER BY total_usage DESC;


-- Question 2: The team also wants to label the usage of each device category into 'Low' or 'High' based on usage duration 
-- from July 1, 2024 to September 30, 2024. If the total usage time was less than 300 minutes, we'll categorize it as 'Low'. 
-- Otherwise, we'll categorize it as 'High'.


WITH total_usage as (
SELECT 
    SUBSTRING_INDEX(dd.device_name, ' ', 1) AS device_category,
    SUM(fdu.usage_duration_minutes) AS total_usage
FROM fct_device_usage fdu
JOIN dim_device dd ON fdu.device_id = dd.device_id
WHERE fdu.usage_date BETWEEN '2024-07-01' AND '2024-09-30'
GROUP BY device_category)
SELECT *,
    CASE 
        WHEN total_usage < 300 THEN 'Low'
        ELSE 'High'
    END AS categorization
FROM total_usage;


-- Question 3: The team is considering bundling the Prime Video and Amazon Music subscription. They want 
-- to understand what percentage of total usage time comes from Prime Video and Amazon Music services respectively. 
-- Please use data from July 1, 2024 to September 30, 2024.


WITH prime_music AS (
  SELECT usage_duration_minutes, service_name
  FROM fct_device_usage fdu
  JOIN dim_service ds ON fdu.service_id = ds.service_id
  WHERE fdu.usage_date BETWEEN '2024-07-01' AND '2024-09-30'
)
SELECT
  SUM(CASE WHEN service_name = 'Prime Video' THEN usage_duration_minutes ELSE 0 END) * 1.0 /
  SUM(usage_duration_minutes) AS pct_prime_video,

  SUM(CASE WHEN service_name = 'Amazon Music' THEN usage_duration_minutes ELSE 0 END) * 1.0 /
  SUM(usage_duration_minutes) AS pct_amazon_music
FROM prime_music;










