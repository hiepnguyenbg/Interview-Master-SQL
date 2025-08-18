-- Create database
CREATE DATABASE IF NOT EXISTS engagement_facebook_events_db;
USE engagement_facebook_events_db;

-- Drop existing tables if they exist
DROP TABLE IF EXISTS fct_event_clicks;
DROP TABLE IF EXISTS dim_events;
DROP TABLE IF EXISTS dim_users;

-- Create dim_users table
CREATE TABLE dim_users (
    user_id INT PRIMARY KEY,
    first_name VARCHAR(50),
    last_name VARCHAR(50),
    preferred_category VARCHAR(50)
);

-- Create dim_events table
CREATE TABLE dim_events (
    event_id INT PRIMARY KEY,
    category_name VARCHAR(50)
);

-- Create fct_event_clicks table
CREATE TABLE fct_event_clicks (
    click_id INT PRIMARY KEY,
    user_id INT,
    event_id INT,
    click_date DATE,
    FOREIGN KEY (user_id) REFERENCES dim_users(user_id),
    FOREIGN KEY (event_id) REFERENCES dim_events(event_id)
);

-- Insert data into dim_users
INSERT INTO dim_users (user_id, first_name, last_name, preferred_category) VALUES
(101, 'Alice', 'Smith', 'Music'),
(102, 'Bob', 'Johnson', 'Sports'),
(103, 'Charlie', 'Brown', 'Food'),
(104, 'Diana', 'Adams', 'Travel'),
(105, 'Evan', 'Morris', 'Art'),
(106, 'Fiona', 'Davis', 'Fitness'),
(107, 'George', 'Clark', 'Business'),
(108, 'Hannah', 'Evans', 'Comedy'),
(109, 'Ian', 'Fisher', 'Technology'),
(110, 'Julia', 'Walker', 'Literature');

-- Insert data into dim_events
INSERT INTO dim_events (event_id, category_name) VALUES
(201, 'Music'),
(202, 'Sports'),
(203, 'Food'),
(204, 'Technology'),
(205, 'Travel'),
(206, 'Art'),
(207, 'Fitness'),
(208, 'Literature'),
(209, 'Business'),
(210, 'Comedy');

-- Insert data into fct_event_clicks
INSERT INTO fct_event_clicks (click_id, user_id, event_id, click_date) VALUES
(1, 101, 201, '2024-03-01'),
(2, 102, 202, '2024-03-02'),
(3, 103, 203, '2024-03-03'),
(4, 101, 204, '2024-03-05'),
(5, 104, 205, '2024-03-07'),
(6, 102, 201, '2024-03-10'),
(7, 105, 206, '2024-03-12'),
(8, 106, 207, '2024-03-15'),
(9, 103, 208, '2024-03-20'),
(10, 107, 209, '2024-03-25');
