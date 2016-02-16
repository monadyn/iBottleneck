#!/bin/bash

inoutfile="../"$1"_"$3"/t1/"$1"_file_"$2"/inout.txt"

fline=$(head -n 1 $inoutfile)
lline=$(tail -n 1 $inoutfile)

echo set xrange [${fline:0:7}:${lline:0:7}]
