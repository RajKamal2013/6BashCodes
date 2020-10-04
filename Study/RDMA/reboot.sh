#! /bin/bash

prefix=('65' '66' '70' '68' '69')

echo "<-------------------------------------------------------------------->"
echo "Count of Ldoms-->${#prefix[@]}"
 
for ((i = 0; i < ${#prefix[@]}; i++)) 
do 
server=10.184.5.${prefix[${i}]}
echo "Ldoms ${i} --> ${server}"
done 
echo "<-------------------------------------------------------------------->"
count=0

#for ((k = 0; k < 1; k++))do  
while true; do 
count=$((count + 1))
echo "<-----------------------------Reboot Count ${count}--------------------------->"
echo "<-----------------------Date------------------------------------->:"
date
for ((i = 0; i < ${#prefix[@]}; i++)) 
do 
RESULT=0;
server=10.184.5.${prefix[${i}]}
ssh -o ConnectTimeout=10  root@${server} 'ibstat' > /dev/null 2>&1 
RESULT=$?
#echo "<---------------Reboot-------------------------------->"
ssh -o ConnectTimeout=10  root@${server} 'reboot' > /dev/null 2>&1
if [ $RESULT == 0 ]; then
	echo "Still not produced"
fi
if [ $RESULT != 0 ]; then 
echo "<-----------------------------Reboot Count ${count}--------------------------->" >> /root/EPSC/ldm${i}.log
/root/EPSC/sif/bin/./setsif -d psif31 -r 0x3009c9  >> /root/EPSC/dump${i}.log
/root/EPSC/sif/bin/./setsif -d psif31 -r 0x3009ca  >> /root/EPSC/dump${i}.log
/root/EPSC/sif/bin/./setsif -d psif31 -r 0x3009cb  >> /root/EPSC/dump${i}.log
/root/EPSC/sif/bin/./setsif -d psif31 -r 0x3009cc  >> /root/EPSC/dump${i}.log
/root/EPSC/sif/bin/./epsc_cli -d psif31 -c "show eps qp  4-48 uf" >> /root/EPSC/dump${i}.log
echo "<------------------------------Reboot :- killing the script ------------------------->"
exit 1
fi

echo "<-----------------------------Reboot Count ${count}--------------------------->" >> /root/EPSC/ldm${i}.log
/root/EPSC/sif/bin/./epsc_cli -d psif31 -c "show eps log" >> /root/EPSC/ldm${i}.log
echo "<---------------Rebooted  -> ${server}----------------------------->"
done 

sleep 65

for ((i = 0; i < ${#prefix[@]}; i++)) 
do 
server=10.184.5.${prefix[i]}
echo "<---------------Restarted -> ${server}, running ibstat----------------->>"
ssh -o ConnectTimeout=10  root@${server} 'ibstat' | ggrep -A 2 Port
RESULT=$?
if [ $RESULT == 0 ]; then
	echo "Still not produced"
fi

if [ $RESULT != 0 ]; then 
echo "<-----------------------------Reboot Count ${count}--------------------------->" >> /root/EPSC/ldm${i}.log
/root/EPSC/sif/bin/./setsif -d psif31 -r 0x3009c9  >> /root/EPSC/dump${i}.log
/root/EPSC/sif/bin/./setsif -d psif31 -r 0x3009ca  >> /root/EPSC/dump${i}.log
/root/EPSC/sif/bin/./setsif -d psif31 -r 0x3009cb  >> /root/EPSC/dump${i}.log
/root/EPSC/sif/bin/./setsif -d psif31 -r 0x3009cc  >> /root/EPSC/dump${i}.log
/root/EPSC/sif/bin/./epsc_cli -d psif31 -c "show eps qp  4-48 uf" >> /root/EPSC/dump${i}.log
echo "<------------------------------Ibstat -> killing the script ------------------------->"
fi
done
echo "<-----------------------Date------------------------------------->:"
date
done 
#fi
