-- Create database
DROP DATABASE work_travel_expense_tracking_db;
CREATE DATABASE IF NOT EXISTS work_travel_expense_tracking_db;
USE work_travel_expense_tracking_db;

-- Create dim_companies table
CREATE TABLE dim_companies (
  company_id INT PRIMARY KEY,
  company_name VARCHAR(255) NOT NULL
);

-- Insert data into dim_companies
INSERT INTO dim_companies (company_id, company_name) VALUES
(1, 'Acme Corp'),
(2, 'Beta Technologies'),
(3, 'Global Insights'),
(4, 'Zenith Solutions'),
(5, 'Innovatech'),
(6, 'Prime Systems'),
(7, 'Nexus Holdings'),
(8, 'Vertex LLC'),
(9, 'Synergy Inc'),
(10, 'Quantum Dynamics');

-- Create fct_corporate_bookings table
CREATE TABLE fct_corporate_bookings (
  booking_id INT PRIMARY KEY,
  company_id INT NOT NULL,
  employee_id INT NOT NULL,
  booking_cost DECIMAL(10,2) NOT NULL,
  booking_date DATE NOT NULL,
  travel_date DATE NOT NULL,
  FOREIGN KEY (company_id) REFERENCES dim_companies(company_id)
);

-- Insert data into fct_corporate_bookings
INSERT INTO fct_corporate_bookings (booking_id, company_id, employee_id, travel_date, booking_cost, booking_date) VALUES
(1, 1, 101, '2024-02-05', 500.00, '2024-01-05'),
(2, 2, 201, '2024-01-20', 750.50, '2024-01-15'),
(3, 1, 102, '2024-02-15', 450.00, '2024-01-20'),
(4, 3, 301, '2024-03-01', 1200.00, '2024-01-22'),
(5, 4, 401, '2024-01-25', 650.75, '2024-01-10'),
(6, 5, 501, '2024-03-10', 900.00, '2024-02-05'),
(7, 2, 202, '2024-03-05', 850.00, '2024-02-08'),
(8, 6, 601, '2024-03-20', 1100.00, '2024-02-15'),
(9, 7, 701, '2024-03-25', 780.25, '2024-02-20'),
(10, 8, 801, '2024-03-15', 660.00, '2024-02-22'),
(11, 3, 302, '2024-03-12', 950.00, '2024-03-05'),
(12, 1, 103, '2024-03-15', 530.00, '2024-03-10'),
(13, 9, 901, '2024-03-22', 1250.00, '2024-03-15'),
(14, 4, 402, '2024-04-01', 700.00, '2024-03-20'),
(15, 2, 203, '2024-04-10', 800.00, '2024-03-25');



-- As a Business Analyst on the Airbnb for Work team, your task is to analyze corporate travel expense patterns 
-- to identify potential cost-saving opportunities. Your team is particularly interested in understanding the 
-- average booking costs, company-specific spending behaviors, and the impact of booking timing on costs. By 
-- analyzing these aspects, you aim to provide actionable insights that can help optimize corporate travel expenses.


-- Question 1: What is the average booking cost for corporate travelers? For this question, let's look only 
-- at trips which were booked in January 2024


SELECT ROUND(AVG(booking_cost), 2) AS avg_booking_cost
FROM fct_corporate_bookings
WHERE booking_date BETWEEN '2024-01-01' AND '2024-01-31';


--  Question 2: Identify the top 5 companies with the highest average booking cost per employee for trips taken 
-- during the first quarter of 2024. Note that if an employee takes multiple trips, each booking will show up as 
-- a separate row in fct_corporate_bookings.


WITH employee_avg AS (
  SELECT 
    company_id,
    employee_id,
    AVG(booking_cost) AS employee_avg_booking
  FROM fct_corporate_bookings
  WHERE travel_date BETWEEN '2024-01-01' AND '2024-03-31'
  GROUP BY company_id, employee_id
)

SELECT 
  dc.company_name,
  AVG(ea.employee_avg_booking) AS avg_booking_cost_per_employee
FROM dim_companies dc
JOIN employee_avg ea ON dc.company_id = ea.company_id
GROUP BY dc.company_name
ORDER BY avg_booking_cost_per_employee DESC
LIMIT 5;


-- Question 3: For bookings made in February 2024, what percentage of bookings were made more than 30 days 
-- in advance? Use this to recommend strategies for reducing booking costs.


SELECT 
  ROUND(100.0 * SUM(CASE WHEN travel_date - booking_date > 30 THEN 1 ELSE 0 END) / COUNT(*), 2) AS pct_long_booking
FROM fct_corporate_bookings
WHERE booking_date BETWEEN '2024-02-01' AND '2024-02-28';



-- By analyzing average booking costs, company-specific spending behaviors, and booking timing, your insights can help 
-- Airbnb for Work optimize corporate travel expenses and identify cost-saving opportunities.



