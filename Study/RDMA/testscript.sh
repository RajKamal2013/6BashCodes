#!/bin/bash
for i in {1..1000000} 
do
	/usr/bin/sparcv9/ibv_ud_pingpong &
	/usr/bin/sparcv9/ibv_ud_pingpong localhost
done
