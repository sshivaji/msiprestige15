#!/bin/bash

PRESTIGE_FOLDER=/home/$USER/msiprestige15

#OUTPUT=$(sensors | grep "Package id 0:" | cut -d " " -f 5 | cut -d "+" -f 2 | cut -d "." -f 1)
#OUTPUT=${OUTPUT%"°C"}
#echo "${OUTPUT}"
MODE=1
#0=quiet, 1=normal, 2=loud


counter=1
while [ $counter -le 10 ]
do
	OUTPUT=$(sensors | grep "Package id 0:" | cut -d " " -f 5 | cut -d "+" -f 2 | cut -d "." -f 1)
	OUTPUT=${OUTPUT%"°C"}
	if [ $OUTPUT -le 40 ] && [ $MODE -ne 0 ]
	then
		echo "T<40 and Mode=Not silent"
		sudo python3 $PRESTIGE_FOLDER/fan/control.py $PRESTIGE_FOLDER/fan/quiet.ini &
		MODE=0
		echo "*********************** Quiet mode activated"
	fi

	if [ $OUTPUT -ge 70 ] && [ $MODE -ne 3 ]
	then
		echo "T>70 and Mode=Not loud"
		sudo python3 $PRESTIGE_FOLDER/fan/control.py $PRESTIGE_FOLDER/fan/loud.ini &
		MODE=3
		echo "*********************** Loud mode activated"
	fi

	if [ $OUTPUT -ge 43 ] && [ $OUTPUT -le 67 ] && [ $MODE -ne 2 ]
	then
		echo "T>41 & T<69 and Mode=Not normal"
		sudo python3 $PRESTIGE_FOLDER/fan/control.py $PRESTIGE_FOLDER/fan/normal.ini &
		MODE=2
		echo "*********************** Normal mode activated"
	fi

	sleep 1s
	#echo $counter
	#((counter++))
done
