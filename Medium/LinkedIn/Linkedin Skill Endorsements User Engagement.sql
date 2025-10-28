-- Create the database
CREATE DATABASE IF NOT EXISTS linkedin_skill_endorsements_db;
USE linkedin_skill_endorsements_db;

-- Create dim_users table
CREATE TABLE dim_users (
  user_id INT PRIMARY KEY,
  user_name VARCHAR(100),
  profile_creation_date DATE
);

-- Insert data into dim_users
INSERT INTO dim_users (user_id, user_name, profile_creation_date) VALUES
(1, 'Alice', '2024-07-01'),
(2, 'Bob', '2024-07-02'),
(3, 'Charlie', '2024-07-03'),
(4, 'Dawn''s', '2024-07-04'),
(5, 'Eve', '2024-07-05'),
(6, 'Frank', '2024-07-06'),
(7, 'Grace', '2024-07-07'),
(8, 'Heidi', '2024-07-08'),
(9, 'Ivan', '2024-07-09'),
(10, 'Judy', '2024-07-10');

-- Create dim_skills table
CREATE TABLE dim_skills (
  skill_id INT PRIMARY KEY,
  skill_name VARCHAR(100),
  skill_category VARCHAR(50)
);

-- Insert data into dim_skills
INSERT INTO dim_skills (skill_id, skill_name, skill_category) VALUES
(101, 'Python', 'TECHNICAL'),
(102, 'Java', 'TECHNICAL'),
(103, 'Project Management', 'MANAGEMENT'),
(104, 'Leadership', 'MANAGEMENT'),
(105, 'Data Analysis', 'TECHNICAL'),
(106, 'Communication', 'SOFT'),
(107, 'Networking', 'TECHNICAL'),
(108, 'Strategic Planning', 'MANAGEMENT'),
(109, 'SQL', 'TECHNICAL'),
(110, 'Teamwork', 'SOFT');

-- Create fct_skill_endorsements table
CREATE TABLE fct_skill_endorsements (
  endorsement_id INT PRIMARY KEY,
  user_id INT,
  skill_id INT,
  endorsement_date DATE,
  FOREIGN KEY (user_id) REFERENCES dim_users(user_id),
  FOREIGN KEY (skill_id) REFERENCES dim_skills(skill_id)
);

-- Insert data into fct_skill_endorsements
INSERT INTO fct_skill_endorsements (user_id, skill_id, endorsement_id, endorsement_date) VALUES
(1, 101, 1, '2024-07-05'),
(1, 105, 2, '2024-08-10'),
(1, 103, 3, '2024-09-15'),
(2, 103, 4, '2024-07-20'),
(2, 104, 5, '2024-08-22'),
(3, 102, 6, '2024-07-25'),
(3, 102, 7, '2024-08-05'),
(3, 109, 8, '2024-09-10'),
(4, 104, 9, '2024-09-12'),
(5, 101, 10, '2024-09-14'),
(5, 102, 11, '2024-08-18'),
(7, 106, 12, '2024-07-07'),
(8, 107, 13, '2024-08-12'),
(8, 109, 14, '2024-08-20'),
(9, 108, 15, '2024-09-18'),
(9, 109, 16, '2024-07-03'),
(10, 110, 17, '2024-08-25'),
(10, 103, 18, '2024-09-22'),
(4, 108, 19, '2024-07-15'),
(2, 105, 20, '2024-08-30');






-- As a Product Analyst on the LinkedIn Recommendations team, you are exploring how skill endorsements 
-- contribute to professional profiles. Your team is focused on understanding the patterns and factors 
-- that drive meaningful skill recognition among users. The goal is to identify key metrics that reflect 
-- how endorsements validate skills in different categories, such as 'TECHNICAL' and 'MANAGEMENT'.




-- Question 1: What percentage of users have at least one skill endorsed by others during July 2024?


-- WITH user_endorsement AS (
--     SELECT DISTINCT user_id
--     FROM fct_skill_endorsements
--     WHERE endorsement_date BETWEEN '2024-07-01' AND '2024-07-31'
-- )

-- SELECT 
--     ROUND(100.0 * COUNT(ue.user_id) / COUNT(du.user_id), 2) AS endorsed_user_pct
-- FROM dim_users du
-- LEFT JOIN user_endorsement ue 
--     ON du.user_id = ue.user_id;


SELECT
  (
    SELECT COUNT(DISTINCT user_id)
    FROM fct_skill_endorsements
    WHERE endorsement_date BETWEEN '2024-07-01' AND '2024-07-31'
  ) * 100
  /
  (
    SELECT COUNT(DISTINCT user_id)
    FROM dim_users
  ) AS endorsement_ratio;


-- Question 2: What is the average number of endorsements received per user for skills categorized as 'TECHNICAL' during August 2024?


-- SELECT 
--   AVG(user_endorsements) AS avg_endorsement_count
-- FROM (
--   SELECT user_id, COUNT(*) AS user_endorsements
--   FROM fct_skill_endorsements fse
--   JOIN dim_skills ds ON fse.skill_id = ds.skill_id
--   WHERE endorsement_date BETWEEN '2024-08-01' AND '2024-08-31'
--     AND skill_category = 'TECHNICAL'
--   GROUP BY user_id
-- ) AS sub;



SELECT COUNT(*) * 1.0 / COUNT(DISTINCT user_id) AS avg_endorsement
FROM fct_skill_endorsements fse
JOIN dim_skills ds ON fse.skill_id = ds.skill_id
WHERE endorsement_date BETWEEN '2024-08-01' AND '2024-08-31'
AND skill_category = 'TECHNICAL'



-- Question 3: Among users who have been endorsed for MANAGEMENT skills, what percentage received endorsements for MANAGEMENT 
-- skills in September 2024? How does this compare to the same metric for users with TECHNICAL skills?

-- WITH user_endorsement AS (
--     SELECT DISTINCT user_id, skill_category
--     FROM fct_skill_endorsements fse
--     JOIN dim_skills ds ON fse.skill_id = ds.skill_id
-- ),
-- user_endorsement_sep AS (  
--     SELECT DISTINCT user_id, skill_category
--     FROM fct_skill_endorsements fse
--     JOIN dim_skills ds ON fse.skill_id = ds.skill_id
--     WHERE endorsement_date BETWEEN '2024-09-01' AND '2024-09-30'
-- )

-- SELECT  
--     ROUND(
--         100.0 * (
--             SELECT COUNT(DISTINCT user_id)
--             FROM user_endorsement_sep
--             WHERE skill_category = 'MANAGEMENT'
--         ) / (
--             SELECT COUNT(DISTINCT user_id)
--             FROM user_endorsement
--             WHERE skill_category = 'MANAGEMENT'
--         ), 2
--     ) AS sep_management_pct,

--     ROUND(
--         100.0 * (
--             SELECT COUNT(DISTINCT user_id)
--             FROM user_endorsement_sep
--             WHERE skill_category = 'TECHNICAL'
--         ) / (
--             SELECT COUNT(DISTINCT user_id)
--             FROM user_endorsement
--             WHERE skill_category = 'TECHNICAL'
--         ), 2
--     ) AS sep_technical_pct;

 

WITH user_endorsements AS (
    SELECT user_id, skill_category,
           CASE WHEN endorsement_date BETWEEN '2024-09-01' AND '2024-09-30' THEN 1 ELSE 0 END AS is_sep
    FROM fct_skill_endorsements fse
    JOIN dim_skills ds ON fse.skill_id = ds.skill_id
)

SELECT
  ROUND(100.0 * COUNT(DISTINCT CASE WHEN skill_category = 'MANAGEMENT' AND is_sep = 1 THEN user_id END) /
        COUNT(DISTINCT CASE WHEN skill_category = 'MANAGEMENT' THEN user_id END), 2) AS sep_management_pct,

  ROUND(100.0 * COUNT(DISTINCT CASE WHEN skill_category = 'TECHNICAL' AND is_sep = 1 THEN user_id END) /
        COUNT(DISTINCT CASE WHEN skill_category = 'TECHNICAL' THEN user_id END), 2) AS sep_technical_pct
FROM user_endorsements;







