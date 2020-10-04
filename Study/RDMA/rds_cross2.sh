#! /bin/bash 
threads=(1 4 8 16 32);
rdma_bytes=(256 512 4K 8K);
TIME=(20);
START=0;
END=4;
CLIENT_IP1="11.11.11.96";
SERVER_IP1="11.11.11.95";
CLIENT_IP2="11.11.11.98";
SERVER_IP2="11.11.11.97";
CLIENT_PATH1="/root/rajkamal/3"
SERVER_PATH1="/root/rajkamal/3"
CLIENT_PATH2="/root/rajkamal/4"
SERVER_PATH2="/root/rajkamal/4"

PORT1=5002
PORT2=5003

pkill rds-stress
ssh root@${SERVER_IP1} "pkill rds-stress"

ssh root@${SERVER_IP1} "rm  -rf ${SERVER_PATH1}"
ssh root@${SERVER_IP2} "rm  -rf ${SERVER_PATH2}"
ssh root@${SERVER_IP1} "mkdir ${SERVER_PATH1}"
ssh root@${SERVER_IP2} "mkdir ${SERVER_PATH2}"

rm -rf ${CLIENT_PATH1};
rm -rf ${CLIENT_PATH2};

mkdir ${CLIENT_PATH1};
mkdir ${CLIENT_PATH2};


for k in "${rdma_bytes[@]}"; do
		SERVER_FILE="server_rdma_${k}_${PORT1}.txt"
		CLIENT_FILE="client_rdma_${k}_${PORT1}.txt"
		rm ${CLIENT_PATH1}/${CLIENT_FILE1};
		ssh root@${SERVER_IP1} "rm  ${SERVER_PATH1}/${SERVER_FILE1}";
		SERVER_FILE="server_rdma_${k}_${PORT2}.txt"
		CLIENT_FILE="client_rdma_${k}_${PORT2}.txt"
		rm ${CLIENT_PATH2}/${CLIENT_FILE2};
		ssh root@${SERVER_IP2} "rm  ${SERVER_PATH2}/${SERVER_FILE2}";
	done

for (( a = $START; a < $END; a++))
do 
	for i in "${TIME[@]}"; do
		for j in "${threads[@]}"; do 
			for k in "${rdma_bytes[@]}"; do
					SERVER_FILE="server_rdma_${k}_${PORT1}.txt"
					ssh root@${SERVER_IP1}  " nohup echo '<-------- rds-stress -r ${CLIENT_IP1} -s ${SERVER_IP1} -o -p ${PORT1} -t ${j} -T ${i} -D ${k}-------------->' >> ${SERVER_PATH1}/${SERVER_FILE}" &
					ssh root@${SERVER_IP1}  "nohup rds-stress -p ${PORT1}  >> ${SERVER_PATH1}/${SERVER_FILE}" & 

					SERVER_FILE="server_rdma_${k}_${PORT2}.txt"
					ssh root@${SERVER_IP2}  " nohup echo '<-------- rds-stress -r ${CLIENT_IP2} -s ${SERVER_IP2} -o -p ${PORT2} -t ${j} -T ${i} -D ${k}-------------->' >> ${SERVER_PATH2}/${SERVER_FILE}" &
					ssh root@${SERVER_IP2}  "nohup rds-stress -p ${PORT2}  >> ${SERVER_PATH2}/${SERVER_FILE}" & 
				
					CLIENT_FILE="client_rdma_${k}_${PORT1}.txt"
					sleep 6 
					echo "<-------- Running RDS_STRESS with ${j} threads, ${k} rdma bytes for ${i} times  and ${a} iteration on port ${PORT1}-------------->" >> ${CLIENT_PATH1}/${CLIENT_FILE};
					rds-stress -r ${CLIENT_IP1} -s ${SERVER_IP1} -o -p ${PORT1} -t ${j} -T ${i} -D ${k} >> ${CLIENT_PATH1}/${CLIENT_FILE} 
					sleep 6
					
					
					CLIENT_FILE="client_rdma_${k}_${PORT2}.txt"
					sleep 6 
					echo "<-------- Running RDS_STRESS with ${j} threads, ${k} rdma bytes for ${i} times  and ${a} iteration on port ${PORT2}-------------->" >> ${CLIENT_PATH2}/${CLIENT_FILE};
					rds-stress -r ${CLIENT_IP2} -s ${SERVER_IP2} -o -p ${PORT2} -t ${j} -T ${i} -D ${k} >> ${CLIENT_PATH2}/${CLIENT_FILE} 
					sleep 6
					
					SERVER_FILE="server_rdma_${k}_${PORT1}.txt"
                                        CLIENT_FILE="client_rdma_${k}_${PORT1}.txt
					echo "<-------------------------------------------------------------------------------------------->" >> ${CLIENT_PATH1}/${CLIENT_FILE} 
					ssh root@${SERVER_IP1} " nohup echo '<-------------------------------------------------------------------------------------------->' >> ${SERVER_PATH1}/${SERVER_FILE}" 

					SERVER_FILE="server_rdma_${k}_${PORT2}.txt"
                                        CLIENT_FILE="client_rdma_${k}_${PORT2}.txt
					echo "<-------------------------------------------------------------------------------------------->" >> ${CLIENT_PATH2}/${CLIENT_FILE} 
					ssh root@${SERVER_IP1} " nohup echo '<-------------------------------------------------------------------------------------------->' >> ${SERVER_PATH2}/${SERVER_FILE}" 

			done
		done
	done
done


AVERAGE_FILE="average_${PORT1}.txt";
ggrep -m 1 tsks client_rdma_8K_${p}.txt >> ${CLIENT_PATH1}/${AVERAGE_FILE};
ssh root@${SERVER_IP1} "ggrep -m 1 tsks ${SERVER_PATH1}/server_rdma_8K_${PORT1}.txt >> ${SERVER_PATH1}/${AVERAGE_FILE}";
for j in "${rdma_bytes[@]}"; do 
	SERVER_FILE="server_rdma_${j}_${PORT1}.txt";
	CLIENT_FILE="client_rdma_${j}_${PORT1}.txt";
	echo "<----------------------------------RDMA BYTES ${j}---------------------------------->" >> ${CLIENT_PATH1}/${AVERAGE_FILE}
	grep average ${CLIENT_PATH1}/${CLIENT_FILE} >> ${CLIENT_PATH1}/${AVERAGE_FILE}
	ssh root@${SERVER_IP1} "echo '<----------------------------------RDMA BYTES ${j}---------------------------------->' >> ${SERVER_PATH1}/${AVERAGE_FILE}";
	ssh root@${SERVER_IP1} "grep average ${SERVER_PATH1}/${SERVER_FILE} >> ${SERVER_PATH1}/${AVERAGE_FILE}";
done
AVERAGE_FILE="average_${PORT2}.txt";
ggrep -m 1 tsks client_rdma_8K_${p}.txt >> ${CLIENT_PATH2}/${AVERAGE_FILE};
ssh root@${SERVER_IP2} "ggrep -m 1 tsks ${SERVER_PATH2}/server_rdma_8K_${PORT2}.txt >> ${SERVER_PATH2}/${AVERAGE_FILE}";
for j in "${rdma_bytes[@]}"; do 
	SERVER_FILE="server_rdma_${j}_${PORT2}.txt";
	CLIENT_FILE="client_rdma_${j}_${PORT2}.txt";
	echo "<----------------------------------RDMA BYTES ${j}---------------------------------->" >> ${CLIENT_PATH2}/${AVERAGE_FILE}
	grep average ${CLIENT_PATH2}/${CLIENT_FILE} >> ${CLIENT_PATH2}/${AVERAGE_FILE}
	ssh root@${SERVER_IP2} "echo '<----------------------------------RDMA BYTES ${j}---------------------------------->' >> ${SERVER_PATH2}/${AVERAGE_FILE}";
	ssh root@${SERVER_IP2} "grep average ${SERVER_PATH2}/${SERVER_FILE} >> ${SERVER_PATH2}/${AVERAGE_FILE}";
done

#rds-stress -r ${CLIENT_IP}  -s ${SERVER_IP}  -o  -t 32 -T 10 -D 8K
#rds-stress -r ${CLIENT_IP}  -s ${SERVER_IP}  -o  -t 32 -T 10 -D 8K
