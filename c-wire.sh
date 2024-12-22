#!/bin/bash

help=0

#check if there is -h arg in args to display help menu. Other option are invalidate 

for arg in $*; do 
	if [ "$arg" == "-h" ]; then 
		echo "Displaying help"
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

#check if next args are valid ; if one condition is wrong it displays help menu and don't check other conditions

if [ $help -eq 0 ]; then
	#Check if the type of station is valid
	if [ "$2" != "hvb" ] && [ "$2" != "hva" ] && [ "$2" != "lv" ]; then
		echo "'$2' is not a valid argument"
		help=1
	fi
fi


if [ $help -eq 0 ]; then 
	#Check if the type of component is valid
	if [ "$3" != "all" ] && [ "$3" != "indiv" ] && [ "$3" != "comp" ]; then
		echo "'$3 is not a valid argument"
		help=1
	fi
fi

if [ $help -eq 0 ]; then
	#Check the coherence of the type of component and the type of station
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
	echo "HELP MENU"
	cat README.md
	echo "Program's execution time : 0 sec"
	exit 1
fi



#Remove and create new tmp and graphs directories. If they exist previously it clean them up.
if ! [ -d "input" ]; then
	mkdir input
fi
if ! [ -d "tests" ]; then
	mkdir tests
fi
if [ -d "tmp" ]; then
	rm -rf "tmp"
fi
if [ -d "graphs" ]; then
	rm -rf "graphs"
fi

mkdir tmp
mkdir graphs

main_exist=0
files=`ls codeC`
file_counter=0 #Count .c file to verify later if there is the right number of .o file and if compilation worked

for file in $files; do
	if [ $file == "main" ]; then 
		main_exist=1
	fi
	
	if [[ $file == *.c ]]; then 
		file_counter=$(($file_counter + 1))
	fi 
done	

if [ $main_exist -eq 0 ];then
	cd CodeC
	make
	#Update codeC directory to search the .o file and decrement the count to 0 if the compilation worked
	files_C_compiled=`ls codeC` 
	for file in $files_C_compiled; do 
		if [ $file == "*.o" ]; then 
			file_counter=$(($file_counter - 1))
		fi 
	done
	echo "$file_counter"
	if [ $file_counter -ne 0 ]; then
		echo "Compilation failed"
		exit 2
	fi
	cd ..
fi

cp "$1" "input/inputfile.csv"

#Set up the chronometer to mesure execution time of the program

SECONDS="0"

#Create file to display the global consumption of hva,hvb or lv station 



case $# in 
	3)	touch "tests/$2_$3.csv";;
	4)	touch "tests/$2_$3_$4.csv";;
	*) 	;;
esac 

#Creation of the file data_to_process.csv to sort data before processing it into C program

touch tmp/data_to_process.csv


case $2 in
	#For hva and hvb there is only the comp case
	hva)
		if [ $# -eq 4 ]; then
			#If there is a power plant selected we only take selected components and stations from this power plant
			cat $1 | tail -n+2 | grep -E "^$4;[^;]*;[0-9]+;-;" | cut -d ";" -f3,7,8 | sort -t';' -n -k3 | tr "-" "0" >> tmp/data_to_process.csv
			
		else
			cat $1 | tail -n+2 | grep -E "^[0-9]+;[^;]*;[0-9]+;-;" | cut -d ";" -f3,7,8 | sort -t';' -n -k3 | tr "-" "0" >> tmp/data_to_process.csv
			
		fi;;
 
	hvb)
		if [ $# -eq 4 ]; then
			cat $1 | tail -n+2 | grep -E "^$4;[0-9]+;-;-;" | cut -d ";" -f2,7,8 | sort -t';' -n -k3 | tr "-" "0" >> tmp/data_to_process.csv
			
		else
			cat $1 | tail -n+2 | grep -E "^[0-9]+;[0-9]+;-;-;" | cut -d ";" -f2,7,8 | sort -t';' -n -k3 | tr "-" "0" >> tmp/data_to_process.csv
			
		fi;;
		
	#For there is comp,indiv and all cases so there is a second switch case for the third argument
	lv)
		case $3 in 
			comp)
				if [ $# -eq 4 ]; then
					cat $1 | tail -n+2 | grep -E "^$4;-;[^;]*;[0-9]+;[^;]*;-;" | cut -d ";" -f4,7,8 | sort -t';' -n -k3 | tr "-" "0" >> tmp/data_to_process.csv
			
				else
					cat $1 | tail -n+2 | grep -E "^[0-9]+;-;[^;]*;[0-9]+;[^;]*;-;" | cut -d ";" -f4,7,8 | sort -t';' -n -k3 | tr "-" "0" >> tmp/data_to_process.csv
					
				fi;;
				
			indiv)
				if [ $# -eq 4 ]; then
					cat $1 | tail -n+2 | grep -E "^$4;-;[^;]*;[0-9]+;-;[^;]*;" | cut -d ";" -f4,7,8 | sort -t';' -n -k3 | tr "-" "0" >> tmp/data_to_process.csv
			
				else
					cat $1 | tail -n+2 | grep -E "^[0-9]+;-;[^;]*;[0-9]+;-;[^;]*;" | cut -d ";" -f4,7,8 | sort -t';' -n -k3 | tr "-" "0" >> tmp/data_to_process.csv
				
				fi ;;
			all)
				if [ $# -eq 4 ]; then
					cat $1 | tail -n+2 | grep -E "^$4;-;[^;]*;[0-9]+;" | cut -d ";" -f4,7,8 | sort -t';' -n -k3  | tr "-" "0" >> tmp/data_to_process.csv
			
				else
				
					cat $1 | tail -n+2 | grep -E "^[0-9]+;-;[^;]*;[0-9]+;" | cut -d ";" -f4,7,8 | sort -t';' -n -k3 | tr "-" "0" >> tmp/data_to_process.csv
					
				fi;;
		esac;; #End of lv case
	*);;
esac  

#Creation of data_process.csv (Explications below). chmod is used to write into the file later.

touch tmp/data_processed.csv
chmod 777 tmp/data_processed.csv



#Create the final file

: '
We Send sorted data in data_to_process.csv to C program to calculate global 
consumption of all components selected of the type of station selected
to write it along with the ID of the type of stations and their capacity
in a new csv file : data_processed.csv
'

#Checking compilation

cd codeC
chmod 777 main
datapath="tmp/data_to_process.csv"
./main "../$datapath" "../tmp/data_processed.csv"

cd ..

case $2 in

	hva)
		if [ $# -eq 4 ]; then
		
			echo "HV-A:Capacity:Load" > "tests/$2_$3_$4.csv"
			sort tmp/data_processed.csv -t':' -n -k2 >> "tests/$2_$3_$4.csv"
		
		else 
		
			echo "HV-A:Capacity:Load" > "tests/$2_$3.csv"
			sort tmp/data_processed.csv -t':' -n -k2 >> "tests/$2_$3.csv"
		
		fi;;
	
		
	hvb)
	
		if [ $# -eq 4 ]; then
		
			echo "HV-B:Capacity:Load" > "tests/$2_$3_$4.csv"
			sort tmp/data_processed.csv -t':' -n -k2 >> "tests/$2_$3_$4.csv"
		
		else 
	
			echo "HV-B:Capacity:Load" > "tests/$2_$3.csv"
			sort "tmp/data_processed.csv" -t':' -n -k2 >> "tests/$2_$3.csv"
		
		fi;;
		
	lv) 
		
		if [ $# -eq 4 ]; then
		
			echo "LV:Capacity:Load" > "tests/$2_$3_$4.csv"
			sort "tmp/data_processed.csv" -t':' -n -k2 >> "tests/$2_$3_$4.csv" 
			fileLV="$2_$3_$4" 
		
		else 
	
			echo "LV:Capacity:Load" > "tests/$2_$3.csv"
			sort "tmp/data_processed.csv" -t':' -n -k2 >> "tests/$2_$3.csv"
			fileLV="$2_$3" 


		fi

		if [ "$3" == "all" ]; then
			#In the case of lv all, we create a file minmax with the ten station with the least and the ten with the most consumption
			tail -n+2 "tests/$fileLV.csv" | sort -t':' -n -k3 > "tmp/sortload.csv"
			#Sortload is used to sort stations by consommation and sortdiff only takes the stations usefull to the file minmax
			head -n10 "tmp/sortload.csv" >> "tmp/sortdiff.csv"
			tail -n10 "tmp/sortload.csv" >> "tmp/sortdiff.csv"
			echo "LV:Capacity:Load:Energy Difference" > tests/"$fileLV"_minmax.csv
			awk -F: '{$4=$2-$3} {print $0}' OFS=: "tmp/sortdiff.csv" | sort -t':' -n -k4 >> tests/"$fileLV"_minmax.csv
			
			#Program to create a graph of the file lv_all_minmax.csv in the case of lv all option
			fileLVminmax="$fileLV"_minmax.csv
			
			cd tests
			gnuplot -persist <<-EOFMarker
				set xlabel "LV"
				set ylabel "Capacity/Load"
				set grid
				set datafile separator ":"
				set boxwidth 2.0
				set style data histogram
				set style fill solid
				set terminal png
				set output "../graphs/lvgraphs.png"
				plot "$fileLVminmax" using 1:2 with boxes linecolor rgb "#00FF00" title "Capacity", \
					 "$fileLVminmax" using 1:3 with boxes linecolor rgb "#FF0000" title "Load"
			EOFMarker
			

		fi;;

	*);;
esac 


#print program's execution time

echo "Program's execution time : $SECONDS sec"