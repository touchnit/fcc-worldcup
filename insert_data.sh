#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

# get argument from script games.csv
# parse while do done // set IFS to ","
  # YEAR COMA ROUND COMA WINNER COMA OPPONENT COMA WINNER_GOALS COMA OPPONENT_GOALS
tail -n +2 games.csv | while IFS="," read -r YEAR ROUND WINNER OPPONENT WINNER_GOALS OPPONENT_GOALS
  do
  echo "$ROUND : $WINNER $WINNER_GOALS - $OPPONENT $OPPONENT_GOALS"
  WINNER_DB=$($PSQL "SELECT * FROM teams WHERE name = '$WINNER';")
  # check if WINNER exists in team table
    if [[ -z $WINNER_DB ]]
    then
    # if it doesn't add team in teams db
    ADD_WINNER=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER');")
    echo "$WINNER - $ADD_WINNER"
    fi
  # check if OPPONENT exists in team table
  OPPONENT_DB=$($PSQL "SELECT * FROM teams WHERE name = '$OPPONENT';")
    # if it doesn't add team in teams db
    if [[ -z $OPPONENT_DB ]]
    then
    # if it doesn't add team in teams db
    ADD_OPPONENT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT');")
    echo "$OPPONENT - $ADD_OPPONENT"
    fi
  # add game info to game table
  INSERT_GAME_DATA=$($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals)
  SELECT '$YEAR', '$ROUND', t1.team_id, t2.team_id, $WINNER_GOALS, $OPPONENT_GOALS
  FROM teams t1, teams t2
  WHERE t1.name = '$WINNER' AND t2.name = '$OPPONENT'
  ;")
  echo $INSERT_GAME_DATA

    # insert year, round, winner_id, opponent_id, winner_goals, opponent_goals;
  done