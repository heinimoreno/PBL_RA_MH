USE transfermarkt;

-- SQL statement to create the table for Home Teams
CREATE TABLE home_teams (
    MatchID INT,
    HomeTeam VARCHAR(255),
    HomeTeamPoints INT,
    GoalsHomeTeam INT
);

-- SQL statement to insert data into the home_teams table from matches_info_sl_cleaned
INSERT INTO home_teams (MatchID, HomeTeam, HomeTeamPoints, GoalsHomeTeam)
SELECT MatchID, HomeTeam, HomeTeamPoints, GoalsHomeTeam
FROM matches_info_sl_cleaned;

-- SQL statement to create the table for Away Teams
CREATE TABLE away_teams (
    MatchID INT,
    AwayTeam VARCHAR(255),
    AwayTeamPoints INT,
    GoalsAwayTeam INT
);

-- SQL statement to insert data into the away_teams table from matches_info_sl_cleaned
INSERT INTO away_teams (MatchID, AwayTeam, AwayTeamPoints, GoalsAwayTeam)
SELECT MatchID, AwayTeam, AwayTeamPoints, GoalsAwayTeam
FROM matches_info_sl_cleaned;


ALTER TABLE home_teams ADD COLUMN club_id INT;
ALTER TABLE away_teams ADD COLUMN club_id INT;
ALTER TABLE home_teams DROP COLUMN club_id;
ALTER TABLE away_teams DROP COLUMN club_id;

-- SQL statement to create the table 'teams'
CREATE TABLE teams (
    team_id INT AUTO_INCREMENT PRIMARY KEY,
    team_name VARCHAR(255) NOT NULL
);

-- SQL statement to insert unique team names into the 'teams' table
-- This assumes that the combination of team names in the 'HomeTeam' and 'AwayTeam' columns covers all teams
INSERT INTO teams (team_name)
SELECT DISTINCT HomeTeam
FROM matches_info_sl_cleaned
UNION
SELECT DISTINCT AwayTeam
FROM matches_info_sl_cleaned;

ALTER TABLE home_teams ADD COLUMN team_id INT;
ALTER TABLE away_teams ADD COLUMN team_id INT;

UPDATE home_teams 
SET team_id = (SELECT c.team_id 
               FROM teams c 
               WHERE c.team_name = home_teams.HomeTeam);
               
               
UPDATE away_teams 
SET team_id = (SELECT c.team_id 
               FROM teams c 
               WHERE c.team_name = away_teams.AwayTeam);



