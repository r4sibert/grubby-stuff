#!/usr/bin/env bash

# Takes input from the user and assigns it to variables

#echo ""
#echo "What is your first name?"
#read -r firstname
#echo "What is your last name?"
#read -r lastname
#echo ""
read -p "What is your first name? >> " firstname
read -p "What is your last name? >> " lastname
echo ""

# Opens a subshell, does the things.
# The output of the subshell is teed to
# two files. 

(
    date +%D\ @%T 
    echo "First Name: ${firstname}" 
    echo "Last Name: ${lastname}" 
) | tee output.txt backup.txt 

echo ""
