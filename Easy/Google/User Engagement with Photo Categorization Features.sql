-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS user_engagement_photo_categorization_db;

-- Step 2: Use the database
USE user_engagement_photo_categorization_db;

-- Step 3: Create the table
CREATE TABLE automatic_photo_categorization (
    photo_id INT PRIMARY KEY,
    user_id INT,
    categorization_date DATE
);

-- Step 4: Insert the data
INSERT INTO automatic_photo_categorization (user_id, photo_id, categorization_date) VALUES
(1, 1, '2024-01-03'),
(2, 2, '2024-01-15'),
(3, 3, '2024-01-20'),
(4, 4, '2024-02-05'),
(5, 5, '2024-02-10'),
(1, 6, '2024-02-15'),
(2, 7, '2024-02-20'),
(3, 8, '2024-03-01'),
(4, 9, '2024-03-05'),
(5, 10, '2024-03-10'),
(6, 11, '2024-01-08'),
(7, 12, '2024-01-18'),
(8, 13, '2024-02-12'),
(9, 14, '2024-02-22'),
(10, 15, '2024-03-15'),
(1, 16, '2024-03-20'),
(2, 17, '2024-03-25'),
(3, 18, '2024-01-12'),
(4, 19, '2024-02-18'),
(5, 20, '2024-03-22'),
(6, 21, '2024-01-25'),
(7, 22, '2024-02-28'),
(8, 23, '2024-03-08'),
(9, 24, '2024-01-30'),
(10, 25, '2024-02-07'),
(1, 26, '2024-03-12'),
(2, 27, '2024-01-22'),
(3, 28, '2024-02-14'),
(4, 29, '2024-03-18'),
(5, 30, '2024-01-27'),
(6, 31, '2024-02-03'),
(7, 32, '2024-03-05'),
(8, 33, '2024-01-10'),
(9, 34, '2024-02-25'),
(10, 35, '2024-03-30'),
(1, 36, '2024-02-19'),
(2, 37, '2024-03-02'),
(3, 38, '2024-01-14'),
(4, 39, '2024-02-21'),
(5, 40, '2024-03-25');







-- As a Data Analyst on the Google Photos Machine Learning Team, you are tasked with understanding user engagement 
-- with our automatic photo categorization features. Your team aims to quantify how many photos have been categorized 
-- and identify the unique users interacting with this functionality. By analyzing this data, you will help prioritize 
-- enhancements to improve user experience and engagement with our photo management tools.




-- Question 1: We need to measure initial user engagement with the categorization features. How many photos have 
-- been categorized by the system in January 2024?


SELECT COUNT(photo_id) AS n_photos
FROM automatic_photo_categorization
WHERE categorization_date BETWEEN '2024-01-01' AND '2024-01-31';



-- Question 2: What is the total number of unique users who have interacted with the categorization feature in February 2024?

SELECT COUNT(DISTINCT user_id) AS n_users
FROM automatic_photo_categorization
WHERE categorization_date BETWEEN '2024-02-01' AND '2024-02-28';



-- Question 3: For March 2024, calculate the total number of categorized photos per user and rename the resulting column to 
-- 'total_categorized_photos'. We want to identify the most active users for user research purposes.

SELECT user_id, COUNT(photo_id) AS total_categorized_photos
FROM automatic_photo_categorization
WHERE categorization_date BETWEEN '2024-03-01' AND '2024-03-31'
GROUP BY 1
ORDER BY 2 DESC;





-- Your analyses will help the Google Photos Machine Learning Team understand user engagement with the automatic photo 
-- categorization feature by quantifying categorized photos and identifying active users. This insight is crucial for 
-- prioritizing feature enhancements to improve user experience and engagement.