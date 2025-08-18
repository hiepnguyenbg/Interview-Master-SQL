-- Create the database
CREATE DATABASE IF NOT EXISTS marketing_segment_strategy_cross_brand_db;
USE marketing_segment_strategy_cross_brand_db;

-- Create dim_segment table
CREATE TABLE dim_segment (
    segment_id INT PRIMARY KEY,
    segment_name VARCHAR(100),
    description VARCHAR(255)
);

-- Insert data into dim_segment
INSERT INTO dim_segment (segment_id, segment_name, description) VALUES
(1, 'Retail', 'Consumer retail segment focusing on online shopping'),
(2, 'AWS', 'Cloud computing services segment'),
(3, 'Entertainment', 'Digital streaming and media content');

-- Create brand_score_metrics table
CREATE TABLE brand_score_metrics (
    metric_date DATE,
    segment_id INT,
    key_message VARCHAR(255),
    brand_score DECIMAL(5,2),
    FOREIGN KEY (segment_id) REFERENCES dim_segment(segment_id)
);

-- Insert data into brand_score_metrics
INSERT INTO brand_score_metrics (metric_date, segment_id, key_message, brand_score) VALUES
('2024-10-05', 1, 'Exceptional customer service drives loyalty', 85.5),
('2024-10-10', 2, 'Innovative cloud solutions powering business', 92),
('2024-10-15', 3, 'Quality content with a personal touch', 88),
('2024-11-02', 2, 'Scalable infrastructure to empower enterprises', 89),
('2024-11-05', 3, 'Engaging digital narratives win hearts', 81.5),
('2024-11-18', 1, 'Convenience meets quality in every delivery', 87),
('2024-12-01', 2, 'Seamless cloud integration and security', 95),
('2024-12-12', 3, 'Delivering immersive viewing experiences', 82),
('2024-12-20', 2, 'Advanced analytics for a smarter future', 90),
('2024-10-30', 3, 'A vibrant mix of classic and modern storytelling', 79),
('2024-09-20', 1, 'Pre-Q4 promo boost for holiday season', 84),
('2024-10-22', 2, 'Pioneering technology in a dynamic market', 88),
('2024-12-25', 3, 'Festive specials capture family memories', 92),
('2024-11-30', 2, 'Reliable cloud performance even under pressure', 91.5),
('2024-12-28', 3, 'Entertaining audiences with groundbreaking series', 83);






-- As a Data Analyst, you and your team are tasked with evaluating brand consistency across Amazon's diverse 
-- business segments, including retail, AWS, and entertainment. The focus is on analyzing key messaging and 
-- brand perception metrics to ensure strategic alignment across these segments. Your goal is to identify 
-- opportunities for more unified brand communication by examining brand scores and key messages in these areas.





-- Question 1: The Marketing team wants to start their evaluation of brand messaging for Q4 2024. Could you provide 
-- a list of the key messaging and brand score details recorded between October 1, 2024 and December 31, 2024?


SELECT key_message, brand_score
FROM brand_score_metrics
WHERE metric_date BETWEEN '2024-10-01' AND '2024-12-31';


-- Question 2: For a more focused analysis, the Marketing team needs the key messaging and brand score details 
-- for the AWS segment (represented by segment_id = 2) in Q4 2024, but only for records where the brand score 
-- is at or above 90. Could you retrieve these details?


SELECT key_message, brand_score
FROM brand_score_metrics
WHERE metric_date BETWEEN '2024-10-01' AND '2024-12-31'
AND segment_id = 2
AND brand_score >= 90;


-- Question 3: To quickly review a snapshot of the findings, the Marketing team would like to see a sample of the 
-- key messaging and brand score details for the Entertainment segment (represented by segment_id = 3) with a brand 
-- score above 80. Could you provide the 5 most recent records that meet these criteria?

SELECT key_message, brand_score
FROM brand_score_metrics
WHERE segment_id = 3
AND brand_score > 80
ORDER BY metric_date DESC
LIMIT 5;




-- Your analyses of brand messaging and brand scores across Amazon's segments will help the Marketing team evaluate 
-- brand consistency and identify opportunities for more unified brand communication across retail, AWS, and entertainment.
