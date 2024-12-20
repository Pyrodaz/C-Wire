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

rm -f hv*.csv
rm -f lv*.csv

cp "$1" "input/inputfile.csv"

#Set up the chronometer to mesure execution time of the program



#Create file to display the consommation of hva,hvb or lv station 



case $# in 
	3)	touch "tests/$2_$3.csv"
		csv_result="$2_$3.csv"
		echo "$2_$3.csv";;
	4)	touch "tests/$2_$3_$4.csv"
		csv_result="$2_$3_$4.csv"
		echo "$2_$3_$4.csv";;  
	*) 	;;
esac 



touch tmp/data_to_process.csv


case $2 in
	#For hva and hvb there is only the comp case
	hva)
		if [ $# -eq 4 ]; then
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


touch tmp/data_processed.csv
chmod 777 tmp/data_processed.csv



#Create the final file
#SUPPLEMENTARY STEPS TO DO LATER WHEN C PROGRAM IS FINISHED Line 239

cd codeC
make 
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
			tail -n+2 "tests/$fileLV.csv" | sort -t':' -n -k3 > "tmp/sortload.csv"
			head -n10 "tmp/sortload.csv" >> "tmp/sortdiff.csv"
			tail -n10 "tmp/sortload.csv" >> "tmp/sortdiff.csv"
			echo "LV:Capacity:Load:Energy Difference" > tests/"$fileLV"_minmax.csv
			awk -F: '{$4=$2-$3} {print $0}' OFS=: "tmp/sortdiff.csv" | sort -t':' -n -k4 >> tests/"$fileLV"_minmax.csv
			
			#Bar graphic
				
			#	gnuplot -persist <<-EOFMarker
			#		gnuplot -persist <<-EOFMarker
			#		set xlabel "LV"
			#		set ylabel "Capacity/Load"
			#		set grid
			#		set datafile separator ";"
			#		set boxwidth 0.4
			#		set style data histogram
			#		set style fill solid
			#		plot "test.csv" using 1:2 with boxes linecolor rgb "#00FF00", \
			#			 "test.csv" using 1:3 with boxes linecolor rgb "#FF0000"
			#	EOFMarker
			

		fi;;

	*);;
esac 


#print program's execution time

echo "Program's execution time : $SECONDS sec"