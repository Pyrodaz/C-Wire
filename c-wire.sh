#!/bin/bash

#check first arg is a file
if ! [ -f "$1" ]; then
	echo "'$1' is not a file"
	#display help -h
	exit 1
fi

#check if next args are valid
if [ "$2" != "hvb" ] && [ "$2" != "hva" ] && [ "$2" != "lv" ]; then
	echo "'$2' is not a valid argument"
	#display help -h
	exit 1
fi

if [ "$3" != "all" ] && [ "$3" != "indiv" ] && [ "$3" != "comp" ]; then
	echo "'$3 is not a valid argument"
	#display help -h
	exit 1
fi

if [ "$2" == "hvb" ] || [ "$2" == "hva" ]; then
	if [ "$3" == "indiv" ] || [ "$3" == "all" ]; then
		echo "'$2 $3' is not a valid enter"
		#display help -h
		exit 1
	fi
fi

if [ -d "tmp" ] 
