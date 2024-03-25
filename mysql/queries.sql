USE transfermarkt;



-- queries or matches_info_sl_cleaned	
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






-- queries or league_standings
-- Rename 'FC Basel' to 'FC Basel 1893'
UPDATE league_standings
SET Club = 'FC Basel 1893'
WHERE Club = 'FC Basel';

-- Rename 'FC St. Gallen' to 'FC St. Gallen 1879'
UPDATE league_standings
SET Club = 'FC St. Gallen 1879'
WHERE Club = 'FC St. Gallen';

-- Rename 'Grasshoppers' to 'Grasshopper Club Zurich'
UPDATE league_standings
SET Club = 'Grasshopper Club Zurich'
WHERE Club = 'Grasshoppers';



CREATE TABLE league_standings_2022_2023 (
    Place INT,
    Club VARCHAR(255),
    Played INT,
    Wins INT,
    Draws INT,
    Losses INT,
    Goals_Scored INT,
    Goals_Conceded INT,
    Goal_Difference INT,
    Points INT,
    Title_1 VARCHAR(255),
    Title_2 VARCHAR(255),
    Season YEAR
);


INSERT INTO league_standings_2022_2023 (Place, Club, Played, Wins, Draws, Losses, Goals_Scored, Goals_Conceded, Goal_Difference, Points, Title_1, Title_2, Season)
SELECT Place, Club, Played, Wins, Draws, Losses, Goals_Scored, Goals_Conceded, Goal_Difference, Points, Title_1, Title_2, Season
FROM league_standings
WHERE Season = 2022;


ALTER TABLE league_standings_2022_2023 ADD COLUMN team_id INT;

UPDATE league_standings_2022_2023 
SET team_id = (SELECT c.team_id 
               FROM teams c 
               WHERE c.team_name = league_standings_2022_2023.Club);