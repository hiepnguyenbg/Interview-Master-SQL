-- Create the database
CREATE DATABASE IF NOT EXISTS facebook_marketplace_item_price_db;
USE facebook_marketplace_item_price_db;

-- Create the Listings table
CREATE TABLE Listings (
  listing_id INT PRIMARY KEY,
  category VARCHAR(50),
  price DECIMAL(10,2),
  city VARCHAR(100),
  user_id INT
);

-- Insert the provided data
INSERT INTO Listings (city, price, user_id, category, listing_id) VALUES
('New York', 150, 101, 'Electronics', 1),
('San Francisco', 120, 102, 'Electronics', 2),
('New York', 300, 103, 'Furniture', 3),
('Los Angeles', 250, 104, 'Furniture', 4),
('Los Angeles', 50, 105, 'Clothing', 5),
('San Francisco', 70, 106, 'Clothing', 6),
('Los Angeles', 180, 107, 'Electronics', 7),
('San Francisco', 350, 108, 'Furniture', 8),
('New York', 60, 109, 'Clothing', 9);



-- Your Product Manager of Facebook Marketplace wants to understand how items are priced across cities.




-- Question 1: Can you find the average price of items listed in each category on Facebook Marketplace? 
-- We want to understand the pricing trends across different categories.

SELECT 
  category, 
  AVG(price) AS avg_price
FROM listings
GROUP BY category
ORDER BY avg_price DESC;


-- Question 2: Which city has the lowest average price? This will help us identify the most affordable cities for buyers.

SELECT city, AVG(price) AS avg_price
FROM listings
GROUP BY city
ORDER BY avg_price ASC
LIMIT 1;


