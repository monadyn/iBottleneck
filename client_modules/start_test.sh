#!/bin/bash

#app | total requests | concurrent request | duration | output folder | url | prefix

rm -rf t1
rm -rf forplot

#echo $#
echo $@
#echo $srv

for i in "$@"
do
case $i in
    -n=*|--name=*)
	TESTNAME="${i#*=}"

	;;
	-u=*|--url=*)
	URL="${i#*=}"
    ;;

	-c=*|--con=*)
	CON="${i#*=}"
	;;
	
	--default)
	DEFAULT=YES
	;;
	*)
	
	# unknown option
	;;
esac
done

#echo ${TESTNAME}
#TESTNAME=${TESTNAME}
#echo SEARCH PATH = ${SEARCHPATH}
#echo DIRS = ${DIR}
#Usage   myscript.sh -p=my_prefix -s=dirname -l=libname


if [[ $1 = "local" ]]; then
	echo 'localhost...'
	remote_srv="localhost"
	#URL=http://127.0.0.1:3000/
else
	echo 'remotesrv...'
	remote_srv=ec2-user@52.89.222.119
	#URL=http://52.89.222.111:3000/
fi

if [ $2 = "." ]; then
	echo 'pwd...'
	bat_root=.
else
	bat_root=$2
fi

#workloca
if [ $3 = "" ]; then
	total=10000
else
	total=$3
fi



exefile=$bat_root/generated_batch_running.sh
one_run_sh=$bat_root/run_one_time.sh
stat_script=$bat_root/do_stat.sh
run_client=$bat_root/run_client.sh
run_srv=$bat_root/run_server.sh #run_srv.sh
#fizz@192.168.10.23
#its=(111 100 200 400 800 1600 3200)
its=(100)

time=100  #collectl range 100s

echo '#!/bin/sh' > $exefile
for it in "${its[@]}" 
do
	#$it is $CON
	echo $one_run_sh $total $CON $time t1 $URL ${TESTNAME}_$CON $remote_srv >> $exefile
	echo  >> $exefile
done


rm -rf t1
rm -rf forplot
mkdir t1 
mkdir forplot

log_file_name=${TESTNAME}_${CON}
echo log file name is  $log_file_name

#$run_srv $time $remote_srv $log_file_name t1 &
$run_srv $log_file_name &
srv_pid=$!
echo srv pid is $srv_pid


sleep 5
$run_client $total $CON $URL $log_file_name t1 
#chmod +x $exefile
#echo 'start running one test...'
#./$exefile
#echo 'finish running one test...'

sleep 3 #$time  #wait srv fi
#kill srv process
kill $srv_pid

#cp srv data
cp *$CON*.tab t1/${log_file_name}.tab
tar -cvzf ${log_file_name}.tab.gz *$CON*.tab
cp ${log_file_name}.tab.gz t1/${log_file_name}.tab.gz

###
echo 'stat data...'
mkdir forplot
echo > forplot/${TESTNAME}_95
echo > forplot/${TESTNAME}_98
echo > forplot/${TESTNAME}_99

for it in "${its[@]}"
do
	it=$CON
	$stat_script 95% t1/${TESTNAME}_$it.stats  >> forplot/${TESTNAME}_95
	$stat_script 98% t1/${TESTNAME}_$it.stats  >> forplot/${TESTNAME}_98
	$stat_script 99% t1/${TESTNAME}_$it.stats  >> forplot/${TESTNAME}_99
done

###copy to test_data
test_data_dir=~/test_data/${TESTNAME}
echo copy oringinal data to $test_data_dir
#rm -rf $test_data_dir
mkdir $test_data_dir
cp -rf t1/ $test_data_dir
cp -rf forplot/ $test_data_dir


# notify 
#echo 'start notify ...'
#./finish_notify.sh

