#!/bin/bash
PSQL="psql -X --username=freecodecamp --dbname=number_guess --no-align --tuples-only -c"

#READ THE USERNAME
echo "Enter your username:"
read USERNAME
#echo $USERNAME

#SEARCH FOR THE USER IN DATABASE
USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
RETURNING_USER=$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")
#echo $USER_FROM_DB

#IF NOT EXIST

#SAVE THE NEW NAME AND PROMPT THE WELCOME MESSAGE FOR NEW GAMERS
if [[ -z $USER_ID ]]
  then
    INSERT_NEW_NAME=$($PSQL "INSERT INTO users(username) VALUES('$USERNAME')")
    USER_ID=$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")
    echo "Welcome, $USERNAME! It looks like this is your first time here."

#ELSE, PROMPT THE WELCOME MESSAGE FOR OLD GAMERS, SEARCH TOTAL NUMBER OF GAMES AND FEWST NUMBER OF GUESSES 
else
  GAMES_PLAYED=$($PSQL "SELECT COUNT(*) FROM games INNER JOIN users USING(user_id) WHERE user_id=$USER_ID")
  BEST_GAME=$($PSQL "SELECT MIN(guesses) FROM games INNER JOIN users USING(user_id) WHERE user_id =$USER_ID")
  #NUMBER_OF_GUESSES=$($PSQL "SELECT MIN(guesses) FROM games INNER JOIN users USING(user_id)  WHERE user_id=$USER_ID")
  echo "Welcome back, $RETURNING_USER! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."

fi

#GENERATE THE RANDOM BETWEEN (1:1000) NUMBER AND START THE GAME AND READ THE NUMBER
RANDOM_NUMBER=$((1 + RANDOM % 1000))
echo "Guess the secret number between 1 and 1000:"
echo $RANDOM_NUMBER
read NUMBER

TRIES=1
#WHILE RANDOM NUMBER IS DIFFERENT
while [[ $RANDOM_NUMBER != $NUMBER ]]
do
  
  #IF IS AN INTEGER
  if [[ $NUMBER =~ ^[0-9]+$ ]]
    then
      #echo "its a number"
      
      #IF RANDOM NUMBER IS HIGHER THAN
      if [[ $NUMBER -lt $RANDOM_NUMBER ]]
        then
          echo "It's higher than that, guess again:"
          
          #READ THE NUMBER AGAIN AND SUM 1 TO THE ATTEMPTS
          read NUMBER
          TRIES=$(( TRIES +1 ))

        #ELIF RANDOM NUMBER IS LOWER THAN
      elif [[ $NUMBER -gt $RANDOM_NUMBER ]]
        then
          echo "It's lower than that, guess again:"

          #READ THE NUMBER AGAIN AND SUM 1 TO THE ATTEMPTS
          read NUMBER
          TRIES=$(( TRIES +1 ))

      #ELIF RANDOM NUMBER IS EQUAL


        #SUM 1 TO THE ATTEMPTS AND SAVE THE RECORD
      fi
    else
      echo "That is not an integer, guess again:"
      read NUMBER
  fi

done

#PRINT THE CONGRATULATIONS MESSAGE
#NUMBER_OF_GUESSES=$($PSQL "SELECT COUNT(guesses) FROM games INNER JOIN users USING(user_id)  WHERE user_id=$USER_ID")
INSERTING_GUESSES=$($PSQL "INSERT INTO games(user_id, guesses) VALUES($USER_ID, $TRIES)")
echo "You guessed it in $TRIES tries. The secret number was $RANDOM_NUMBER. Nice job!"


#END OF WHILE