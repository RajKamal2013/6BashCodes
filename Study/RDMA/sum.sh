#! /bin/bash 

count=1;
thread=1
for ((i = 1; i <= 96; i = i + 24)) 
do 
	cat 4way.txt | sed -n "$i p"
	start=$((1 * ${count}));
	stop=$((24 * ${count}));
	#echo "<-----------thread -> ${thread} ---------->"
	#sed -n "${start},${stop}p" 4way.txt | awk 'BEGIN {sum = 0;}(($1=="'${thread}'")){sum += $2} (($1=="'${thread}'")){print $1"\t"$2"\t"sum}END{print "sum = " sum}'
	sed -n "${start},${stop}p" 4way.txt | awk 'BEGIN {sum = 0;}(($1=="'${thread}'")){sum += $2} END{print "Threads = " "'${thread}'""\t""iops = " sum}'
	thread=$((${thread} * 4))
	#echo "<-----------thread -> ${thread} ---------->"
	#sed -n "${start},${stop}p" 4way.txt | awk 'BEGIN {sum = 0;}(($1=="'${thread}'")){sum += $2} (($1=="'${thread}'")){print $1"\t"$2"\t"sum}END{print "sum = " sum}'
	sed -n "${start},${stop}p" 4way.txt | awk 'BEGIN {sum = 0;}(($1=="'${thread}'")){sum += $2} END{print "Threads = " "'${thread}'""\t""iops = " sum}'
	thread=$((${thread} * 2))
	#echo "<-----------thread -> ${thread} ---------->"
	#sed -n "${start},${stop}p" 4way.txt | awk 'BEGIN {sum = 0;}(($1=="'${thread}'")){sum += $2} (($1=="'${thread}'")){print $1"\t"$2"\t"sum}END{print "sum = " sum}'
	sed -n "${start},${stop}p" 4way.txt | awk 'BEGIN {sum = 0;}(($1=="'${thread}'")){sum += $2} END{print "Threads = " "'${thread}'""\t""iops = " sum}'
	thread=$((${thread} * 2))
	#echo "<-----------thread -> ${thread} ---------->"
	#sed -n "${start},${stop}p" 4way.txt | awk 'BEGIN {sum = 0;}(($1=="'${thread}'")){sum += $2} (($1=="'${thread}'")){print $1"\t"$2"\t"sum}END{print "sum = " sum}'
	sed -n "${start},${stop}p" 4way.txt | awk 'BEGIN {sum = 0;}(($1=="'${thread}'")){sum += $2} END{print "Threads = " "'${thread}'""\t""iops = " sum}'
	thread=$((${thread} * 2))
	#echo "<-----------thread -> ${thread} ---------->"
	#sed -n "${start},${stop}p" 4way.txt | awk 'BEGIN {sum = 0;}(($1=="'${thread}'")){sum += $2} (($1=="'${thread}'")){print $1"\t"$2"\t"sum}END{print "sum = " sum}'
	sed -n "${start},${stop}p" 4way.txt | awk 'BEGIN {sum = 0;}(($1=="'${thread}'")){sum += $2} END{print "Threads = " "'${thread}'""\t""iops = " sum}'
	count=1
	thread=1
done

