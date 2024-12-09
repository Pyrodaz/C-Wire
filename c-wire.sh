#!/bin/bash

help=0

#check if there is -h arg in args to display help menu. Other option are invalidate 

for arg in $*; do 
	if [ "$arg" == "-h" ]; then 
		echo "-h OK"
		help=1
	fi
done

if [ $help -eq 0 ]; then
	if [ "$#" -ne 3 ] && [ "$#" -ne 4 ]; then 
		echo "bad number of arguments"
		help=1
	fi
fi

if [ $help -eq 0 ]; then
	#check first arg is a file
	if ! [ -f "$1" ]; then
		echo "'$1' is not a file"
		help=1 #Display help menu
	fi
fi

#check if next args are valid ; if one condition is wrong display help menu and don't check other conditions

if [ $help -eq 0 ]; then
	if [ "$2" != "hvb" ] && [ "$2" != "hva" ] && [ "$2" != "lv" ]; then
		echo "'$2' is not a valid argument"
		help=1
	fi
fi


if [ $help -eq 0 ]; then 
	if [ "$3" != "all" ] && [ "$3" != "indiv" ] && [ "$3" != "comp" ]; then
		echo "'$3 is not a valid argument"
		help=1
	fi
fi

if [ $help -eq 0 ]; then
	if [ "$2" == "hvb" ] || [ "$2" == "hva" ]; then
		if [ "$3" == "indiv" ] || [ "$3" == "all" ]; then
			echo "'$2 $3' is not a valid enter"
			help=1
		fi
	fi
fi

#help menu and error menu if error in args
if [ $help -eq 1 ]; then
	echo "HELP"
	#TO DO : write and put commands and explications to the help menu
	exit 1
fi


#Check if executable exist. TO CHANGE WHEN EXEC FILE NAME IS FIXED

exec_exist=0
files=`ls codeC`

for file in $files; do
	if [ $file == "exec" ]; then 
		exec_exist=1
	fi 
done	



#Remove and create tmp and graphs directories

rm -rf "tmp"
rm -rf "graphs"
mkdir "tmp"
mkdir "graphs"

#Set up the chronometer to mesure execution time of the program

SECONDS="0"

#Create file to display the consommation of hva,hvb or lv station 

case $# in 
	3) touch "$2_$3.csv"
		echo "$2_$3.csv";;
	4) touch "$2_$3_$4.csv"
		echo "$2_$3_$4.csv";;  
	*) ;;
esac 

#RETIRE IN FINAL VERSION
rm -f h*.csv
rm -f lv*.csv


#print program's execution time

echo $SECONDS






