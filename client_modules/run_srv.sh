#!/bin/bash

# time_range remote_user log_file_name work_path

echo 'params<<<'
echo $#
echo $@
echo '>>>'

work_path=$4
time_range=$1
remote_user=$2
log_file_name=$3


rm *.tab
rm *.gz
mkdir $workpath

collectl_sh='generated_run_collectl.sh'
rm $collectl_sh

if [ $2 = 'localhost' ]; then
    echo 'run collectl...'
	collectl -scmdn -i 0.1 -R "$time_range"s -P -f $3 -oTm 
else
	echo 'collect server performance info...'	
	echo >> $collectl_sh
	#echo mkdir ~/fizztest >> $collectl_sh
	echo mkdir /home/ec2-user/fizztest >> $collectl_sh
	echo cd fizztest >> $collectl_sh
	echo rm *tab.gz >> $collectl_sh
	echo 'collectl -scmdn -i 0.1 -R '$3's -P -f $(pwd) -oTm &' >> $collectl_sh
	#echo 'collectl -scmdn -i 0.1 -R '$3's -P -f $(pwd) -oTm' >> $collectl_sh

	#ssh $7 'bash -s' < $collectl_sh &
	echo ssh -i /home/hudson/Downloads/hudsonshan.pem $7 
	#ssh  -i /home/hudson/Downloads/hudsonshan.pem $7 < $collectl.sh &
	ssh -i /home/hudson/Downloads/hudsonshan.pem $7  'collectl -scmdn -i 0.1 -R '$3's -P -f $(pwd) -oTm'
	
fi


#echo 'start run collectl...'
#chmod +x $collectl_sh
#./$collectl_sh &
#sleep $1

###collect info
if [ $2 = 'localhost' ]; then
	echo 'get collectl info...'
	cp $3*.tab $4/$3.tab
	tar -cvzf $3.tab.gz $3*.tab
	cp $3.tab.gz $4/$3.tab.gz
else
	echo 'get collectl info from remote srv to client...'
	#mv	fizz*tab.gz $4/$6.tab.gz
	mv *tab.gz $4/$6.tab.gz
	#scp $7:/home/fizz/fizztest/*tab.gz $4/$6.tab.gz
	echo 'scp $7:/home/ec2-user/*tab $4/$6.tab.gz' > tmp
	scp  -i /home/hudson/Downloads/hudsonshan.pem  $7:/home/ec2-user/*tab $4/$6.tab.gz
fi

###clean
#rm *.tab
#rm *.gz

####cp the collect info and ab data to node srv

###gen plot to intermediate ui
