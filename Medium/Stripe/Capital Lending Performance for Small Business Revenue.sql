-- Step 1: Create the database
CREATE DATABASE IF NOT EXISTS capital_lending_performance_db;
USE capital_lending_performance_db;

-- Step 2: Drop tables if they already exist (to avoid conflicts)
DROP TABLE IF EXISTS fct_loans;
DROP TABLE IF EXISTS dim_businesses;

-- Step 3: Create dim_businesses table
CREATE TABLE dim_businesses (
  business_id INT PRIMARY KEY,
  monthly_revenue DECIMAL(10, 2),
  revenue_variability DECIMAL(4, 2),
  business_size VARCHAR(10)
);

-- Step 4: Create fct_loans table
CREATE TABLE fct_loans (
  loan_id INT PRIMARY KEY,
  business_id INT,
  loan_amount DECIMAL(10, 2),
  loan_issued_date DATE,
  loan_repaid BOOLEAN,
  FOREIGN KEY (business_id) REFERENCES dim_businesses(business_id)
);

-- Step 5: Insert data into dim_businesses
INSERT INTO dim_businesses (business_id, business_size, monthly_revenue, revenue_variability) VALUES
(1, 'small', 10000.00, 0.05),
(2, 'small', 15000.00, 0.08),
(3, 'small', 8000.00, 0.25),
(4, 'small', 20000.00, 0.30),
(5, 'small', 12000.00, 0.22),
(6, 'small', 9000.00, 0.07),
(7, 'small', 11000.00, 0.55),
(8, 'small', 13000.00, 0.40),
(9, 'small', 14000.00, 0.06),
(10, 'small', 16000.00, 0.50),
(11, 'medium', 30000.00, 0.10),
(12, 'large', 50000.00, 0.12),
(13, 'small', 12500.00, 0.15);

-- Step 6: Insert data into fct_loans
INSERT INTO fct_loans (loan_id, business_id, loan_amount, loan_repaid, loan_issued_date) VALUES
(1, 1, 10000.00, 1, '2024-01-05'),
(2, 3, 5000.00, 0, '2024-01-08'),
(3, 4, 20000.00, 1, '2024-01-15'),
(4, 5, 15000.00, 1, '2024-01-20'),
(5, 7, 8000.00, 0, '2024-01-25'),
(6, 2, 12000.00, 1, '2024-01-12'),
(7, 2, 9000.00, 1, '2024-01-18'),
(8, 8, 11000.00, 0, '2024-01-22'),
(9, 9, 7000.00, 1, '2024-01-28'),
(10, 10, 13000.00, 0, '2024-01-30'),
(11, 3, 6000.00, 0, '2024-01-14'),
(12, 4, 5000.00, 1, '2024-01-09'),
(13, 7, 9000.00, 1, '2024-01-27'),
(14, 8, 10000.00, 0, '2024-01-16'),
(15, 6, 14000.00, 1, '2024-01-11'),
(16, 11, 25000.00, 1, '2024-01-07');






-- As a Business Analyst on the Stripe Capital team, you are tasked with evaluating the effectiveness of 
-- lending products for small businesses. Your goal is to understand how different levels of revenue 
-- variability impact loan repayment success rates. By analyzing these insights, your team aims to optimize 
-- lending strategies to better support small businesses with varying financial stability.



-- Question 1: What is the average monthly revenue for small businesses that received a loan versus those that 
-- did not receive a loan during January 2024? Use the ''business_size'' field to filter for small businesses.


WITH jan_loans AS (
  SELECT DISTINCT business_id
  FROM fct_loans
  WHERE loan_issued_date BETWEEN '2024-01-01' AND '2024-01-31'
)

SELECT 
  CASE 
    WHEN jl.business_id IS NOT NULL THEN 'Received Loan'
    ELSE 'Did Not Receive Loan'
  END AS loan_status,
  ROUND(AVG(db.monthly_revenue), 2) AS avg_monthly_revenue
FROM dim_businesses db
LEFT JOIN jan_loans jl ON db.business_id = jl.business_id
WHERE db.business_size = 'small'
GROUP BY loan_status;



-- SELECT 
--   CASE 
--     WHEN fl.loan_id IS NOT NULL THEN 'Received Loan'
--     ELSE 'Did Not Receive Loan'
--   END AS loan_status,
--   AVG(db.monthly_revenue) AS avg_monthly_revenue
-- FROM dim_businesses db
-- LEFT JOIN fct_loans fl 
--   ON db.business_id = fl.business_id 
--   AND fl.loan_issued_date BETWEEN '2024-01-01' AND '2024-01-31'
-- WHERE db.business_size = 'small'
-- GROUP BY loan_status
-- ORDER BY loan_status;




-- Question 2: For small businesses that received a loan in January 2024, what percentage of businesses successfully 
-- repaid their loans? Categorize these businesses into low, medium, and high revenue variability groups using these values

-- 1. Low: <0.1
-- 2. Medium: 0.1 - 0.3 inclusive
-- 3. High: >0.3


SELECT 
  CASE 
    WHEN db.revenue_variability < 0.1 THEN 'Low'
    WHEN db.revenue_variability > 0.3 THEN 'High'
    ELSE 'Medium'
  END AS business_category,
  ROUND(SUM(CASE WHEN fl.loan_repaid = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(fl.loan_id), 2) AS repayment_rate_pct
FROM fct_loans fl
JOIN dim_businesses db ON fl.business_id = db.business_id 
WHERE fl.loan_issued_date BETWEEN '2024-01-01' AND '2024-01-31'
  AND db.business_size = 'small'
GROUP BY business_category
ORDER BY repayment_rate_pct DESC;



-- Question 3: For small businesses during January 2024, what is the loan repayment success rate for each revenue 
-- variability category? Order the results from the highest to the lowest success rate to assess the correlation
--  between revenue variability and repayment reliability.
