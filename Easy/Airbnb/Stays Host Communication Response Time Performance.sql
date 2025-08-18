-- Create the database
CREATE DATABASE IF NOT EXISTS stays_host_communication_db;

-- Use the database
USE stays_host_communication_db;

-- Create the table
CREATE TABLE fct_guest_inquiries (
    inquiry_id INT PRIMARY KEY,
    host_id INT,
    guest_id INT,
    inquiry_date DATE,
    response_time_hours FLOAT
);

-- Insert data
INSERT INTO fct_guest_inquiries (host_id, guest_id, inquiry_id, inquiry_date, response_time_hours) VALUES
(101, 201, 1, '2024-01-01', 0.5),
(101, 202, 2, '2024-01-05', 1),
(102, 203, 3, '2024-01-10', 2.5),
(103, 204, 4, '2024-01-16', 3),
(101, 205, 5, '2024-01-18', 1.5),
(102, 201, 6, '2024-01-20', 2.1),
(104, 206, 7, '2024-01-22', 4),
(105, 207, 8, '2024-01-25', 1.2),
(103, 208, 9, '2024-01-28', 3.5),
(104, 202, 10, '2024-01-31', 2.5),
(105, 203, 11, '2024-01-22', 0.8),
(103, 207, 12, '2024-01-15', 2),
(101, 209, 13, '2024-01-03', 1.8),
(102, 210, 14, '2024-01-17', 2.3),
(103, 211, 15, '2024-01-05', 0.9);






-- As a Data Analyst on the Airbnb Stays team, you are tasked with evaluating host response times to guest inquiries. 
-- Your team is focused on understanding how quickly hosts are responding to improve the guest experience. 
-- By analyzing response times, you aim to identify trends and outliers in host responsiveness to inform potential improvements.





-- Question 1: What is the minimum host response time in hours for guest inquiries in January 2024? This metric will help 
-- identify if any hosts are setting an exceptionally quick response standard.

SELECT MIN(response_time_hours) AS min_response_time
FROM fct_guest_inquiries
WHERE inquiry_date BETWEEN '2024-01-01' AND '2024-01-31';



-- Question 2: For guest inquiries made in January 2024, what is the average host response time rounded to the 
-- nearest hour? This average will provide insight into overall host responsiveness.


SELECT ROUND(AVG(response_time_hours)) AS avg_response_time
FROM fct_guest_inquiries
WHERE inquiry_date BETWEEN '2024-01-01' AND '2024-01-31';


-- Question 3: List the inquiry_id and response_time_hours for guest inquiries made between January 16th and January 31st, 
-- 2024 that took longer than 2 hours to respond. This breakdown will help pinpoint hosts with slower response times.


SELECT inquiry_id, response_time_hours
FROM fct_guest_inquiries
WHERE inquiry_date BETWEEN '2024-01-16' AND '2024-01-31'
AND response_time_hours > 2;





-- By analyzing these response times, your team at Airbnb can identify how quickly hosts are responding to guest inquiries, spot trends 
-- in responsiveness, and detect any outliers with slower or faster response times. This insight is valuable for improving the guest 
-- experience by encouraging timely host communication.






