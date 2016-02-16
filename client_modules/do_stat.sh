#!/bin/bash
#arg 1 is the line pattern, arg 2 in the file name
b=$(sed -n '/'$1'/p' $2)

if [ -z "$b" ]; then
	echo 0
	exit
fi

arr=$(echo $b | tr " " "\n")
re='^[0-9]+([.][0-9]+)?$'
for x in $arr
do
	if  [[ $x =~ $re ]] ; then
		echo $x
	fi
done
