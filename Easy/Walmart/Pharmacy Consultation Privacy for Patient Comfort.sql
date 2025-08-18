-- Create the database and use it
CREATE DATABASE IF NOT EXISTS pharmacy_consultation_privacy_db;
USE pharmacy_consultation_privacy_db;

-- Create the table
CREATE TABLE fct_consultations (
    consultation_id INT PRIMARY KEY,
    pharmacy_name VARCHAR(100),
    consultation_date DATE,
    consultation_room_type VARCHAR(50),
    privacy_level_score INT
);

-- Insert the data
INSERT INTO fct_consultations (
    consultation_id, pharmacy_name, consultation_date, privacy_level_score, consultation_room_type
) VALUES
(1, 'Walmart Pharmacy North', '2024-07-05', 8, 'private'),
(2, 'Walmart Pharmacy South', '2024-07-07', 6, 'semi-private'),
(3, 'Walmart Pharmacy East', '2024-07-10', 5, 'open'),
(4, 'Walmart Pharmacy West', '2024-07-12', 9, 'private'),
(5, 'Walmart Pharmacy Central', '2024-07-14', 7, 'group'),
(6, 'Walmart Pharmacy North', '2024-07-20', 6, 'open'),
(7, 'Walmart Pharmacy South', '2024-07-21', 8, 'private'),
(8, 'Walmart Pharmacy East', '2024-07-22', 7, 'semi-private'),
(9, 'Walmart Pharmacy West', '2024-07-23', 4, 'group'),
(10, 'Walmart Pharmacy Central', '2024-07-24', 9, 'soundproof'),
(11, 'Walmart Pharmacy Central', '2024-07-25', 8, 'private'),
(12, 'Walmart Pharmacy North', '2024-07-29', 7, 'semi-private'),
(13, 'Walmart Pharmacy South', '2024-08-05', 5, 'open'),
(14, 'Walmart Pharmacy East', '2024-08-06', 10, 'soundproof'),
(15, 'Walmart Pharmacy West', '2024-08-07', 7, 'semi-private');







-- You are a Data Analyst on the Walmart Pharmacy team tasked with evaluating patient consultation privacy concerns. 
-- Your team is focused on understanding how different consultation room types and their associated privacy levels 
-- affect patient comfort and confidentiality. By analyzing consultation frequencies, room types, and privacy scores, 
-- you will recommend improvements to enhance patient privacy in pharmacy consultation spaces.





-- Question 1: What are the names of the 3 pharmacies that conducted the fewest number of consultations in July 2024? 
-- This will help us identify locations with potentially less crowded consultation spaces.


SELECT pharmacy_name, COUNT(consultation_id) AS n_consultations
FROM fct_consultations
WHERE consultation_date BETWEEN '2024-07-01' AND '2024-07-31'
GROUP BY pharmacy_name
ORDER BY n_consultations
LIMIT 3;



-- Question 2: For the pharmacies identified in the previous question (i.e., the 3 pharmacies with the fewest consultations 
-- in July 2024), what is the uppercase version of the consultation room types available? Understanding the room types can 
-- provide insights into the privacy features offered.

WITH fewest_consults AS (
    SELECT pharmacy_name, COUNT(consultation_id) AS n_consultations
    FROM fct_consultations
    WHERE consultation_date BETWEEN '2024-07-01' AND '2024-07-31'
    GROUP BY pharmacy_name
    ORDER BY n_consultations
    LIMIT 3
)

SELECT 
    fc.pharmacy_name, 
    UPPER(fc.consultation_room_type) AS consultation_room_type_upper
FROM fct_consultations fc
JOIN fewest_consults fec ON fc.pharmacy_name = fec.pharmacy_name;




-- Question 3: So far, we have identified the 3 pharmacies with the fewest consultations in July 2024. 
-- Among these 3 pharmacies, what is the minimum privacy level score for each consultation room type in July 2024?


WITH fewest_consults AS (
    SELECT pharmacy_name, COUNT(consultation_id) AS n_consultations
    FROM fct_consultations
    WHERE consultation_date BETWEEN '2024-07-01' AND '2024-07-31'
    GROUP BY pharmacy_name
    ORDER BY n_consultations
    LIMIT 3
)

SELECT 
    fc.pharmacy_name, 
    fc.consultation_room_type AS consultation_room_type, 
    MIN(privacy_level_score) AS min_score
FROM fct_consultations fc
JOIN fewest_consults fec ON fc.pharmacy_name = fec.pharmacy_name
WHERE fc.consultation_date BETWEEN '2024-07-01' AND '2024-07-31'
GROUP BY fc.pharmacy_name, fc.consultation_room_type;



-- Your analyses will help Walmart Pharmacy understand which consultation room types and privacy levels are associated 
-- with less crowded pharmacies, guiding improvements to enhance patient privacy and comfort.





