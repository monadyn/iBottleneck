#!/bin/bash

for f in ../*
do 
	if [ -d "$f" ]&&[[ $f == *cal* ]] 
	then
		for ff in $f/t1/*stats
		do 
			fname=$(basename $ff)
			dname=${fname:0:-6}
			mkdir $f/t1/$dname
			cp $ff sdata.stats
			sed -i '/This is ApacheBench/, /longest request/d' sdata.stats
			node requestAnalysis.js > presdata.txt
			head -n -2 presdata.txt > sdata.txt
			tail -n 2 presdata.txt > timerange.txt
			IFS='_' read -a array <<< "$dname"
			node genInputForPython.js ${array[2]}


			mv *inout*csv inout.txt
			mv *multiplicity*csv multiplicity.txt
			mv *responsetime*csv responsetime.txt

			sed -i "s/,/ /g" inout.txt
			sed -i "s/,/ /g" multiplicity.txt
			sed -i "s/,/ /g" responsetime.txt

			sed -i "1,1d" inout.txt
			sed -i "1,1d" multiplicity.txt
			sed -i "1,1d" responsetime.txt

			node shortTime.js inout.txt > inout_tmp.txt
			node shortTime.js multiplicity.txt > multiplicity_tmp.txt
			node shortTime.js responsetime.txt > responsetime_tmp.txt

			mv inout_tmp.txt $f/t1/$dname/inout.txt
			mv multiplicity_tmp.txt $f/t1/$dname/multiplicity.txt
			mv responsetime_tmp.txt $f/t1/$dname/responsetime.txt

			echo $ff
		done
		for fc in $f/t1/*tab.gz
		do
			rm *.tab
			fcname=$(basename $fc)
			dcname=${fcname:0:-7}
			cp $fc cdata.tab.gz
			gzip -d cdata.tab.gz
			sed -i '1,16d' cdata.tab
			node collectl2Epoch.js > $f/t1/$dcname/cdata.txt 
			echo $f/t1/$dcname/cdata.txt
		done
	fi
done
