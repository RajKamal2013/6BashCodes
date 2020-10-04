#!/bin/bash 

START=4000
END=4002

for ((PORT = $START; PORT <=  $END; PORT++)); do 
	echo "Running RDS STRESS on port ${PORT}";
	./rds_port.sh ${PORT}  
done
