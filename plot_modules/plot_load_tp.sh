#!/bin/bash


##### Constants
reposity_web_root=~/node
test_data_root=~/test_data
one_conc_test_root=$test_data_root/$1_$3/t1

iBottleneck_root=~/iBottleneck

echo $@
echo "pwd: `pwd`"
echo "\$0: $0"
echo "basename: `basename $0`"
echo "dirname: `dirname $0`"
echo "dirname/readlink: $(dirname $(readlink -f $0))"
pushd $(dirname $(readlink -f $0))
echo "pwd: `pwd`"


png_file_name=$1"_"$3"_"$2".png"
pdf_file_name=$1"_"$3"_"$2".pdf"
srv_type=$1

########################
echo 'gnuplot-->'
echo $@
echo '-------------------------------------'
echo > gplot.txt
echo "set term png size "$4  >> gplot.txt
filename="set output '${png_file_name}'" >> gplot.txt
echo $filename >> gplot.txt
#plotname="set multiplot layout 8, 1 title 'abcde'"
plotname="set multiplot layout 8, 1 title '"$1" "$3" "$2"'"
echo $plotname >> gplot.txt

if [ $5 = "OFF" ]; then
	./getXrange.sh $1 $2 $3 >> gplot.txt
else 
	echo "set xrange "$5 >> gplot.txt	
fi

echo "set xlabel 'Timeline [s]'" >> gplot.txt

if [ $6 = "ON" ]; then
	echo "set ylabel 'Throughput [Reqs/s]'" >> gplot.txt
	if [ ${13} != "OFF" ]; then
		echo "set yrange "${13} >> gplot.txt
	fi

	echo "set style data linespoints" >> gplot.txt
	
	echo "f(x)=mean_y" >> gplot.txt
	echo "fit f(x) 'inout.txt'  u (\$1):(\$3*20) via mean_y" >> gplot.txt
	#echo "plot 'inout.txt' using 1:2  with linespoints title 'Send', 'inout.txt' using 1:3 with linespoints title 'Receive'" >> gplot.txt
	#echo "plot 'inout.txt' u (\$1):(\$3*20)  with linespoints title '${srv_type} gprintf("%g", mean_y)'" >> gplot.txt
	echo "plot 'inout.txt' u (\$1):(\$3*20)  with linespoints title gprintf(\"requests (mean = %g)\", mean_y)" >> gplot.txt
	#echo "plot 'inout.txt' u (\$1):(\$3*20)  w 1 title '${srv_type}'" >> gplot.txt
	echo "set autoscale y" >> gplot.txt
fi

if [ $7 = "ON" ]; then
	echo "set ylabel 'Load [#]'" >> gplot.txt
	if [ ${14} != "OFF" ]; then
		echo "set yrange "${14} >> gplot.txt
	fi
	echo "set style data linespoints" >> gplot.txt
#	echo "plot 'multiplicity.txt' using 1:2 w l" >> gplot.txt
	#echo "plot 'multiplicity.txt' using 1:2 with linespoints title 'concurrent active request'" >> gplot.txt
	
#	echo "set ylabel 'dropped multiplicity'" >> gplot.txt
#	echo "set style data linespoints" >> gplot.txt
#	echo "plot 'multiplicity.txt' using 1:14 with linespoints" >> gplot.txt
#	echo "set ylabel 'actual multiplicity'" >> gplot.txt
#	echo "set style data linespoints" >> gplot.txt
#	echo "plot 'multiplicity.txt' using 1:15 with linespoints" >> gplot.txt
	
	#echo "set ylabel 'long_request/short_request Load [#]'" >> gplot.txt
	echo "set ylabel 'Load [#]'" >> gplot.txt
	echo "set style data linespoints" >> gplot.txt

	echo "f(x)=mean_y" >> gplot.txt
	echo "fit f(x) 'multiplicity.txt'  u (\$1):(\$14) via mean_y" >> gplot.txt
	echo "f(x)=mean_y2" >> gplot.txt
	echo "fit f(x) 'multiplicity.txt'  u (\$1):(\$15) via mean_y2" >> gplot.txt
#echo "plot 'multiplicity.txt' using 1:14 with linespoints title 'response time > 1.2s',  'multiplicity.txt' using 1:15 with linespoints title 'response time <= 1.2s'"  >> gplot.txt
	echo "f(x)=mean_y3" >> gplot.txt
	echo "fit f(x) 'multiplicity.txt'  u (\$1):(\$2) via mean_y3" >> gplot.txt
	
	echo "plot  'multiplicity.txt' using 1:2 with linespoints title gprintf(\"total, mean = %g\", mean_y3),  'multiplicity.txt' using 1:14 with linespoints title gprintf(\"RT>1.2s, mean = %g\", mean_y),  'multiplicity.txt' using 1:15 with linespoints title gprintf(\"RT <= 1.2s, mean = %g\", mean_y2)"  >> gplot.txt
	
	echo "set autoscale y" >> gplot.txt
fi

if [ $8 = "ON" ]; then
	echo "set ylabel 'Response time [ms]'" >> gplot.txt
	if [ ${15} != "OFF" ]; then
		echo "set yrange "${15} >> gplot.txt
	fi
	
	
	echo "f(x)=mean_y" >> gplot.txt
	echo "fit f(x) 'responsetime.txt'  u (\$1):(\$2*1000) via mean_y" >> gplot.txt
	
	#echo "plot 'responsetime.txt' using 1:2 with linespoints title 'response time < 1.2s'" >> gplot.txt
	echo "plot 'responsetime.txt' u (\$1):(\$2*1000) with linespoints title gprintf(\"RT<1.2s (mean = %g)\", mean_y) " >> gplot.txt
	echo "set autoscale y" >> gplot.txt
fi

if [ $9 = "OFF" ]; then
	echo "# noting here" >> gplot.txt
else
	node processplot.js $9 >> gplot.txt
fi

if [ ${10} = "OFF" ]; then
	echo "# noting here" >> gplot.txt
else
	node processplot.js ${10} >> gplot.txt
fi

if [ ${11} = "OFF" ]; then
	echo "# noting here" >> gplot.txt
else
#echo "set ylabel '"${11}"'" >> gplot.txt
	node processplot.js ${11} >> gplot.txt
fi


gnuplot gplot.txt
#cp *png img_results/
#cp *pdf img_results/
#cp *pdf $reposity_web_root
cp ${png_file_name} $iBottleneck_root/public/show.png


#another graph
#cp presdata.txt presdata.csv
gnuplot -e "datasource='presdata'" histgramPlot.gnuplot
ps2pdf presdata.ps
mv presdata.pdf $pdf_file_name 


cp ${png_file_name} $reposity_web_root
cp $pdf_file_name $repository_web_root

#rm *pdf


#cp to public 
#mv *.png show.png

#one_conc_test_root
#cp cdata.txt /tes
