-- Create the database
CREATE DATABASE IF NOT EXISTS one_touch_conversion_performance_db;
USE one_touch_conversion_performance_db;

-- Create the table
CREATE TABLE IF NOT EXISTS fct_mobile_transactions (
    transaction_id INT PRIMARY KEY,
    user_id INT,
    transaction_date DATE,
    login_method VARCHAR(50),
    transaction_status VARCHAR(20)
);

-- Insert the data
INSERT INTO fct_mobile_transactions (transaction_id, user_id, transaction_date, login_method, transaction_status) VALUES
(1001, 1, '2024-07-01', 'One Touch', 'Success'),
(1002, 2, '2024-07-02', 'Standard', 'Success'),
(1003, 3, '2024-07-03', 'one touch', 'Success'),
(1004, 1, '2024-07-04', 'STANDARD', 'Failed'),
(1005, 4, '2024-07-05', 'One Touch', 'Success'),
(1006, 5, '2024-07-06', 'Standard', 'Success'),
(1007, 3, '2024-07-07', 'one touch', 'Success'),
(1008, 2, '2024-07-08', 'One Touch', 'Success'),
(1009, 6, '2024-07-09', 'Standard', 'Success'),
(1010, 7, '2024-07-10', 'One Touch', 'Success'),
(1011, 5, '2024-07-11', 'Standard', 'Failed'),
(1012, 8, '2024-07-12', 'standard', 'Success'),
(1013, 9, '2024-07-15', 'One Touch', 'Success'),
(1014, 10, '2024-07-20', 'one touch', 'Failed'),
(1015, 11, '2024-07-25', 'One Touch', 'Success'),
(1016, 12, '2024-06-30', 'One Touch', 'Success');


-- As a Product Analyst on the PayPal One Touch team, you are investigating mobile checkout conversion rates for the 
-- One Touch login feature. Your team wants to understand how different login methods impact transaction completion 
-- across mobile platforms. You will use transaction data to evaluate login method performance and user engagement.




-- Question 1: For our analysis of the PayPal One Touch feature, what is the total number of mobile transactions that 
-- used One Touch during July 2024? You might notice that the login_method doesn't have consistent capitalization, 
-- so make sure to account for this in your query!


SELECT COUNT(*) AS total_transactions
FROM fct_mobile_transactions
WHERE transaction_date BETWEEN '2024-07-01' AND '2024-07-31'
AND UPPER(login_method) = 'ONE TOUCH';



-- Question 2: To determine user adoption of the One Touch feature, how many distinct users completed mobile transactions 
-- using One Touch during July 2024? Rename the column for user counts to 'Unique_Users'. This information will support 
-- our investigation of transaction engagement.


SELECT COUNT(DISTINCT user_id) AS Unique_Users
FROM fct_mobile_transactions
WHERE transaction_date BETWEEN '2024-07-01' AND '2024-07-31'
AND UPPER(login_method) = 'ONE TOUCH';



-- Question 3: We want to understand the adoption of One Touch vs. Standard features. How many successful transactions were there 
-- in July 2024 respectively for One Touch and Standard? Recall that the data in login_method has inconsistent capitalization, 
-- so we want to handle for this!


SELECT 
  UPPER(login_method) AS login_method, 
  COUNT(*) AS successful_transactions
FROM fct_mobile_transactions
WHERE transaction_date BETWEEN '2024-07-01' AND '2024-07-31'
  AND UPPER(login_method) IN ('ONE TOUCH', 'STANDARD')
  AND transaction_status = 'Success'
GROUP BY UPPER(login_method);




-- Your analyses will help the PayPal One Touch team understand how different login methods perform in terms of transaction 
-- completion and user engagement on mobile platforms. This insight is valuable for optimizing the checkout experience and 
-- increasing conversion rates.



