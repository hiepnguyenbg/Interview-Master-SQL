-- Create the database
CREATE DATABASE IF NOT EXISTS gpt4_response_context_depth_db;
USE gpt4_response_context_depth_db;

-- Create the table
CREATE TABLE fct_context_retention (
    inquiry_type VARCHAR(50),
    context_retention_score FLOAT,
    response_date DATE,
    model_name VARCHAR(50)
);

-- Insert sample data
INSERT INTO fct_context_retention (model_name, inquiry_type, response_date, context_retention_score) VALUES
('GPT-4', 'legal', '2024-04-03', 85.5),
('GPT-4', 'finance', '2024-04-05', 78.2),
('GPT-4', 'tech', '2024-04-08', 92.7),
('GPT-4', 'health', '2024-04-10', 80.0),
('GPT-4', 'engineering', '2024-04-12', 88.9),
('GPT-4', 'legal', '2024-04-15', 90.1),
('GPT-4', 'finance', '2024-04-18', 75.5),
('GPT-4', 'tech', '2024-04-20', 95.4),
('GPT-4', 'health', '2024-04-22', 82.3),
('GPT-4', 'engineering', '2024-04-25', 87.6),
('GPT-4', 'legal', '2024-04-27', 84.0),
('GPT-4', 'engineering', '2024-04-28', 89.3),
('GPT-4', 'tech', '2024-04-29', 91.0),
('GPT-4', 'finance', '2024-04-30', 76.8),
('GPT-3.5', 'finance', '2024-04-11', 65.0),
('GPT-4', 'tech', '2024-05-01', 88.8),
('GPT-4', 'legal', '2024-03-30', 79.9);





-- You are a Data Analyst on the OpenAI GPT-4 team, focusing on evaluating the model's ability to retain context and 
-- handle complex inquiries across different domains. Your team is particularly interested in understanding the average 
-- and peak performance of GPT-4's context retention, as well as identifying which inquiry types may require further 
-- enhancements. By analyzing these metrics, you will provide insights to guide improvements in GPT-4's contextual 
-- processing capabilities.




-- Question 1: What is the average context retention score for GPT-4 responses in April 2024? This will help us determine a 
-- baseline measure of GPT-4's response complexity.



SELECT AVG(context_retention_score) AS avg_retention_score
FROM fct_context_retention
WHERE response_date BETWEEN '2024-04-01' AND '2024-04-30'
AND model_name = 'GPT-4';


-- Question 2: What is the highest context retention score recorded by GPT-4 for the 'legal' inquiry type in April 2024? 
-- This will highlight the peak performance in terms of contextual processing.



SELECT MAX(context_retention_score) AS max_retention_score
FROM fct_context_retention
WHERE model_name = 'GPT-4'
  AND inquiry_type = 'legal'
  AND response_date BETWEEN '2024-04-01' AND '2024-04-30';



-- Question 3: What is the average context retention score for each inquiry type for GPT-4 responses in April 2024, 
-- rounded to two decimal places? This breakdown will directly inform which inquiry domains may need enhancements in 
-- GPT-4's contextual understanding.



SELECT inquiry_type, ROUND(AVG(context_retention_score),2) AS avg_retention_score
FROM fct_context_retention
WHERE model_name = 'GPT-4'
  AND response_date BETWEEN '2024-04-01' AND '2024-04-30'
GROUP BY inquiry_type;




-- Your analyses on average and peak context retention scores, as well as the breakdown by inquiry type, will help 
-- the OpenAI GPT-4 team understand where the model performs well and which inquiry domains might need further 
-- improvements in contextual understanding.