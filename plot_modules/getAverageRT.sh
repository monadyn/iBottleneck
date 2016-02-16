cp ../$1_cal1/t1/$1_file_$2.stats sdata.stats
sed -i '/This is ApacheBench/, /longest request/d' sdata.stats
node getAverageRT.js
