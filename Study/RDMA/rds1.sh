#! /bin/bash 
threads=(1 8 16 32);
rdma_bytes=(8B 256B 512B 4K 8K);
TIME=(10);
CLIENT_IP="11.11.11.95";
SERVER_IP="11.11.11.96";
START=0;
END=1;

pkill rds-stress
ssh root@${SERVER_IP} "pkill rds-stress"

for k in "${rdma_bytes[@]}"; do
	SERVER_FILE="server_rdma_${k}.txt"
	CLIENT_FILE="client_rdma_${k}.txt"
	rm /root/rajkamal/${CLIENT_FILE};
	ssh root@${SERVER_IP} "rm /root/rajkamal/${SERVER_FILE}";
done 

for (( a = $START; a < $END; a++))
do 
	for i in "${TIME[@]}"; do
		for j in "${threads[@]}"; do 
			for k in "${rdma_bytes[@]}"; do
				SERVER_FILE="server_rdma_${k}.txt"
				CLIENT_FILE="client_rdma_${k}.txt"
				echo "<-------- Running RDS_STRESS with ${j} threads, ${k} rdma bytes for ${i} times  and ${a} iteration-------------->" >> /root/rajkamal/${CLIENT_FILE};
				ssh root@${SERVER_IP}  " nohup echo '<-------- rds-stress -r ${CLIENT_IP} -s ${SERVER_IP} -o -t ${j} -T ${i} -D ${k}-------------->' >> /root/rajkamal/${SERVER_FILE}" &
				ssh root@${SERVER_IP}  "nohup rds-stress >> /root/rajkamal/${SERVER_FILE}" & 
				sleep 6 
				rds-stress -r ${CLIENT_IP} -s ${SERVER_IP} -o -t ${j} -T ${i} -D ${k} >> /root/rajkamal/${CLIENT_FILE}; 
				sleep 6
				echo "<-------------------------------------------------------------------------------------------->" >> /root/rajkamal/${CLIENT_FILE};
				ssh root@${SERVER_IP} " nohup echo '<-------------------------------------------------------------------------------------------->' >> /root/rajkamal/${SERVER_FILE}" &
			done
		done
	done
done

#rds-stress -r ${CLIENT_IP}  -s ${SERVER_IP}  -o  -t 32 -T 10 -D 8K
