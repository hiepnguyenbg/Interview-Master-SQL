-- Step 1: Drop and create the database
DROP DATABASE IF EXISTS teams_file_sharing_security_db;
CREATE DATABASE teams_file_sharing_security_db;
USE teams_file_sharing_security_db;

-- Step 2: Create the dim_organization table
CREATE TABLE dim_organization (
    organization_id INT PRIMARY KEY,
    organization_name VARCHAR(100),
    segment VARCHAR(50)
);

-- Step 3: Create the fct_file_sharing table
CREATE TABLE fct_file_sharing (
    file_id INT PRIMARY KEY,
    file_name VARCHAR(150),
    shared_date DATE,
    organization_id INT,
    co_editing_user_id INT,
    FOREIGN KEY (organization_id) REFERENCES dim_organization(organization_id)
);

-- Step 4: Insert data into dim_organization
INSERT INTO dim_organization (segment, organization_id, organization_name) VALUES
('Finance', 1, 'AlphaCorp'),
('Technology', 2, 'BetaTech'),
('Healthcare', 3, 'GammaLLC'),
('Retail', 4, 'DeltaInc'),
('Government', 5, 'EpsilonLtd'),
('Finance', 6, 'ZetaPartners'),
('Technology', 7, 'EtaSolutions'),
('Healthcare', 8, 'ThetaSystems'),
('Retail', 9, 'IotaServices'),
('Manufacturing', 10, 'KappaGlobal');

-- Step 5: Insert data into fct_file_sharing
INSERT INTO fct_file_sharing (file_id, file_name, shared_date, organization_id, co_editing_user_id) VALUES
(1, 'AlphaCorp-report', '2024-01-05', 1, 1001),
(2, 'Summary', '2024-01-12', 2, NULL),
(3, 'GammaLLC_DataAnalysis', '2024-01-20', 3, NULL),
(4, 'DeltaInc_Notes', '2024-01-25', 4, 2002),
(5, 'MeetingMinutes', '2024-01-30', 5, NULL),
(6, 'AlphaCorp-Summary', '2024-02-03', 1, 3001),
(7, 'BetaTech-Overview', '2024-02-10', 2, NULL),
(8, 'DataSet', '2024-02-15', 3, 3003),
(9, 'ZetaPartners-Quarterly', '2024-02-20', 6, NULL),
(10, 'KappaGlobal-Plan', '2024-02-25', 10, 3005),
(11, 'Proposal', '2024-03-05', 7, NULL),
(12, 'ThetaSystems_Design', '2024-03-10', 8, 4001),
(13, 'IotaServices-Update', '2024-03-15', 9, NULL),
(14, 'DeltaIncStrategies', '2024-03-20', 4, NULL),
(15, 'EpsilonLtd-Finance', '2024-03-25', 5, 4003),
(16, 'EtaSolutions-Guide', '2024-02-28', 7, NULL),
(17, 'EtaSolutions-Edit', '2024-01-21', 7, NULL),
(18, 'AlphaCorp-Review', '2024-03-02', 1, NULL);




-- As a Product Analyst for Microsoft Teams, you are collaborating with the security team to enhance data security 
-- in file sharing and co-editing activities. Your team is focused on understanding how file naming conventions 
-- and co-editing practices vary across organizational segments. By analyzing these patterns, you aim to identify 
-- potential security risks and recommend targeted improvements to the platform.



-- Question 1: What is the average length of the file names shared for each organizational segment in January 2024?

-- WITH name_len AS (
--   SELECT 
--     dio.segment, 
--     CHAR_LENGTH(ffs.file_name) AS name_len
--   FROM fct_file_sharing ffs
--   JOIN dim_organization dio 
--     ON ffs.organization_id = dio.organization_id
--   WHERE ffs.shared_date BETWEEN '2024-01-01' AND '2024-01-31'
-- )
-- SELECT 
--   segment, 
--   ROUND(AVG(name_len), 2) AS avg_name_len
-- FROM name_len
-- GROUP BY segment
-- ORDER BY avg_name_len DESC;



SELECT segment, AVG(LENGTH(file_name)) AS avg_name_length
FROM fct_file_sharing ffs
JOIN dim_organization dor
ON ffs.organization_id = dor.organization_id
WHERE shared_date BETWEEN '2024-01-01' AND '2024-01-31'
GROUP BY segment
ORDER BY avg_name_length DESC;


-- Question 2: How many files were shared with names that start with the same prefix as the organization
--  name, concatenated with a hyphen, in February 2024?

SELECT COUNT(*) AS n_matching_files
FROM fct_file_sharing ffs
JOIN dim_organization dio 
  ON ffs.organization_id = dio.organization_id
WHERE ffs.shared_date BETWEEN '2024-02-01' AND '2024-02-28'
  AND SPLIT_PART(file_name, '-', 1) = organization_name;



-- Question 3: Identify the top 3 organizational segments with the highest number of files shared where 
-- the co-editing user is NULL, indicating a potential security risk, during the first quarter of 2024.


SELECT segment, COUNT(file_id) AS n_files
FROM fct_file_sharing ffs
JOIN dim_organization dio 
  ON ffs.organization_id = dio.organization_id
WHERE ffs.shared_date BETWEEN '2024-01-01' AND '2024-03-31'
  AND co_editing_user_id IS NULL
GROUP BY segment
ORDER BY n_files DESC
LIMIT 3;



-- By identifying the top organizational segments with the highest number of files shared without co-editing users, 
-- you’re helping the security team pinpoint where potential risks might be concentrated. This analysis will guide 
-- targeted improvements in Microsoft Teams’ file sharing and co-editing features to enhance data security.

