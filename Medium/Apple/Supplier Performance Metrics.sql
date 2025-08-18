CREATE DATABASE supplier_performance_metrics_db;
USE supplier_performance_metrics_db;



-- Drop tables if they already exist
DROP TABLE IF EXISTS supplier_deliveries;
DROP TABLE IF EXISTS suppliers;

-- Create suppliers table
CREATE TABLE suppliers (
  supplier_id INT PRIMARY KEY,
  supplier_name VARCHAR(100) NOT NULL
);

-- Create supplier_deliveries table
CREATE TABLE supplier_deliveries (
  supplier_id INT,
  delivery_date DATE,
  component_count INT,
  manufacturing_region VARCHAR(100),
  FOREIGN KEY (supplier_id) REFERENCES suppliers(supplier_id)
);

-- Insert data into suppliers
INSERT INTO suppliers (supplier_id, supplier_name) VALUES
(101, 'Alpha Components'),
(102, 'Beta Electronics'),
(103, 'Gamma Materials'),
(104, 'Delta Manufacturing'),
(105, 'Epsilon Systems'),
(106, 'Zeta Solutions'),
(107, 'Eta Technologies'),
(108, 'Theta Innovations'),
(109, 'Iota Processing'),
(110, 'Kappa Supplies'),
(111, 'Lambda Corp'),
(112, 'Mu Global');

-- Insert data into supplier_deliveries
INSERT INTO supplier_deliveries (supplier_id, delivery_date, component_count, manufacturing_region) VALUES
(101, '2024-10-05', 1500, 'North America'),
(102, '2024-10-12', 2200, 'Asia'),
(103, '2024-10-19', 1800, 'Europe'),
(101, '2024-10-26', 1200, 'North America'),
(104, '2024-10-08', 2500, 'Asia'),
(105, '2024-10-15', 900, 'Europe'),
(102, '2024-10-22', 2100, 'Asia'),
(106, '2024-10-29', 1600, 'North America'),
(103, '2024-10-02', 1900, 'Europe'),
(107, '2024-10-09', 2300, 'Asia'),
(108, '2024-11-03', 3500, 'North America'),
(102, '2024-11-10', 4200, 'Asia'),
(109, '2024-11-17', 2800, 'Europe'),
(108, '2024-11-24', 3800, 'North America'),
(110, '2024-11-06', 5100, 'Asia'),
(101, '2024-11-13', 2900, 'North America'),
(104, '2024-11-20', 3100, 'Asia'),
(105, '2024-11-27', 2600, 'Europe'),
(111, '2024-12-01', 1700, 'North America'),
(102, '2024-12-08', 2000, 'Asia'),
(103, '2024-12-15', 1400, 'Europe'),
(112, '2024-12-22', 1100, 'North America'),
(106, '2024-12-29', 1300, 'Europe'),
(109, '2024-12-05', 1900, 'Europe'),
(111, '2024-12-12', 2100, 'North America'),
(112, '2024-12-19', 1600, 'North America'),
(107, '2024-12-26', 1800, 'Asia');


-- As a Data Analyst on the Supply Chain Procurement Team, you are tasked with assessing 
-- supplier performance to ensure reliable delivery of critical components. Your goal is to identify 
-- the most active suppliers, understand which suppliers dominate in specific manufacturing 
-- regions, and pinpoint any gaps in supply to the Asia region. By leveraging data, you will help 
-- optimize vendor selection strategies and mitigate potential supply chain risks.



-- Question 1: We need to know who our most active suppliers are. 
-- Identify the top 5 suppliers based on the total volume of components delivered in October 2024.

SELECT 
    supplier_name, SUM(component_count)
FROM
    supplier_deliveries sd
        JOIN
    suppliers s ON sd.supplier_id = s.supplier_id
WHERE
    delivery_date BETWEEN '2024-10-01' AND '2024-10-31'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5;


-- Question 2: For each region, find the supplier ID that delivered the highest number of components in November 2024. 
-- This will help us understand which supplier is handling the most volume per market.

-- WITH supplier_totals AS (
--   SELECT 
--     manufacturing_region, 
--     supplier_id,
--     SUM(component_count) AS total_supply
--   FROM supplier_deliveries
--   WHERE delivery_date BETWEEN '2024-11-01' AND '2024-11-30'
--   GROUP BY manufacturing_region, supplier_id
-- )
-- SELECT 
--   manufacturing_region,
--   supplier_id
-- FROM (
--   SELECT *,
--          RANK() OVER (PARTITION BY manufacturing_region ORDER BY total_supply DESC) AS n_rnk
--   FROM supplier_totals
-- ) ranked
-- WHERE n_rnk = 1;


WITH supplier_totals AS (
  SELECT 
  manufacturing_region,
  supplier_id,
  RANK() OVER (
    PARTITION BY manufacturing_region 
    ORDER BY SUM(component_count) DESC
  ) AS n_rnk,
  SUM(component_count) AS total_supply
FROM supplier_deliveries
WHERE delivery_date BETWEEN '2024-11-01' AND '2024-11-30'
GROUP BY manufacturing_region, supplier_id
)
SELECT 
  manufacturing_region,
  supplier_id
FROM supplier_totals
WHERE n_rnk = 1;



-- Question 3: We need to identify potential gaps in our supply chain for Asia. 
-- List all suppliers by name who have not delivered any components to the 'Asia' manufacturing region in December 2024.

WITH dec_supply AS (
  SELECT supplier_id
  FROM supplier_deliveries
  WHERE delivery_date BETWEEN '2024-12-01' AND '2024-12-31'
    AND manufacturing_region = 'Asia'
)

SELECT s.supplier_name
FROM suppliers s
LEFT JOIN dec_supply ds ON s.supplier_id = ds.supplier_id
WHERE ds.supplier_id IS NULL;


