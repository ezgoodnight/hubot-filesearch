#!/bin/bash

#set variable to a basic locate search with hidden files removed
#uses locate because find is too slow for Slack adapter, probably
#too slow for chatops in most instances. Adapt it to whatever
#you choose to use if you care to.

SRCH=`locate "/home/" | fgrep -v "/."`

#loop in every item in the argument passed on to it
for i in $@; do
    #update the list variable to pare down to each item in argument
    SRCH=$(echo "$SRCH" | grep -i $i)
done

#print the results of the loop and all of the greps
#Also limits the number of items to 50. I want to encourage users to
#perform specific searches and not list 500 files at once.
echo "$SRCH" | head -n 50