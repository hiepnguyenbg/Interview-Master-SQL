-- Step 0: Create the database
CREATE DATABASE photo_sharing_user_engagement_db;

-- Step 1: Use the database
USE photo_sharing_user_engagement_db;

-- Step 2: Create the dim_user table
CREATE TABLE dim_user (
    user_id INT PRIMARY KEY,
    age INT,
    country VARCHAR(100)
);

-- Step 3: Insert data into dim_user
INSERT INTO dim_user (user_id, age, country) VALUES
(1, 16, 'Canada'),
(2, 55, 'Mexico'),
(3, 30, 'United States'),
(4, 17, 'United States'),
(5, 60, 'United States'),
(6, 22, 'France'),
(7, 15, 'Germany'),
(8, 51, 'Brazil'),
(9, 40, 'India'),
(10, 65, 'United States'),
(11, 14, 'United Kingdom'),
(12, 33, 'United States'),
(13, 70, 'Japan'),
(14, 18, 'Australia'),
(15, 50, 'United States');

-- Step 4: Create the fct_photo_sharing table
CREATE TABLE fct_photo_sharing (
    photo_id INT PRIMARY KEY,
    user_id INT,
    shared_date DATE,
    FOREIGN KEY (user_id) REFERENCES dim_user(user_id)
);

-- Step 5: Insert data into fct_photo_sharing
INSERT INTO fct_photo_sharing (photo_id, user_id, shared_date) VALUES
(1, 1, '2024-07-05'),
(2, 2, '2024-07-10'),
(3, 3, '2024-07-15'),
(4, 4, '2024-07-20'),
(5, 5, '2024-07-25'),
(6, 7, '2024-07-12'),
(7, 8, '2024-07-28'),
(8, 10, '2024-07-30'),
(9, 1, '2024-08-05'),
(10, 2, '2024-08-15'),
(11, 6, '2024-08-20'),
(12, 7, '2024-08-10'),
(13, 8, '2024-08-25'),
(14, 11, '2024-08-28'),
(15, 1, '2024-09-03'),
(16, 2, '2024-09-07'),
(17, 8, '2024-09-15'),
(18, 11, '2024-09-20'),
(19, 13, '2024-09-25'),
(20, 4, '2024-09-10');


-- As a Product Analyst on the Facebook Photos team, you are tasked with understanding user engagement with 
-- the photo sharing feature across different age and geographic segments. Your team is particularly 
-- interested in how users under 18 or over 50, as well as international users, are utilizing these features. 
-- The insights will guide your team in tailoring product strategies and enhancements to boost engagement among 
-- these key user segments.



-- Question 1: How many photos were shared by users who are either under 18 years old or over 50 years old 
-- during July 2024? This metric will help us understand if these age segments are engaging with the photo sharing feature.


SELECT COUNT(photo_id) AS n_photos
FROM fct_photo_sharing fps
JOIN dim_user du ON fps.user_id = du.user_id
WHERE (du.age < 18 OR du.age > 50)
  AND fps.shared_date BETWEEN '2024-07-01' AND '2024-07-31';


-- Question 2: What are the user IDs and the total number of photos shared by users who are not from the United States 
-- during August 2024?  This analysis will help us identify engagement patterns among international users.

SELECT fps.user_id, COUNT(fps.photo_id) AS n_photos
FROM fct_photo_sharing fps
JOIN dim_user du ON fps.user_id = du.user_id
WHERE du.country <> 'United States'
  AND fps.shared_date BETWEEN '2024-08-01' AND '2024-08-31'
GROUP BY fps.user_id;


-- Question 3: What is the total number of photos shared by users who are either under 18 years old or over 50 years
-- old and who are not from the United States during the third quarter of 2024? This measure will inform us if there 
-- are significant differences in usage across these age and geographic segments.


SELECT COUNT(fps.photo_id) AS n_photos
FROM fct_photo_sharing fps
JOIN dim_user du ON fps.user_id = du.user_id
WHERE du.country <> 'United States'
  AND fps.shared_date BETWEEN '2024-07-01' AND '2024-09-30'
  AND (du.age < 18 OR du.age > 50);








