#! /bin/bash
rm -rf files.txt
ps -elf | egrep "sparcv9/\qperf" | nawk -F ' ' '{print $4}' > files.txt
filename="files.txt"
while read -r line
do
	name=${line}
	echo ${name}
	kill -9 ${name}
	status=$(echo $?)	
	if [ ${status} -eq 0 ]
	then 
		echo "Killed the Qperf Process -> PID" ${name}
	fi
done < "$filename" 
rm -rf files.txt
