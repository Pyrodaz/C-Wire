# C-Wire

This program analyses a data file to know if an electrical station is in a state of overconsumption by calculating the composants which are linked to this station. 
There is three type of stations : HV-B, HV-A, LV. 
HV-B stations provide electricity to companies that need a lot of electricity and to HV-A stations.
HV-A stations provide electricity to companies that need less electricity and to LV stations. 
LV stations provide electricity to individuals and small companies.
The arguments after "bash c-wire.sh" can only be 3 (or 4 if there is to analyse the stations of a specific power plant).

The arguments should be in this format :

bash c-wire.sh file.csv type_of_station_to_analyse consommation_of_composants_to_analyse (number_of_power_plant)

Examples :

bash c-wire.sh c-wire_v25.dat hvb comp 1
bash c-wire.sh c-wire_v00.csv lv all

Therefore there is only five formats acceptable (without taking in account the number of power plant) for the second and third argument
- hvb comp
- hva comp
- lv comp
- lv indiv
- lv all

These formats ARE NOT AVAILABLE :
- hvb indiv
- hvb all
- hva indiv
- hva all
