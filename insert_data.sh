#! /bin/bash

# Set the correct database connection based on test mode
if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

echo $($PSQL "TRUNCATE TABLE games, teams RESTART IDENTITY;")

cat games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    for TEAM in "$WINNER" "$OPPONENT"
    do
      TEAM_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$TEAM';")
      if [[ -z $TEAM_ID ]]
      then
        INSERT_TEAM=$($PSQL "INSERT INTO teams(name) VALUES('$TEAM');")
        echo "Inserted team: $TEAM"
      fi
    done

    # Get team IDs
    WINNER_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$WINNER';")
    OPPONENT_ID=$($PSQL "SELECT team_id FROM teams WHERE name='$OPPONENT';")

    # Insert game data
    INSERT_GAME=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) 
                         VALUES($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOALS, $OPPONENT_GOALS);")
    echo "Inserted game: $YEAR, $ROUND - $WINNER vs $OPPONENT"
  fi
done
