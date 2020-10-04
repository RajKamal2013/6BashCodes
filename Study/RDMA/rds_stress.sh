#! /bin/bash 

#rds-stress -r 11.11.11.95 -s 11.11.11.98  -d 32 -t 32 -T 20 -D 8K 
echo "<------------------------------------------------------------------------------------------------------>"

echo "<-------------rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 256 -a 256 -t 32 -T 10--------------------->"
ssh root@10.184.5.98 rds-stress &
sleep 6
rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 256 -a 256 -t 32 -T 10  
sleep 6
ssh root@10.184.5.98 pkill rds-stress 

echo "<-------------rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 256 -a 8K -t 32 -T 10--------------------->"
ssh root@10.184.5.98 rds-stress &
sleep 6
rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 256 -a 256 -t 32 -T 10  
sleep 6
ssh root@10.184.5.98 pkill rds-stress 

echo "<-------------rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 256 -a 1M -t 32 -T 10--------------------->"
ssh root@10.184.5.98 rds-stress &
sleep 6
rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 256 -a 1M -t 32 -T 10  
sleep 6
ssh root@10.184.5.98 pkill rds-stress 

echo "<-------------rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 8K -a 256 -t 32 -T 10--------------------->"
ssh root@10.184.5.98 rds-stress &
sleep 6
rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 8K -a 256 -t 32 -T 10  
sleep 6
ssh root@10.184.5.98 pkill rds-stress 

echo "<-------------rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 8K -a 8K -t 32 -T 10 --------------------->"  
ssh root@10.184.5.98 rds-stress &
sleep 6
rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 8K -a 256 -t 32 -T 10  
sleep 6
ssh root@10.184.5.98 pkill rds-stress 

echo "<-------------rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 1M -a 1M -t 32 -T 10---------------------->"  
ssh root@10.184.5.98 rds-stress &
sleep 6
rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 8K -a 1M -t 32 -T 10  
sleep 6
ssh root@10.184.5.98 pkill rds-stress 

echo "<-------------rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 1M -a 256 -t 32 -T 10---------------------->"
ssh root@10.184.5.98 rds-stress &
sleep 6
rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 1M -a 256 -t 32 -T 10  
sleep 6
ssh root@10.184.5.98 pkill rds-stress 

echo "<-------------rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 1M -a 8K -t 32 -T 10----------------------->"  
ssh root@10.184.5.98 rds-stress &
sleep 6
rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 1M -a 256 -t 32 -T 10  
sleep 6
ssh root@10.184.5.98 pkill rds-stress 

echo "<-------------rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 1M -a 1M -t 32 -T 10---------------------->"  
ssh root@10.184.5.98 rds-stress &
sleep 6
rds-stress -r 11.11.11.95 -s 11.11.11.98   -q 1M -a 1M -t 32 -T 10  
sleep 6
ssh root@10.184.5.98 pkill rds-stress 

echo "<----------------------------------------------------------------------------------------------------->"
