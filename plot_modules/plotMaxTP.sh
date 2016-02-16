#!/bin/bash

conc=(100 200 400 800 1600 3200)

echo > maxTP.dat
for cc in "${conc[@]}"
	do
		fpath='../'$1'_'$2'/t1/'$1'_file_'$cc'/inout.txt'

		node maxTP.js $1 $cc $2 $fpath >> maxTP.dat
	done

echo > forplot_bar.txt

echo "set term png size 800, 600" >> forplot_bar.txt
echo "set output '"$1"_"$2"_maxTP.png'" >> forplot_bar.txt
echo "set boxwidth 0.5" >> forplot_bar.txt
echo "set style fill solid" >> forplot_bar.txt
echo "set yrange [70:130]" >> forplot_bar.txt

echo "set xtics ( '100' 0, '200' 1, '400' 2, '800' 3, '1600' 4, '3200' 5 )" >> forplot_bar.txt
echo "plot 'maxTP.dat' using 2 w boxes notitle" >> forplot_bar.txt

gnuplot forplot_bar.txt
gnome-open $1"_"$2"_maxTP.png"

