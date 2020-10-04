#! /bin/bash
request_bytes=("256", "8K", "1M")
ack_bytes=("256", "8K", "1M")
threads=("32")
queue_depth=("2", "4", "8", "16", "32")
duration=10
reciever_ip="11.11.11.95"
server_ip="11.11.11.96"

echo "RDS STRESS BCOPY"
for (i = 0; i < ${#request_bytes[@]}; i++)
do
	for (j = 0; j < ${#ack_bytes[@]}; j++)
	do
		for (k = 0; k < ${#threads[@]}; k++)
		do
			ssh 10.184.5.96 rds-stress &
			echo "Rds stress bcopy with request_ byte $i, ack_bytes $j, threads $k and duration $duration"
			rds-stress -r ${reciever_ip} -s ${server_ip} -q ${i} -a ${j} -t ${k} -T ${duration}
			ssh 10.184.5.96 rds-stress &
			ssh 10.184.5.96 pkill rds-stress 
		done
	done
done

#rds-stress -r 11.11.11.95 -s 11.11.11.96 -q 256 -a 8K -t 8 -T 16

# -p -> port number  
# -a -> ack_bytes
# -q -> request bytes
# -d -> queue depth  (depth of queue)
# -t -> nr_tasks (threads)
# -T -> duration 
# -r -> reciever (Client)
# -s -> sender (Server) 
