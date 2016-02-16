#!/bin/bash

rm *.png
cp ../$1_$3/t1/$1_file_$2.tab.gz cdata.tab.gz
gzip -d cdata.tab.gz
sed -i '1,16d' cdata.tab
node collectl2Epoch.js > cdata.txt
rm cdata.tab
cp ../$1_$3/t1/$1_file_$2.stats sdata.stats
sed -i '/This is ApacheBench/, /longest request/d' sdata.stats
node requestAnalysis.js > presdata.txt
head -n -2 presdata.txt > sdata.txt
