#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

#Truncate all existing data on the games and teams table
echo "$($PSQL "TRUNCATE TABLE games,teams")"

cat games.csv | while IFS="," read YEAR ROUND WINNER OPPONENT W_GOALS O_GOALS
do
  if [[ $YEAR != "year" ]]
  then
    #Get Winner Team ID
    WINNER_TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")

    #If Not Found
    if [[ -z $WINNER_TEAM_ID ]]
    then
      #Insert into the Teams table
      INSERT_WINNER_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$WINNER')")
      #Get the Winner Team ID
      WINNER_TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$WINNER'")

    fi

    #Get Opponent Team ID
    OPP_TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

    #IF Not Found
    if [[ -z $OPP_TEAM_ID ]]
    then
      #Insert into the Teams Table
      INSERT_OPP_RESULT=$($PSQL "INSERT INTO teams(name) VALUES('$OPPONENT')")
      #Get the Opponent Team ID
      OPP_TEAM_ID=$($PSQL "SELECT team_id from teams WHERE name='$OPPONENT'")

    fi

    #Insert the game information with the Team IDs into the game table
    INSERT_GAME_RESULT=$($PSQL "INSERT INTO games(year,round,winner_id,opponent_id,winner_goals,opponent_goals) VALUES('$YEAR','$ROUND',$WINNER_TEAM_ID,$OPP_TEAM_ID,'$W_GOALS','$O_GOALS')")
  fi
done