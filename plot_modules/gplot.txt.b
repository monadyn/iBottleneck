
set term png size 1200,1800
set output 'apache_cal1_4800.png'
set multiplot layout 8, 1 title 'apache cal1 4800'



set xrange [7680:7800]
set xlabel 'Timeline [s]'
set ylabel 'Throughput [Reqs/s]'
set yrange [0:9000]
set style data linespoints

f(x) = mean_y
fit f(x) 'inout.txt' u 1:3 via mean_y

plot 'inout.txt' u ($1):($3*20)  with linespoints title gprintf("apache Mean = %g",mean_y*20)


#set label 3 gprintf("Mean = %g", mean_y*20) at 7742, 500 
#set title gprintf("Mean = %g", mean_y*20) 




set autoscale y
set ylabel 'Load [#]'
set yrange [0:4800]
set style data linespoints
plot 'multiplicity.txt' using 1:2 with linespoints title 'concurrent active request'
set ylabel 'Load [#]'
set style data linespoints
plot 'multiplicity.txt' using 1:14 with linespoints title 'response time > 1.2s',  'multiplicity.txt' using 1:15 with linespoints title 'response time <= 1.2s'
set autoscale y
set ylabel 'Response time [s]'
set yrange [0:1.2]
plot 'responsetime.txt' using 1:2 with linespoints title 'response time < 1.2s'
set autoscale y
set ylabel 'CPU_Totl'
set yrange [0:105]
plot 'cdata.txt' u ($1-1):($10) w l title 'CPU_Totl'
set autoscale y
set ylabel 'CPU_User'
set yrange [0:105]
plot 'cdata.txt' u ($1-1):($2) w l title 'CPU_User'
set autoscale y
set ylabel 'CPU_Sys'
set yrange [0:105]
plot 'cdata.txt' u ($1-1):($4) w l title 'CPU_Sys'
set autoscale y
