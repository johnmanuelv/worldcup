#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"

# Total number of goals in all games from winning teams
echo "Total number of goals in all games from winning teams:"
echo "$($PSQL "SELECT SUM(winner_goals) FROM games;")"

# Total number of goals in all games from both teams combined
echo "Total number of goals in all games from both teams combined:"
echo "$($PSQL "SELECT SUM(winner_goals) + SUM(opponent_goals) FROM games;")"

# Average number of goals in all games from winning teams
echo "Average number of goals in all games from the winning teams:"
echo "$($PSQL "SELECT AVG(winner_goals) FROM games;")"

# Average number of goals in all games from the winning teams rounded to two decimal places
echo "Average number of goals in all games from the winning teams rounded to two decimal places:"
echo "$($PSQL "SELECT ROUND(AVG(winner_goals), 2) FROM games;")"

# Average number of goals in all games from both teams
echo "Average number of goals in all games from both teams:"
echo "$($PSQL "SELECT AVG(winner_goals + opponent_goals) FROM games;")"

# Most goals scored in a single game by one team
echo "Most goals scored in a single game by one team:"
echo "$($PSQL "SELECT MAX(GREATEST(winner_goals, opponent_goals)) FROM games;")"

# Number of games where the winning team scored more than two goals
echo "Number of games where the winning team scored more than two goals:"
echo "$($PSQL "SELECT COUNT(*) FROM games WHERE winner_goals > 2;")"

# Winner of the 2018 tournament team name
echo "Winner of the 2018 tournament team name:"
echo "$($PSQL "SELECT name FROM teams INNER JOIN games ON teams.team_id = games.winner_id WHERE year=2018 AND round='Final';")"

# List of teams who played in the 2014 'Eighth-Final' round
echo "List of teams who played in the 2014 'Eighth-Final' round:"
echo "$($PSQL "SELECT DISTINCT name FROM teams INNER JOIN games ON teams.team_id IN (games.winner_id, games.opponent_id) WHERE year=2014 AND round='Eighth-Final' ORDER BY name;")"

# List of unique winning team names in the whole data set
echo "List of unique winning team names in the whole data set:"
echo "$($PSQL "SELECT DISTINCT name FROM teams INNER JOIN games ON teams.team_id = games.winner_id ORDER BY name;")"

# Year and team name of all the champions
echo "Year and team name of all the champions:"
echo "$($PSQL "SELECT year || '|' || name FROM teams INNER JOIN games ON teams.team_id = games.winner_id WHERE round='Final' ORDER BY year;")"

# List of teams that start with 'Co'
echo "List of teams that start with 'Co':"
echo "$($PSQL "SELECT name FROM teams WHERE name LIKE 'Co%';")"
