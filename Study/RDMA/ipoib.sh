#! /bin/bash

dladm show-phys
dladm show-link
dladm show-ib
dladm show-part
ipadm delete-ip ibp60
dladm delete-part ibp60
dladm create-part -l net1 -P FFFF ibp60
ipadm create-ip ibp60
ipadm create-addr -T static -a 11.11.11.95/24 ibp60
dladm show-part
ipadm show-addr
cat /dev/null > /var/adm/messages
svcadm enable rds
