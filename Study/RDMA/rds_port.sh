#! /bin/bash 
threads=(1 8 16 32);
rdma_bytes=(256 512 4K 8K);
TIME=(10);
START=0;
END=1;
CLIENT_IP="11.11.11.95";
SERVER_IP="11.11.11.96";
CLIENT_PATH="/root/rajkamal"
SERVER_PATH="/root/rajkamal"
PORT=(5000 5001 5002 5003 5004);

pkill rds-stress
ssh root@${SERVER_IP} "pkill rds-stress"

for p in "${PORT[@]}"; do
	rm ${CLIENT_PATH}/average_${p}.txt;
	ssh root@${SERVER_IP} "rm  ${SERVER_PATH}/average_${p}.txt";
done

for k in "${rdma_bytes[@]}"; do
	for p in "${PORT[@]}"; do
		SERVER_FILE="server_rdma_${k}_${p}.txt"
		CLIENT_FILE="client_rdma_${k}_${p}.txt"
		rm ${CLIENT_PATH}/${CLIENT_FILE};
		ssh root@${SERVER_IP} "rm  ${SERVER_PATH}/${SERVER_FILE}";
	done
done 

for (( a = $START; a < $END; a++))
do 
	for i in "${TIME[@]}"; do
		for j in "${threads[@]}"; do 
			for k in "${rdma_bytes[@]}"; do
				for p in "${PORT[@]}"; do
					SERVER_FILE="server_rdma_${k}_${p}.txt"
					ssh root@${SERVER_IP}  " nohup echo '<-------- rds-stress -r ${CLIENT_IP} -s ${SERVER_IP} -o -p ${p} -t ${j} -T ${i} -D ${k}-------------->' >> ${SERVER_PATH}/${SERVER_FILE}" &
					ssh root@${SERVER_IP}  "nohup rds-stress -p ${p}  >> ${SERVER_PATH}/${SERVER_FILE}" & 

				done
				for p in "${PORT[@]}"; do
					SERVER_FILE="server_rdma_${k}_${p}.txt"
					CLIENT_FILE="client_rdma_${k}_${p}.txt"
					sleep 6 
					echo "<-------- Running RDS_STRESS with ${j} threads, ${k} rdma bytes for ${i} times  and ${a} iteration on port $p-------------->" >> ${CLIENT_PATH}/${CLIENT_FILE};
					rds-stress -r ${CLIENT_IP} -s ${SERVER_IP} -o -p ${p} -t ${j} -T ${i} -D ${k} >> ${CLIENT_PATH}/${CLIENT_FILE} 
					sleep 6
					echo "<-------------------------------------------------------------------------------------------->" >> ${CLIENT_PATH}/${CLIENT_FILE} 
					ssh root@${SERVER_IP} " nohup echo '<-------------------------------------------------------------------------------------------->' >> ${SERVER_PATH}/${SERVER_FILE}" 
				done
			done
		done
	done
done

for p in "${PORT[@]}"; do
	AVERAGE_FILE="average_${p}.txt";
	ggrep -m 1 tsks client_rdma_8K_${p}.txt >> ${CLIENT_PATH}/${AVERAGE_FILE};
	ssh root@${SERVER_IP} "ggrep -m 1 tsks ${SERVER_PATH}/server_rdma_8K_${p}.txt >> ${SERVER_PATH}/${AVERAGE_FILE}";
	for j in "${rdma_bytes[@]}"; do 
		SERVER_FILE="server_rdma_${j}_${p}.txt";
		CLIENT_FILE="client_rdma_${j}_${p}.txt";
		echo "<----------------------------------RDMA BYTES ${j}---------------------------------->" >> ${CLIENT_PATH}/${AVERAGE_FILE}
		grep average ${CLIENT_PATH}/${CLIENT_FILE} >> ${CLIENT_PATH}/${AVERAGE_FILE}
		ssh root@${SERVER_IP} "echo '<----------------------------------RDMA BYTES ${j}---------------------------------->' >> ${SERVER_PATH}/${AVERAGE_FILE}";
		ssh root@${SERVER_IP} "grep average ${SERVER_PATH}/${SERVER_FILE} >> ${SERVER_PATH}/${AVERAGE_FILE}";
	done
done
#rds-stress -r ${CLIENT_IP}  -s ${SERVER_IP}  -o  -t 32 -T 10 -D 8K
