#!/bin/bash
SECONDS="0"
help=0

#check if there is -h arg in args to display help menu. Other option are invalidate 

for arg in $*; do 
	if [ "$arg" == "-h" ]; then 
		echo "-h OK"
		help=1
	fi
done


#Check number of arguments 

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

echo "Number of arguments : $#"


#If the number of central is specified, check if it is valid (so between 1 and 5 included)

if [ $help -eq 0 ] && [ $# -eq 4 ]; then 
	case $4 in
		1);;
		2);;
		3);;
		4);;
		5);;
		*) 	echo "$4 is an invalid number : it isn't between 1 and 5 included"
			help=1 ;;
	esac
fi	


#help menu and error menu if error in args
if [ $help -eq 1 ]; then
	echo "HELP"
	#TO DO : write and put commands and explications to the help menu
	echo "Program's execution time : 0 sec"
	exit 1
fi



#Remove and create new tmp and graphs directories. If they exist previously it clean them up.

rm -rf "tmp"
rm -rf "graphs"
mkdir "tmp"
mkdir "graphs"
rm -f hv*.csv
rm -f lv*.csv

#Set up the chronometer to mesure execution time of the program



#Create file to display the consommation of hva,hvb or lv station 



case $# in 
	3)	touch "$2_$3.csv"
		csv_result="$2_$3.csv"
		echo "$2_$3.csv";;
	4)	touch "$2_$3_$4.csv"
		csv_result="$2_$3_$4.csv"
		echo "$2_$3_$4.csv";;  
	*) 	;;
esac 



touch tmp/data_to_process.csv


case $2 in
	#For hva and hvb there is only the comp case
	hva)
		cat $1 | tail -n+2 | grep -E "^[0-9]+;[0-9]+;[0-9]+;-;" | cut -d ";" -f3,7,8 | tr "-" "0" >> tmp/data_to_process.csv;;
 
	hvb)
		cat $1 | tail -n+2 | grep -E "^[0-9]+;[0-9]+;-;-;" | cut -d ";" -f2,7,8 | tr "-" "0" >> tmp/data_to_process.csv;;

		
	#For there is comp,indiv and all cases so there is a second switch case for the third argument
	lv)
		case $3 in 
			comp)
				cat $1 | tail -n+2 | grep -E "^[0-9]+;-;-;[0-9]+;[0-9]+;-;" | cut -d ";" -f4,7,8 | tr "-" "0" >> tmp/data_to_process.csv;;
			indiv)
				cat $1 | tail -n+2 | grep -E "^[0-9]+;-;-;[0-9]+;-;[0-9]+;" | cut -d ";" -f4,7,8 | tr "-" "0" >> tmp/data_to_process.csv;;
			all)
				 cat $1 | tail -n+2 | grep -E "^[0-9]+;-;[^;]*;[0-9]+;" | cut -d ";" -f4,7,8 | sort -t';' -n -k2 | tr "-" "0" >> tmp/data_to_process.csv;; 
		esac;; #End of lv case
	*);;
esac  

datapath="tmp/data_to_process.csv"



#Add the id and capacity of each HVA, HVB or LV into the result file. TO MOVE EVENTUALLY TO A TMP FILE !!





cd codeC
gcc -o main CreationArbreAVL.c 
./main "../$datapath" "$2_$3.csv"





#print program's execution time

echo "Program's execution time : $SECONDS sec"






