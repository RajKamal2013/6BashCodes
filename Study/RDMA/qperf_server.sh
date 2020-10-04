#! /bin/bash 
var=19765
for i in $(seq "$1")
do
	port=$((${var} + ${i}))
	/usr/bin/sparcv9/qperf -lp ${port} &
done
echo "Ports Running the Qperf"
ps -e | grep qperf | nawk -F ' ' '{print $1}' > pid.txt 

filename="pid.txt"
count=0
while read -r line
do
    	name=$line
    	result=$(pfiles ${name} 2<&1 2<&1 | ggrep "AF_INET 0.0.0.0" | ggrep "port: $PORTNUM" 2<&1)
	status=$(echo $?)
	if [ $status -eq 0 ]
	then 
		echo "QPERF " ${result}
	fi
done < "$filename"

