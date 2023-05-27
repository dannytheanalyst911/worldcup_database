#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.
echo $($PSQL "TRUNCATE TABLE games, teams")
cat games.csv | while IFS="," read YEAR ROUND W O WG OG
do 
  if [[ $W != 'winner' ]]
  then
    echo $($PSQL "INSERT INTO teams(name) VALUES('$W')")
    echo $($PSQL "INSERT INTO teams(name) VALUES('$O')")
    GET_ID_W=$($PSQL "select team_id from teams where name='$W'")
    GET_ID_O=$($PSQL "select team_id from teams where name='$O'")
    echo $($PSQL "INSERT INTO games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) VALUES($YEAR, '$ROUND', $GET_ID_W, $GET_ID_O, $WG, $OG)")
  fi
done
