#! /bin/bash

for i in $(seq $1)
do
	sleep 6
	echo "<-------------- MCKEY Client is responding in loop no ${i} ---------------------------->" 
	mckey -m 239.0.0.1 -c 127 -b 11.11.11.98 -s 
	echo "<-------------- ------------------------------------------------------------------------>"
done  
