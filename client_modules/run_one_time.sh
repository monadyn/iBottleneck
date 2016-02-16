#!/bin/bash

client_tool=../tools/ab

echo 'params<<<'
echo $#
echo $@
echo '>>>'

sdata_file=

rm *.tab
rm *.gz
mkdir $4

collectl_sh='generated_run_collectl.sh'
rm $collectl_sh

if [ $7 = 'localhost' ]; then
    echo 'collect localhost performance info...'
	collectl -scmdn -i 0.1 -R '100's -P -f $6 -oTm &
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
	sleep $3
fi


echo 'start run collectl...'
#chmod +x $collectl_sh
#./$collectl_sh &
#rm *tab.gz
#collectl -scmdn -i 0.1 -R 100s -P -f $(pwd) -oTm &

#sleep 3

###client run ab
echo 'start run ab...'
$client_tool -r -n $1 -c $2 $5 > $4/$6.stats
echo 'fi ab stress test...'


###collect info
if [ $7 = 'localhost' ]; then
	echo 'get localhost srv info...'
	cp $6*.tab $4/$6.tab
	tar -cvzf $6.tab.gz $6*.tab
	cp $6.tab.gz $4/$6.tab.gz
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
rm *.gz
####cp the collect info and ab data to node srv

###gen plot to intermediate ui
