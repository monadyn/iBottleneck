#!/bin/bash

client_tool=../tools/ab

echo 'params<<<'
echo $#
echo $@
echo '>>>'

###client run ab
echo 'start run ab...'
$client_tool -r -n $1 -c $2 $3 > $5/$4.stats
echo 'fi ab stress test...'

####cp the collect info and ab data to node srv

###gen plot to intermediate ui
