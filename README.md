# C-Wire

This program analyses a data file to know if an electrical station is in a state of overconsumption by calculating the composants which are linked to this station. 
There is three type of stations : HV-B, HV-A, LV.  <br>
HV-B stations provide electricity to companies that need a lot of electricity and to HV-A stations. <br>
HV-A stations provide electricity to companies that need less electricity and to LV stations. <br>
LV stations provide electricity to individuals and small companies. <br>
The arguments after "bash c-wire.sh" can only be 3 (or 4 if there is to analyse the stations of a specific power plant). <br>
The 4th argument with the powerplant is optional.

**The arguments should be in this format** :

bash   c-wire.sh   filepath.csv   type_of_station_to_analyse  composants_to_analyse  (number_of_power_plant)

Examples : <br>
bash c-wire.sh input/c-wire_v25.dat hvb comp 1 <br>
bash c-wire.sh c-wire_v00.csv lv all 

Therefore there is **only five formats acceptable** (without taking in account the number of power plant) for the second and third arguments (The average duration of the program execution of each format is indicated next to the format) :
- hvb comp : 1 second
- hva comp : 11-26 seconds
- lv comp : 15-30 seconds
- lv indiv : 30-50 seconds
- lv all : 30-50 seconds (display a graphs in the graph directory with the ten station with the least and the ten with the most consumption) <br>

These formats **ARE NOT AVAILABLE** :
- hvb indiv
- hvb all
- hva indiv
- hva all


