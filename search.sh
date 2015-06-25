#!/bin/bash

#set variable to a basic locate search with hidden files removed
#uses locate because find is too slow for Slack adapter, probably
#too slow for chatops in most instances. Adapt it to whatever
#you choose to use if you care to. Note that this will have to have
#a correct path in search.coffee as well as be marked executable by
#the user your hubot runs as. (I use a non sudo user for the bot for security)

#set variable to a basic locate search with hidden files removed
#edit the egrep regular expression to remove areas you don't want users to look
#the last fgrep removes dotfiles and appledouble files Netatalk adds
SRCH=`locate "/home/" | egrep "location1|location2|location3" | fgrep -v "/."`
PLAC=(
        "/home"
        "/mnt"
        "/var"
        "/opt"
        "/edit to any locations you want to search"
        )

#loop in every item in the argument passed on to it
for i in $@; do
    #update the list variable to pare down to each item in argument
    SRCH=$(echo "$SRCH" | grep -i "$i")
done


#set $REMN to result of loop
REMN="$SRCH"


#print the results of the loop and all of the greps
#if Search is empty after loop
if [ -z "$SRCH" ]
then
        #simply return Can't find it
        echo "Can't find it."
else
        #otherwise, let's loop and check for all the places defined in $PLAC
        for i in "${PLAC[@]}"; do
                CHEK=$(echo "$SRCH" | grep "$i")
                if [ -z "$CHEK" ]; then
                        #Print locations where there's nothing
                        echo "Nothing in $i"
                        echo " "
                else
                        #Else print where there's something to find from the grep
                        echo "Inside $i"
                        echo ' '
                        echo "$SRCH" | grep "$i" | head -n 25
                        echo ' '
                        #Create a remainder by eliminating from the list in the loop
                        #this the original list with stuff eliminated by the end
                        REMN=$(echo "$REMN" | grep -v "$i")
                fi
        done


        #if remainder is empty
        if [ -z "$REMN" ]
        then
                #There's nothing
                echo "Nothing anywhere else."
        else
                #Other places not included in $PLAC
                echo "In other places"
                echo ' '
                # $REMN should be exactly what it needs to be by this point
                echo "$REMN" | head -n 25

        fi

fi
