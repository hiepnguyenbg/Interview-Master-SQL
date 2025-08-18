-- Create the database
CREATE DATABASE IF NOT EXISTS windows_update_adoption_db;

-- Use the database
USE windows_update_adoption_db;

-- Create the table
CREATE TABLE fct_update_installations (
    user_id INT,
    installation_date DATE,
    installation_time_minutes INT,
    installation_error BOOLEAN
);

-- Insert data
INSERT INTO fct_update_installations (user_id, installation_date, installation_error, installation_time_minutes) VALUES
(1, '2024-10-05', 0, 10),
(2, '2024-10-10', 1, 3),
(3, '2024-10-15', 0, 15),
(4, '2024-10-20', 0, 8),
(5, '2024-10-25', 1, 12),
(1, '2024-11-03', 0, 9),
(2, '2024-11-10', 0, 11),
(3, '2024-11-15', 1, 7),
(4, '2024-11-18', 0, 6),
(6, '2024-11-25', 0, 10),
(7, '2024-11-28', 0, 13),
(1, '2024-11-29', 0, 8),
(8, '2024-12-02', 0, 12),
(9, '2024-12-05', 0, 4),
(3, '2024-12-10', 0, 9),
(10, '2024-12-15', 1, 6),
(11, '2024-12-20', 0, 8),
(12, '2024-12-28', 0, 10),
(9, '2024-12-30', 0, 5);






-- As a Data Analyst on the Windows Update team, you are tasked with analyzing user update behaviors to improve 
-- the update experience. Your team is focused on understanding the fastest installation times and the reliability 
-- of error-free installations among users. The insights you gather will directly inform strategies to enhance 
-- update performance and user satisfaction.




-- Question 1: In October 2024, what is the fastest successful (no error) installation time recorded for a Windows update? 
-- This metric will help us benchmark the best-case update performance for our deployment strategy.

SELECT MIN(installation_time_minutes) AS fastest_installation_time
FROM fct_update_installations
WHERE installation_date BETWEEN '2024-10-01' AND '2024-10-31'
AND installation_error = 0;



-- Question 2: In November 2024, how many unique users successfully installed a Windows update without encountering any 
-- installation errors? This figure will help us assess update reliability.



SELECT COUNT(DISTINCT user_id) AS n_users
FROM fct_update_installations
WHERE installation_date BETWEEN '2024-11-01' AND '2024-11-30'
AND installation_error = 0;


-- Question 3: In December 2024, what is the fastest installation time for Windows updates among users who did not 
-- experience any errors? This metric will directly inform our update communication and deployment strategy to 
-- increase adoption rates.


SELECT MIN(installation_time_minutes) AS fastest_installation_time
FROM fct_update_installations
WHERE installation_date BETWEEN '2024-12-01' AND '2024-12-31'
AND installation_error = 0;



-- Your analyses on the fastest installation times and the count of unique successful users will help the Windows Update team 
-- benchmark update performance and assess reliability. These insights are crucial for improving update communication, 
-- deployment strategies, and ultimately enhancing user satisfaction.





