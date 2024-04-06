USE Season_23_24;

-- Add the 'Player_ID' column to the 'players' table
ALTER TABLE players ADD COLUMN Player_ID INT PRIMARY KEY AUTO_INCREMENT;


-- Use the Season_23_24 schema
USE Season_23_24;

-- Create a new table with the same structure as lineups_2022_2023_sl_complete
CREATE TABLE lineups_2022_2023_sl_complete LIKE transfermarkt.lineups_2022_2023_sl_complete;

-- Copy the data from the existing table to the new table
INSERT INTO lineups_2022_2023_sl_complete SELECT * FROM transfermarkt.lineups_2022_2023_sl_complete;



-- Create the 'positions' table
CREATE TABLE IF NOT EXISTS positions (
    Position_ID INT PRIMARY KEY AUTO_INCREMENT,
    Position VARCHAR(50)
);

-- Insert distinct positions from the 'players' table
INSERT INTO positions (Position)
SELECT DISTINCT Position FROM players;


-- Add the 'Position_ID' column to the 'players' table
ALTER TABLE players ADD COLUMN Position_ID INT;

-- Update the 'Position_ID' in the 'players' table based on the 'positions' table
UPDATE players p
JOIN positions pos ON p.Position = pos.Position
SET p.Position_ID = pos.Position_ID;


-- Add the 'Position_ID' column to the 'lineups_2022_2023_sl_complete' table
ALTER TABLE lineups_2022_2023_sl_complete ADD COLUMN Position_ID INT;

-- Update the 'Position_ID' in the 'lineups_2022_2023_sl_complete' table based on the 'positions' table
UPDATE lineups_2022_2023_sl_complete l
JOIN positions p ON l.Position = p.Position
SET l.Position_ID = p.Position_ID;




-- Add the 'Player_ID' column to the 'lineups_2022_2023_sl_complete' table
ALTER TABLE lineups_2022_2023_sl_complete ADD COLUMN Player_ID INT;

-- Update the 'Player_ID' in the 'lineups_2022_2023_sl_complete' table based on the 'players' table
UPDATE lineups_2022_2023_sl_complete l
JOIN players p ON l.Player = p.Name
SET l.Player_ID = p.Player_ID;


-- Remove 'Player_ID' column from both tables
ALTER TABLE lineups_2022_2023_sl_complete DROP COLUMN Player_ID;
ALTER TABLE players DROP COLUMN Player_ID;


-- Create the 'players_key' table
CREATE TABLE IF NOT EXISTS players_key (
    Player_ID INT PRIMARY KEY AUTO_INCREMENT,
    Player VARCHAR(255) UNIQUE
);

-- Insert distinct player names from the 'lineups_2022_2023_sl_complete' table
INSERT INTO players_key (Player)
SELECT DISTINCT Player
FROM lineups_2022_2023_sl_complete
ON DUPLICATE KEY UPDATE Player = VALUES(Player);


-- Add 'Player_ID' column to the 'players' table
ALTER TABLE players ADD COLUMN Player_ID INT;

-- Add 'Player_ID' column to the 'lineups_2022_2023_sl_complete' table
ALTER TABLE lineups_2022_2023_sl_complete ADD COLUMN Player_ID INT;

-- Update 'Player_ID' in the 'players' table based on 'players_key'
UPDATE players p
JOIN players_key pk ON p.Name = pk.Player
SET p.Player_ID = pk.Player_ID;

-- Update 'Player_ID' in the 'lineups_2022_2023_sl_complete' table based on 'players_key'
UPDATE lineups_2022_2023_sl_complete l
JOIN players_key pk ON l.Player = pk.Player
SET l.Player_ID = pk.Player_ID;


-- Insert new players from 'players' into 'players_key' if they don't exist
INSERT INTO players_key (Player)
SELECT DISTINCT Name
FROM players
WHERE Name NOT IN (SELECT Player FROM players_key)
ON DUPLICATE KEY UPDATE Player = VALUES(Player);

-- Update 'Player_ID' in the 'players' table for any null entries
UPDATE players p
JOIN players_key pk ON p.Name = pk.Player
SET p.Player_ID = pk.Player_ID
WHERE p.Player_ID IS NULL;


-- Add 'Club_ID' column to the 'lineups_2022_2023_sl_complete' table
ALTER TABLE lineups_2022_2023_sl_complete ADD COLUMN Club_ID INT;

-- Update 'Club_ID' in the 'lineups_2022_2023_sl_complete' table based on the 'clubs' table
UPDATE lineups_2022_2023_sl_complete l
JOIN clubs c ON l.Club = c.Club
SET l.Club_ID = c.Club_ID;