#! /bin/bash
ggrep -inr  "Error" t.txt | nawk -F ':' '{print $1}' > 1.txt
IFS=$'\n' read -d '' -r -a array < 1.txt
index=0
length=$(echo ${#array[*]})
	

ggrep "Error" t.txt | ggrep -o ": .*" | uniq > 1.txt
while read -r line 
do
	var=$(echo ${line/: /})
	file=$(echo ${var//" "/_})
	filename=$(echo $file."txt")
	touch $filename
done < 1.txt

ggrep "Error" t.txt | ggrep -o ": .*" > 1.txt
while read -r line 
do
        var=$(echo ${line/: /})
        file=$(echo ${var//" "/_})
        filename=$(echo $file."txt")
	((start_index=index))
	((end_index=index + 1))
	((index=index + 1))
	start=$(echo ${array[${start_index}]})
	last=$(echo ${array[${end_index}]})	
	cat t.txt | sed -n "${start},${last}p" >> ${filename}
done < 1.txt
	last=$(cat t.txt | wc -l)
	cat t.txt | sed -n "${start},${last}p" >> ${filename}

