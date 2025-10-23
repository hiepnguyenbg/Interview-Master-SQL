-- Create database
DROP DATABASE IF EXISTS  stays_listing_earnings_db;
CREATE DATABASE stays_listing_earnings_db;
USE stays_listing_earnings_db;

-- Create dim_listings table
CREATE TABLE dim_listings (
  listing_id INT PRIMARY KEY,
  amenities TEXT,
  location TEXT
);

-- Insert data into dim_listings
INSERT INTO dim_listings (listing_id, amenities, location) VALUES
(1, 'pool, wifi, kitchen', 'Miami Beach'),
(2, 'ocean view, balcony, wifi', 'Santa Monica'),
(3, 'wifi, kitchen', 'New York'),
(4, 'pool, garden, wifi', 'Los Angeles'),
(5, 'ocean view, pool, gym', 'San Diego'),
(6, 'wifi, parking', 'Chicago'),
(7, 'kitchen, ocean view', 'Boston'),
(8, 'pool, wifi', 'Orlando'),
(9, 'balcony, garden', 'Austin'),
(10, 'ocean view, spa', 'Malibu'),
(11, 'wifi, kitchen', 'Denver'),
(12, 'pool, ocean view, rooftop', 'Las Vegas');

-- Create fct_bookings table
CREATE TABLE fct_bookings (
  booking_id INT PRIMARY KEY,
  listing_id INT,
  booking_date DATE,
  cleaning_fee DECIMAL(10,2),
  booked_nights INT,
  nightly_price DECIMAL(10,2),
  FOREIGN KEY (listing_id) REFERENCES dim_listings(listing_id)
);

-- Insert data into fct_bookings
INSERT INTO fct_bookings (booking_id, listing_id, booking_date, cleaning_fee, booked_nights, nightly_price) VALUES
(1, 1, '2024-07-03', 50, 3, 200),
(2, 2, '2024-07-10', NULL, 5, 240),
(3, 2, '2024-07-20', NULL, 2, 250),
(4, 4, '2024-07-11', 40, 4, 220),
(5, 5, '2024-07-12', 30, 7, 300),
(6, 7, '2024-07-18', NULL, 3, 270),
(7, 8, '2024-07-25', 20, 2, 190),
(8, 10, '2024-07-22', 70, 6, 350),
(9, 12, '2024-07-19', 80, 3, 400),
(10, 12, '2024-07-21', 80, 5, 410),
(11, 3, '2024-07-15', 30, 1, 180),
(12, 6, '2024-07-14', 20, 2, 155),
(13, 9, '2024-07-05', 45, 4, 210),
(14, 11, '2024-07-08', 25, 3, 160),
(15, 1, '2024-08-01', 50, 5, 205);





-- As a Product Analyst on the Airbnb Stays team, you are investigating how listing amenities and pricing 
-- strategies impact hosts' supplemental income. Your focus is on understanding the influence of features 
-- like pools or ocean views, and the effect of cleaning fees on pricing. Your goal is to derive insights 
-- that will help build a pricing recommendation framework to optimize potential nightly earnings for hosts.


-- Question 1: What is the overall average nightly price for listings with either a 'pool' or 'ocean view' in 
-- July 2024? Consider only listings that have been booked at least once during this period.


SELECT ROUND(AVG(nightly_price), 2) AS avg_price
FROM fct_bookings fb
JOIN dim_listings dl ON fb.listing_id = dl.listing_id
WHERE (amenities LIKE '%pool%' OR amenities LIKE '%ocean view%')
  AND booking_date BETWEEN '2024-07-01' AND '2024-07-31';


-- Question 2: For listings with no cleaning fee (i.e., NULL values in the 'cleaning_fee' column), what is the 
-- average difference in nightly price compared to listings with a cleaning fee in July 2024?

SELECT
  ROUND(
    AVG(CASE WHEN cleaning_fee IS NULL THEN nightly_price END) -
    AVG(CASE WHEN cleaning_fee IS NOT NULL THEN nightly_price END),
    2
  ) AS avg_price_diff
FROM fct_bookings
WHERE booking_date BETWEEN '2024-07-01' AND '2024-07-31';



-- Question 3: Based on the top 50% of listings by earnings in July 2024, what percentage of these listings 
-- have ‘ocean view’ as an amenity? For this analysis, look at bookings that were made in July 2024.


-- WITH earnings_per_listing AS (
--   SELECT
--     listing_id,
--     SUM(nightly_price * booked_nights + IFNULL(cleaning_fee, 0)) AS total_earnings
--   FROM fct_bookings
--   WHERE booking_date BETWEEN '2024-07-01' AND '2024-07-31'
--   GROUP BY listing_id
-- ),
-- ranked_listings AS (
--   SELECT *,
--          PERCENT_RANK() OVER (ORDER BY total_earnings DESC) AS percentile
--   FROM earnings_per_listing
-- )
-- SELECT ROUND(100.0*SUM(CASE WHEN amenities LIKE '%ocean view%' THEN 1 END) /COUNT(*),2) as pct_ocean_view
-- FROM ranked_listings rl
-- JOIN dim_listings dl ON rl.listing_id = dl.listing_id
-- WHERE percentile <= 0.5;


WITH ranked AS (
  SELECT
    l.listing_id,
    dl.amenities,
    PERCENT_RANK() OVER (ORDER BY SUM(nightly_price * booked_nights + COALESCE(cleaning_fee, 0)) DESC) AS pct_rank
  FROM fct_bookings l
  JOIN dim_listings dl ON l.listing_id = dl.listing_id
  WHERE booking_date BETWEEN '2024-07-01' AND '2024-07-31'
  GROUP BY l.listing_id, dl.amenities
)
SELECT 
  ROUND(
    100.0 * SUM(CASE WHEN amenities LIKE '%ocean view%' THEN 1 ELSE 0 END) 
            / COUNT(*), 
    2
  ) AS pct_ocean_view
FROM ranked
WHERE pct_rank <= 0.5;



