-- Create the database
CREATE DATABASE IF NOT EXISTS peer_to_peer_sharing_db;
USE peer_to_peer_sharing_db;

-- Create fct_transactions table
CREATE TABLE fct_transactions (
    transaction_id INT PRIMARY KEY,
    user_id INT,
    transaction_date DATE,
    amount DECIMAL(10, 2)
);

-- Insert data into fct_transactions
INSERT INTO fct_transactions (amount, user_id, transaction_id, transaction_date) VALUES
(20.5, 1, 1, '2024-10-02'),
(35, 1, 2, '2024-11-15'),
(50, 1, 3, '2024-12-10'),
(15, 2, 4, '2024-10-05'),
(22, 2, 5, '2024-10-20'),
(40, 3, 6, '2024-11-01'),
(60, 3, 7, '2024-12-25'),
(80, 4, 8, '2024-12-31'),
(25, 5, 9, '2024-10-15'),
(55, 5, 10, '2024-11-20'),
(65, 5, 11, '2024-11-22'),
(30, 6, 12, '2024-10-30'),
(90, 6, 13, '2024-12-05'),
(100, 2, 14, '2024-09-30'),
(45, 7, 15, '2024-12-12'),
(55, 7, 16, '2024-11-08'),
(75, 3, 17, '2024-09-15'),
(100, 8, 18, '2024-09-20');

-- Create fct_social_shares table
CREATE TABLE fct_social_shares (
    share_id INT PRIMARY KEY,
    user_id INT,
    share_date DATE
);

-- Insert data into fct_social_shares
INSERT INTO fct_social_shares (user_id, share_id, share_date) VALUES
(2, 2, '2024-11-10'),
(5, 4, '2024-11-23'),
(5, 5, '2024-12-01'),
(7, 6, '2024-12-13'),
(6, 8, '2024-10-29'),
(8, 9, '2024-10-15'),
(2, 10, '2024-09-30');






-- You are a Product Analyst on the Venmo social payments team investigating how social sharing behaviors 
-- influence user engagement and retention. Your team wants to understand the relationship between users' 
-- social interactions and their transaction patterns. The goal is to explore how social features might drive 
-- long-term platform usage.




-- Question 1: What is the floor value of the average number of transactions per user made between October 1st, 2024 
-- and December 31st, 2024? This helps establish a baseline for user engagement on Venmo.



-- SELECT FLOOR(AVG(n_transaction)) AS avg_transactions_floor
-- FROM (
--     SELECT user_id, COUNT(transaction_id) AS n_transaction
--     FROM fct_transactions
--     WHERE transaction_date BETWEEN '2024-10-01' AND '2024-12-31'
--     GROUP BY user_id
-- ) AS user_transactions;


SELECT FLOOR( COUNT(*) / COUNT(DISTINCT user_id)) AS avg_transactions
FROM fct_transactions
WHERE transaction_date BETWEEN '2024-10-01' AND '2024-12-31';


-- Question 2: How many distinct users executed at least one social share between October 1st, 2024 and December 31st, 
-- 2024? This helps assess the prevalence of social sharing among active users.


SELECT COUNT(DISTINCT user_id) AS n_user
FROM fct_social_shares
WHERE share_date BETWEEN '2024-10-01' AND '2024-12-31';


-- Question 3: What is the average difference in days between a user's first and last transactions from October 1st, 2024 
-- to December 31st, 2024, for users who made 2 transactions vs. 3+ transactions?

WITH user_group AS (
  SELECT 
    user_id, 
    MAX(transaction_date) AS max_date, 
    MIN(transaction_date) AS min_date, 
    CASE
      WHEN COUNT(transaction_id) = 2 THEN 'Two'
      WHEN COUNT(transaction_id) >= 3 THEN 'At least three'
    END AS transaction_count
  FROM fct_transactions
  WHERE transaction_date BETWEEN '2024-10-01' AND '2024-12-31'
  GROUP BY user_id
  HAVING COUNT(transaction_id) >= 2
)

SELECT 
  transaction_count, 
  AVG(DATEDIFF(max_date, min_date)) AS avg_datediff
FROM user_group 
GROUP BY transaction_count;


-- Your analyses help PayPal's Venmo team understand user engagement patterns by quantifying transaction frequency and timing, 
-- as well as social sharing behaviors. This insight can guide product decisions to enhance user retention and platform usage 
-- through social features.


