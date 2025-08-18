CREATE DATABASE ad_segment_performance_analysis_db;
USE ad_segment_performance_analysis_db;

-- Drop tables if they exist (to reset)
DROP TABLE IF EXISTS ad_performance;
DROP TABLE IF EXISTS audience_segments;

-- Create audience_segments table
CREATE TABLE audience_segments (
  audience_segment_id INT PRIMARY KEY,
  segment_name VARCHAR(100) NOT NULL
);

-- Create ad_performance table
CREATE TABLE ad_performance (
  ad_id INT,
  audience_segment_id INT,
  impressions INT,
  conversions INT,
  ad_spend DECIMAL(10, 2),
  date DATE,
  FOREIGN KEY (audience_segment_id) REFERENCES audience_segments(audience_segment_id)
);

-- Insert data into audience_segments
INSERT INTO audience_segments (audience_segment_id, segment_name) VALUES
(1, 'Custom Audience - App Installers'),
(2, 'Custom Audience - Email List Subscribers'),
(3, 'Custom Audience - Video Viewers (25% Watched)'),
(4, 'Lookalike Audience - Purchasers'),
(5, 'Lookalike Audience - Website Visitors'),
(6, 'Interest-based Audience - Fitness Enthusiasts'),
(7, 'Interest-based Audience - Gamers'),
(8, 'Saved Audience - US, 18-24'),
(9, 'Saved Audience - Europe, 25-34');

-- Insert data into ad_performance
INSERT INTO ad_performance (date, ad_id, ad_spend, conversions, impressions, audience_segment_id) VALUES
('2024-10-02', 1, 38.00, 80, 10000, 1),
('2024-10-14', 2, 44.25, 90, 10000, 1),
('2024-10-02', 3, 20.00, 50, 5000, 2),
('2024-10-10', 4, 35.25, 70, 8000, 2),
('2024-10-20', 5, 60.50, 110, 12000, 2),
('2024-10-10', 6, 40.00, 60, 8000, 3),
('2024-10-23', 7, 48.25, 80, 10000, 3),
('2024-10-29', 8, 50.00, 115, 11000, 3),
('2024-09-25', 9, 20.00, 35, 5000, 1),
('2024-09-15', 10, 15.00, 25, 3000, 2),
('2024-10-05', 11, 25.00, 40, 6000, 4),
('2024-10-20', 12, 30.00, 20, 7000, 8),
('2024-08-10', 13, 10.00, 15, 3000, 5),
('2024-10-15', 14, 18.75, 30, 4000, 6),
('2024-09-10', 15, 25.00, 20, 4500, 7);


-- As a Data Analyst on the Marketing Performance team, you are tasked with evaluating the 
-- effectiveness of our custom audience segments and lookalike audiences in driving user 
-- acquisition and conversions. Your team aims to optimize advertising strategies by analyzing key 
-- performance metrics such as ad impressions, total conversions, and cost per conversion across 
-- different audience segments. By leveraging this data, you will provide actionable insights to 
-- enhance campaign efficiency and improve overall marketing performance.


-- Question 1: How many total ad impressions did we receive from custom audience segments in October 2024?

select sum(impressions) as total_impressions
from ad_performance ap
join audience_segments ase on ap.audience_segment_id = ase.audience_segment_id
where date between '2024-10-01' and '2024-10-31'
and segment_name like '%custom%';


-- Question 2: What is the total number of conversions we achieved from each custom audience segment in October 2024?

select segment_name, sum(conversions) as total_conversions
from ad_performance ap
join audience_segments ase on ap.audience_segment_id = ase.audience_segment_id
where date between '2024-10-01' and '2024-10-31'
and segment_name like '%custom%'
group by 1
order by 2 desc;


-- Question 3: For each custom audience or lookalike segment, calculate the cost per conversion. Only return 
-- this for segments that had non-zero spend and non-zero conversions.

-- Cost per conversion = Total ad spend / Total number of conversions

select segment_name, sum(ad_spend)/sum(conversions) as cost_per_conversion
from ad_performance ap
join audience_segments ase on ap.audience_segment_id = ase.audience_segment_id
where segment_name like '%custom%' or segment_name like '%lookalike%'
group by 1
having sum(ad_spend) <>0 and sum(conversions)<>0
order by 2 desc;


