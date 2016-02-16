#!/bin/bash

for f in ../*
do 
	if [ -d "$f" ]&&[[ $f == *cal* ]] 
	then
		for fc in $f/t1/*tab.gz
		do
			rm *.tab
			fcname=$(basename $fc)
			dcname=${fcname:0:-7}
			cp $fc cdata.tab.gz
			gzip -d cdata.tab.gz
			sed -i '1,16d' cdata.tab
			echo $f/t1/$dcname/cdata.txt
			node collectl2Epoch.js > $f/t1/$dcname/cdata.txt 
		done
	fi
done
