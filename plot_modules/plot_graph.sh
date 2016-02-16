#!/bin/bash

reposity_web_root=~/node
test_data_root=~/test_data
one_conc_test_root=$test_data_root/$1_$3/t1

iBottleneck_root=~/iBottleneck
plot_module_root=$iBottleneck_root/plot_modules
stat_script=$plot_module_root/stat_load_tp.sh
plot_script=$plot_module_root/plot_load_tp.sh

$stat_script $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11}  ${12} ${13} ${14} ${15} ${16}
$plot_script $1 $2 $3 $4 $5 $6 $7 $8 $9 ${10} ${11}  ${12} ${13} ${14} ${15} ${16}
