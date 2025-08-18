-- Create the database
CREATE DATABASE IF NOT EXISTS gmail_label_usage_db;
USE gmail_label_usage_db;

-- Create the email_labels table
CREATE TABLE email_labels (
    label_id INT PRIMARY KEY,
    user_id INT,
    created_date DATE
);

-- Insert data into email_labels
INSERT INTO email_labels (label_id, user_id, created_date) VALUES
(1, 101, '2024-10-05'),
(2, 102, '2024-10-10'),
(3, 103, '2024-10-15'),
(4, 101, '2024-10-20'),
(5, 104, '2024-10-25'),
(6, 105, '2024-10-30'),
(7, 106, '2024-11-01'),
(8, 107, '2024-11-05'),
(9, 108, '2024-11-10'),
(10, 109, '2024-11-15'),
(11, 110, '2024-11-20'),
(12, 111, '2024-11-25'),
(13, 112, '2024-12-01'),
(14, 113, '2024-12-05'),
(15, 114, '2024-12-10');

-- Create the emails table
CREATE TABLE emails (
    email_id INT PRIMARY KEY,
    label_id INT,
    FOREIGN KEY (label_id) REFERENCES email_labels(label_id)
);

-- Insert data into emails
INSERT INTO emails (email_id, label_id) VALUES
(1, 1), (2, 1),
(3, 2), (4, 2), (5, 2),
(6, 3), (7, 3), (8, 3), (9, 3), (10, 3),
(11, 4), (12, 4), (13, 4), (14, 4), (15, 4),
(16, 4), (17, 4), (18, 4), (19, 4), (20, 4),
(21, 5), (22, 5), (23, 5),
(24, 6), (25, 6), (26, 6),
(27, 7),
(28, 8),
(29, 9),
(30, 10),
(31, 11),
(32, 12),
(33, 13),
(34, 14),
(35, 15), (36, 15), (37, 15), (38, 15), (39, 15), (40, 15);




-- As a Data Scientist on the Gmail User Experience Research team, you are tasked with understanding how users 
-- create and utilize email labels for personal organization. Your goal is to analyze user label creation patterns, 
-- identify which labels are effectively managing email communication, and uncover insights that can inform product 
-- design improvements. By leveraging data, you will provide actionable insights to enhance user productivity and 
-- streamline email management.



-- Question 1: Can you find out the number of labels created by each user? We are interested in understanding how many 
-- labels users typically create to manage their emails.

SELECT user_id, COUNT(label_id) AS n_labels
FROM email_labels
GROUP BY 1
ORDER BY 1;



-- Question 2: Your team wants to know which labels had more than 5 emails assigned to them. Can you retrieve these?


SELECT label_id
FROM emails
GROUP BY label_id
HAVING COUNT(email_id) > 5;


-- Question 3: For labels created in October 2024, determine the number of emails associated with each label. 
-- If any labels created in October did not have any emails associated with it, still return these labels in your 
-- output. This will help us understand the distribution of email usage across labels.

SELECT el.label_id, COALESCE(COUNT(email_id), 0) AS n_emails
FROM email_labels el 
LEFT JOIN emails ON el.label_id = emails.label_id
AND created_date BETWEEN '2024-10-01' AND '2024-10-31'
GROUP BY 1;


SELECT el.label_id, COALESCE(COUNT(e.email_id), 0) AS n_emails
FROM email_labels el
LEFT JOIN emails e ON el.label_id = e.label_id
WHERE el.created_date BETWEEN '2024-10-01' AND '2024-10-31'
GROUP BY el.label_id;


-- Your analyses will help the Gmail User Experience Research team understand user behavior around label creation 
-- and email organization. This insight can guide product design improvements to enhance user productivity and 
-- streamline email management.

