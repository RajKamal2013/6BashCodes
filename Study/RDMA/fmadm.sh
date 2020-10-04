#! /bin/bash

fmadm faulty > fmadm.txt
array=($(ggrep  -A 2 TIME  fmadm.txt | gsed -n '1~2p' | gawk '{print $4}' | gsed -n '2~2p'))
for (( i = 0; i < ${#array[@]}; i++)) do
        echo "Clearing fault ${array[i]}"
        fmadm acquit ${array[i]}
done
rm fmadm.txt
