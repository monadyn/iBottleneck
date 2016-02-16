#!/bin/bash

for f in ../*
do 
	if [ -d "$f" ]&&[[ $f == *cal* ]] 
	then
		for fl in $f/t1/*stats
		do 
			flname=$(basename $fl)
			dlname=${flname:0:-6}
			echo $f/t1/$dlname/inout_longReq.txt
			cp $fl sdata.stats
			sed -i '/This is ApacheBench/, /longest request/d' sdata.stats
			node requestAnalysis.js > presdata.txt
			head -n -2 presdata.txt > sdata.txt
			tail -n 2 presdata.txt > timerange.txt
			IFS='_' read -a array0 <<< "$dlname"
			node genInputForPythonLongReq.js ${array0[2]}
			echo 'ok'


			mv *client*inout*longReq.csv inout.txt
			mv *client*responsetime*longReq.csv responsetime.txt


		done
	fi
done
