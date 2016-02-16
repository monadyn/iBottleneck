#!/bin/bash
rm *.tab
rm *.tab.gz

date > collectl_start_time
collectl -scmdn -i 0.1 -P -f $1 -oTm 
