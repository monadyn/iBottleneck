#!/bin/bash


##### Constants
reposity_web_root=~/node
test_data_root=~/test_data
one_type_srv_test_root=$test_data_root/$1_$3/t1
file_name=$1_$3_$2 #haboob_cal1_800
one_conc_test_root=${one_type_srv_test_root}/$file_name
iBottleneck_root=~/iBottleneck

echo "pwd: `pwd`"
echo "\$0: $0"
echo "basename: `basename $0`"
echo "dirname: `dirname $0`"
echo "dirname/readlink: $(dirname $(readlink -f $0))"
pushd $(dirname $(readlink -f $0))
echo "pwd: `pwd`"
echo "reposity: ${one_conc_test_root}" 

# define is_file_exists function
# $f -> store argument passed to the script
is_file_exists(){

	local f="$1"
	echo check file "$1"
    [[ -f "$f" ]] && return 0 || return 1
}
# invoke  usage
# call usage() function if filename not supplied
#[[ $# -eq 0 ]] && usag

init(){
	echo 'init--->'
	rm -rf $iBottleneck_root/public/*.png
	rm -rf *.png
	rm -rf *.txt
	rm -rf *.stats
	rm -rf *.tab
	rm -rf *.gz
	echo ''
}

cp_stat_files(){
	cur_dir=`pwd`

	echo
	echo "copy stat files -> $cur_dir"	
	cp ${one_conc_test_root}/inout.txt .
	cp ${one_conc_test_root}/multiplicity.txt . 
	cp  ${one_conc_test_root}/responsetime.txt  .
	cp  ${one_conc_test_root}/cdata.txt   .
#cp   ${one_conc_test_root}/inout_longReq.txt   .
#	cp  ${one_conc_test_root}/responsetime_longReq.txt .

	cp ${one_conc_test_root}/tablefilename . 
	cp  ${one_conc_test_root}/timerange.txt  .
	cp  ${one_conc_test_root}/presdata.csv   .
}

########################
##unit test func
cp_stat_files
exit 1

#########################################
#Main
srv_original_file=$one_type_srv_test_root/${file_name}.tab.gz 
client_original_file=$one_type_srv_test_root/${file_name}.stats

init

#extract collectl data 
if ( is_file_exists "$srv_original_file" )
then	
	cp $srv_original_file cdata.tab.gz
	gzip -d cdata.tab.gz
	sed -i '1,16d' cdata.tab
	node collectl2Epoch.js > cdata.tmp
	head -n -1 cdata.tmp > cdata.txt
	#rm cdata.tab
else
	echo "exit "
	exit 1
fi

#extract ab data
if ( is_file_exists "$client_original_file" )
then
	cp $client_original_file sdata.stats
	sed -i '/This is ApacheBench/, /longest request/d' sdata.stats
#cut first 20 s
#node cut20s.js > sdata.temp
#mv sdata.temp sdata.stats
	node requestAnalysis.js > presdata.txt
	head -n -2 presdata.txt > sdata.txt
	tail -n 2 presdata.txt > timerange.txt
else
	 echo "exit"
	 exit 1
fi



#node genInputForPython.js $2
if [ ${12} = "LongReq" ]; then
	node genInputForPythonLongReq.js $2
	rm *QueueLength*csv
	echo "to do LongReq"
else
	node genInputForPython.js $2
	echo "all req"
fi

########################
#get txt file for plot
mv *inout*csv inout.txt
#cp inout.txt inout.csv
mv *multiplicity*csv multiplicity.txt
#cp multiplicity.txt multiplicity.csv  #for debug
mv *responsetime*csv responsetime.txt
#cp responsetime.txt reponsetime.csv

sed -i "s/,/ /g" inout.txt
sed -i "s/,/ /g" multiplicity.txt
sed -i "s/,/ /g" responsetime.txt

sed -i "1,1d" inout.txt
sed -i "1,1d" multiplicity.txt
sed -i "1,1d" responsetime.txt

cp inout.txt inout.backup
cp cdata.txt cdata.backup
node shortTime.js inout.txt > inout_tmp.txt
node shortTime.js multiplicity.txt > multiplicity_tmp.txt
node shortTime.js responsetime.txt > responsetime_tmp.txt
node shortTime.js cdata.txt >cdata_tmp.txt
mv inout_tmp.txt inout.txt
mv multiplicity_tmp.txt multiplicity.txt
mv responsetime_tmp.txt responsetime.txt
mv cdata_tmp.txt cdata.txt
#########################################3


#copy to repository
backup_stat_files
##############
