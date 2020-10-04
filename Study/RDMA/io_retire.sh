#! /bin/bash 
cd /var/fm/fmd
/bin/rm -rf rsrc/* xprt/* ckpt/*
#disable io-retire  (no retire action will be taken)
#- edit /usr/lib/fm/fmd/plugins/io-retire.conf
#- change the below line, change prop value to "true"
#setprop global-disable false
gsed -i -e 's/false/true/1' /usr/lib/fm/fmd/plugins/io-retire.conf
fmadm reset io-retire
rm /etc/devices/retire_store
bootadm update-archive


