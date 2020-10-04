#! /bin/bash 
threads=(1 8 16 32);
rdma_bytes=(8 256 512 4K 8K);
TIME=(10);
START=0;
END=1;
CLIENT_IP="11.11.11.95";
SERVER_IP="11.11.11.96";
CLIENT_PATH="/root/rajkamal"
SERVER_PATH="/root/rajkamal"
PORT=$1

echo "$1"



pkill rds-stress
ssh root@${SERVER_IP} "pkill rds-stress"

rm ${CLIENT_PATH}/average.txt;
ssh root@${SERVER_IP} "rm  ${SERVER_PATH}/average.txt";

for k in "${rdma_bytes[@]}"; do
	SERVER_FILE="server_rdma_${k}.txt"
	CLIENT_FILE="client_rdma_${k}.txt"
	rm ${CLIENT_PATH}/${CLIENT_FILE};
	ssh root@${SERVER_IP} "rm  ${SERVER_PATH}/${SERVER_FILE}";
done 

for (( a = $START; a < $END; a++))
do 
	for i in "${TIME[@]}"; do
		for j in "${threads[@]}"; do 
			for k in "${rdma_bytes[@]}"; do
				SERVER_FILE="server_rdma_${k}.txt"
				CLIENT_FILE="client_rdma_${k}.txt"
				echo "<-------- Running RDS_STRESS with ${j} threads, ${k} rdma bytes for ${i} times  and ${a} iteration-------------->" >> ${CLIENT_PATH}/${CLIENT_FILE};
				ssh root@${SERVER_IP}  " nohup echo '<-------- rds-stress -r ${CLIENT_IP} -s ${SERVER_IP} -o -t ${j} -T ${i} -D ${k}-------------->' >> ${SERVER_PATH}/${SERVER_FILE}" &
				ssh root@${SERVER_IP}  "nohup rds-stress >> ${SERVER_PATH}/${SERVER_FILE}" & 
				sleep 6 
				rds-stress -r ${CLIENT_IP} -s ${SERVER_IP} -o -t ${j} -T ${i} -D ${k} >> ${CLIENT_PATH}/${CLIENT_FILE}; 
				sleep 6
				echo "<-------------------------------------------------------------------------------------------->" >> ${CLIENT_PATH}/${CLIENT_FILE};
				ssh root@${SERVER_IP} " nohup echo '<-------------------------------------------------------------------------------------------->' >> ${SERVER_PATH}/${SERVER_FILE}" &
			done
		done
	done
done

ggrep -m 1 tsks client_rdma_8.txt >> ${CLIENT_PATH}/average.txt;
ssh root@${SERVER_IP} "ggrep -m 1 tsks ${SERVER_PATH}/server_rdma_8.txt >> ${SERVER_PATH}/average.txt";
for j in "${rdma_bytes[@]}"; do 
	SERVER_FILE="server_rdma_${j}.txt";
	CLIENT_FILE="client_rdma_${j}.txt";
	echo "<----------------------------------RDMA BYTES ${j}---------------------------------->" >> average.txt
	grep average ${CLIENT_PATH}/${CLIENT_FILE} >> average.txt
	ssh root@${SERVER_IP} "echo '<----------------------------------RDMA BYTES ${j}---------------------------------->' >> ${SERVER_PATH}/average.txt";
	ssh root@${SERVER_IP} "grep average ${SERVER_PATH}/${SERVER_FILE} >> ${SERVER_PATH}/average.txt";
done

	
	

#rds-stress -r ${CLIENT_IP}  -s ${SERVER_IP}  -o  -t 32 -T 10 -D 8K
