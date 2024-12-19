#!/bin/bash

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


#Check if executable exist. TO CHANGE WHEN EXEC FILE NAME IS FIXED

exec_exist=0
files_C=`ls codeC`
file_counter=0 #Count .c file to verify later if there is the right number of .o file and if compilation worked

for file in $files_C; do
	if [ $file == "exec" ]; then 
		exec_exist=1
	fi
	
	if [[ $file == *.c ]]; then 
		file_counter=$(($file_counter + 1))
	fi 
done	

if [ $exec_exist -eq 0 ]; then
	cd codeC/ #Go to codeC directory to compilate
	make
	cd .. #Return to root of program
fi

#Update codeC directory to search the .o files and decrement the count until it reach 0 if the compilation worked. If the count is not equal 0, the compilation has failed so we exit the program
files_C_compiled=`ls codeC` 

#ADD FILE O IF NEW FILE C ARE ADDED
for file in $files_C_compiled; do 

	if [ $file == "test.o" ] || [ $file == "test2.o" ]; then 
		file_counter=$(($file_counter - 1))
	fi 
done

echo "$file_counter"


if [ $file_counter -ne 0 ]; then
	echo "Compilation failed"
	echo "Program's execution time : 0 sec"
	exit 2
fi

#Remove and create new tmp and graphs directories. If they exist previously it clean them up.

rm -rf "tmp"
rm -rf "graphs"
mkdir "tmp"
mkdir "graphs"

#Set up the chronometer to mesure execution time of the program

SECONDS="0"

#Create file to display the consommation of hva,hvb or lv station 



case $# in 
	3)	touch "$2_$3.csv"
		csv_result="$2_$3.csv"
		echo "$2_$3.csv";;
	4)	touch "$2_$3_$4.csv"
		csv_result="$2_$3.csv"
		echo "$2_$3_$4.csv";;  
	*) 	;;
esac 

#RETIRE IN FINAL VERSION
rm -f h*.csv
rm -f lv*.csv

touch tmp/data_to_process.csv

list=`cat $1 | tail -n+2`

case $2 in
	#For hva and hvb there is only the comp case
	hva)
		echo `cat $1 | head -1 | cut -d ';' -f3,5,8` > tmp/data_to_process.csv #ERASE 5 
 
		for line in $list ; do
			id_HVA=`echo "$line" | cut -d ';' -f3`
			id_comp=`echo "$line" | cut -d ';' -f5` #TO ERASE
			load=`echo "$line" | cut -d ';' -f8`
			
			if [ $id_HVA != "-" ] && [ $id_comp != "-" ]; then
			
				echo "$id_HVA;$id_comp;$load" >> tmp/data_to_process.csv #ERASE id_comp 
				
			fi
		done;;
	hvb)
		echo `cat $1 | head -1 | cut -d ';' -f2,5,8` > tmp/data_to_process.csv #ERASE 5 

		for line in $list ; do
			id_HVB=`echo "$line" | cut -d ';' -f2`
			id_comp=`echo "$line" | cut -d ';' -f5` #TO ERASE
			load=`echo "$line" | cut -d ';' -f8`
			
			if [ $id_HVB != "-" ] && [ $id_comp != "-" ]; then
			
				echo "$id_HVB;$id_comp;$load" >> tmp/data_to_process.csv #ERASE id_comp 
				
			fi
		done;;
		
	#For there is comp,indiv and all cases so there is a second switch case for the third argument
	lv)
		case $3 in 
			comp)
				echo `cat $1 | head -1 | cut -d ';' -f4,5,8` > tmp/data_to_process.csv #ERASE 5 

				for line in $list ; do
					id_LV=`echo "$line" | cut -d ';' -f4`
					id_comp=`echo "$line" | cut -d ';' -f5` #TO ERASE
					load=`echo "$line" | cut -d ';' -f8`
			
					if [ $id_LV != "-" ] && [ $id_comp != "-" ]; then
			
						echo "$id_LV;$id_comp;$load" >> tmp/data_to_process.csv #ERASE id_comp 
				
					fi
				done;;
			indiv)
				echo `cat $1 | head -1 | cut -d ';' -f4,6,8` > tmp/data_to_process.csv #ERASE 5 

				for line in $list ; do
					id_LV=`echo "$line" | cut -d ';' -f4`
					id_indiv=`echo "$line" | cut -d ';' -f6` #TO ERASE
					load=`echo "$line" | cut -d ';' -f8`
			
					if [ $id_LV != "-" ] && [ $id_indiv != "-" ]; then
			
						echo "$id_LV;$id_indiv;$load" >> tmp/data_to_process.csv #ERASE id_indiv
				
					fi
				done;;
			
			all)
				echo `cat $1 | head -1 | cut -d ';' -f4,5,6,8` > tmp/data_to_process.csv #ERASE 5 6

				for line in $list ; do
					id_LV=`echo "$line" | cut -d ';' -f4`
					id_comp=`echo "$line" | cut -d ';' -f5` #TO ERASE
					id_indiv=`echo "$line" | cut -d ';' -f6` #TO ERASE
					load=`echo "$line" | cut -d ';' -f8`
			
					if [ $id_LV != "-" ] && [ $load != "-" ]; then
			
						echo "$id_LV;$id_comp;$id_indiv;$load" >> tmp/data_to_process.csv  #ERASE id_comp id_indiv
				
					fi
				done;; #End of all case
			*);;
		esac;; #End of lv case
	*);;
esac  





#Add the id and capacity of each HVA, HVB or LV into the result file. TO MOVE EVENTUALLY TO A TMP FILE !!




case $2 in

	hva)
		echo `cat $1 | head -1 | cut -d ';' -f3,7` > tmp/result.csv

		for line in $list ; do
			id_HVB=`echo "$line" | cut -d ';' -f2`
			id_HVA=`echo "$line" | cut -d ';' -f3`
			capacity=`echo "$line" | cut -d ';' -f7`
			
			if [ $id_HVB != "-" ] && [ $id_HVA != "-" ]; then
			
				echo "$id_HVA;$capacity" >> tmp/result.csv
				
			fi
		done;;
	hvb)
		echo `cat $1 | head -1 | cut -d ';' -f2,7` > tmp/result.csv

		for line in $list ; do
			id_HVB=`echo "$line" | cut -d ';' -f2`
			id_HVA=`echo "$line" | cut -d ';' -f3`
			capacity=`echo "$line" | cut -d ';' -f7`
			
			if [ $id_HVB != "-" ] && [ $id_HVA == "-" ] && [ $capacity != "-" ]; then
			
				echo "$id_HVB;$capacity" >> tmp/result.csv
				
			fi
		done;;
	lv)
		echo `cat $1 | head -1 | cut -d ';' -f4,7` > tmp/result.csv

		for line in $list ; do
			id_LV=`echo "$line" | cut -d ';' -f4`
			capacity=`echo "$line" | cut -d ';' -f7`
			
			if [ $id_LV != "-" ] && [ $capacity != "-" ]; then
			
				echo "$id_LV;$capacity" >> tmp/result.csv
				
			fi
		done;;
	*);;

esac 


#print program's execution time

echo "Program's execution time : $SECONDS sec"






