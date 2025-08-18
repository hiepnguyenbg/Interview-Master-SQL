-- Create the database
CREATE DATABASE IF NOT EXISTS star_wars_game_player_db;
USE star_wars_game_player_db;

-- Create the dim_storyline_components table
CREATE TABLE dim_storyline_components (
  storyline_component_id INT PRIMARY KEY,
  component_name VARCHAR(100) NOT NULL
);

-- Insert data into dim_storyline_components
INSERT INTO dim_storyline_components (storyline_component_id, component_name) VALUES
(1, 'Light Side Redemption'),
(2, 'Dark Side Temptation'),
(3, 'Force Awakening'),
(4, 'Sith Prophecy'),
(5, 'Rebel Alliance'),
(6, 'Jedi Resurrection'),
(7, 'Bounty Hunter Intrigue'),
(8, 'Galactic Conspiracy'),
(9, 'Droid Uprising'),
(10, 'Empire Rebellion');

-- Create the fct_storyline_interactions table
CREATE TABLE fct_storyline_interactions (
  interaction_id INT PRIMARY KEY,
  player_id INT NOT NULL,
  storyline_component_id INT NOT NULL,
  interaction_date DATE NOT NULL,
  FOREIGN KEY (storyline_component_id) REFERENCES dim_storyline_components(storyline_component_id)
);

-- Insert data into fct_storyline_interactions
INSERT INTO fct_storyline_interactions (interaction_id, player_id, interaction_date, storyline_component_id) VALUES
(1, 1, '2024-05-03', 1),
(2, 1, '2024-05-10', 2),
(3, 2, '2024-05-05', 2),
(4, 2, '2024-05-12', 3),
(5, 3, '2024-05-15', 3),
(6, 3, '2024-05-20', 3),
(7, 3, '2024-05-25', 1),
(8, 4, '2024-05-07', 4),
(9, 4, '2024-05-28', 4),
(10, 5, '2024-05-08', 5),
(11, 5, '2024-05-18', 2),
(12, 6, '2024-05-22', 5),
(13, 1, '2024-05-02', 1),
(14, 2, '2024-05-30', 3),
(15, 6, '2024-05-30', 1),
(16, 7, '2024-05-11', 6),
(17, 7, '2024-05-19', 6),
(18, 8, '2024-05-14', 7),
(19, 8, '2024-05-21', 8),
(20, 9, '2024-05-17', 9);





-- You are a Product Analyst for the Star Wars Game Development team investigating player storyline interactions. 
-- The team wants to understand how different narrative elements capture player attention and engagement. 
-- Your goal is to analyze player interaction patterns across various storyline components.



-- Question 1: For each storyline component, how many unique players interacted with that component during the entire 
-- month of May 2024? If a storyline component did not have any interactions, return the component name with the player count of 0.

SELECT 
  dsc.component_name, 
  COALESCE(COUNT(DISTINCT fsi.player_id), 0) AS n_player
FROM dim_storyline_components dsc
LEFT JOIN fct_storyline_interactions fsi 
  ON dsc.storyline_component_id = fsi.storyline_component_id
  AND fsi.interaction_date BETWEEN '2024-05-01' AND '2024-05-31'
GROUP BY dsc.component_name
ORDER BY n_player DESC;



-- Question 2: What is the total number of storyline interactions for each storyline component and player combination during 
-- May 2024? Consider only those players who have interacted with at least two different storyline components.

WITH at_least_two_components AS (
  SELECT player_id
  FROM fct_storyline_interactions
  WHERE interaction_date BETWEEN '2024-05-01' AND '2024-05-31'
  GROUP BY player_id
  HAVING COUNT(DISTINCT storyline_component_id) >= 2
)

SELECT 
  fsi.storyline_component_id, 
  fsi.player_id, 
  COUNT(fsi.interaction_id) AS n_interactions
FROM fct_storyline_interactions fsi
JOIN at_least_two_components alt
  ON fsi.player_id = alt.player_id
WHERE fsi.interaction_date BETWEEN '2024-05-01' AND '2024-05-31'
GROUP BY fsi.storyline_component_id, fsi.player_id
ORDER BY n_interactions DESC;


-- Question 3: Can you rank the storyline components by the average number of interactions per player during May 2024? 
-- Provide a list of storyline component names and their ranking.

SELECT 
  component_name, 
  COUNT(*) / COUNT(DISTINCT player_id) AS avg_interactions,
  RANK() OVER (ORDER BY COUNT(*) / COUNT(DISTINCT player_id) DESC) AS interaction_rank
FROM dim_storyline_components dsc
JOIN fct_storyline_interactions fsi 
  ON dsc.storyline_component_id = fsi.storyline_component_id
  AND fsi.interaction_date BETWEEN '2024-05-01' AND '2024-05-31'
GROUP BY component_name;
