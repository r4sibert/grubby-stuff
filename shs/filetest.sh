#!/usr/bin/env bash

file="$1"

# test for command argument
[ -n "${1}" ] || { echo "No argument given..."; exit 1; }
# test to see if the file exists, make it if it does not. 
#[ -f "${1}" ] && { echo "file found."; } || { echo "making file..."; touch "${1}"; }

if [[ ! -f "${1}" ]]; then
    echo "Making $1"
    touch "${1}"
    exit 0
else
    echo "Already there."
    exit 0
fi

