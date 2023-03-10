#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=number_guess --tuples-only -c"

echo -e "\n~~~~~ Number guess ~~~~~\n"
 
echo -e "\nEnter your username:"      
read USER_NAME
USERNAME=$($PSQL "SELECT usernames FROM users WHERE usernames = '$USER_NAME'")
GAMES_PLAYED=$($PSQL "SELECT COUNT(number_guesses) FROM games INNER JOIN users USING(user_id) WHERE usernames='$USER_NAME'")
BEST_GAME=$($PSQL "SELECT MIN(number_guesses) FROM games INNER JOIN users USING(user_id) WHERE usernames='$USER_NAME'")
  if [[ -z $USERNAME ]]
    then
      INSERT_USER_RESULT=$($PSQL "INSERT INTO users(usernames) VALUES('$USER_NAME')")
      echo "Welcome, $USER_NAME! It looks like this is your first time here." 
  else
    echo -e "Welcome back, $USER_NAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GAME guesses."
  fi


SECRET_NUMBER=$(( $RANDOM % 1000 + 1 ))
GUESS=1
echo -e "\nGuess the secret number between 1 and 1000:"
  while read NUMBER
    do
      if [[ ! $NUMBER =~ ^[0-9]+$ ]]
        then
          echo "That is not an integer, guess again:"
      else
      if [[ $NUMBER -eq $SECRET_NUMBER ]]
          then 
            break;
      else
        if [[ $NUMBER -lt $SECRET_NUMBER ]]
          then 
            echo  "It's lower than that, guess again:"
        elif [[ $NUMBER -gt $SECRET_NUMBER ]]
          then 
            echo  "It's higher than that, guess again:"
        fi
      fi
      fi
    GUESS=$(( $GUESS + 1 ))
    done

  if [[ $GUESS == 1 ]]
    then
      echo -e "You guessed it in $GUESS tries. The secret number was $SECRET_NUMBER. Nice job!"        
    else
      echo -e "You guessed it in $GUESS tries. The secret number was $SECRET_NUMBER. Nice job!"
  fi

  USER_ID=$($PSQL "SELECT user_id FROM users WHERE usernames = '$USER_NAME'")
  INSERT_GAME=$($PSQL "INSERT INTO games(number_guesses,user_id) VALUES($GUESS,$USER_ID)")  