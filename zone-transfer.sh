#!/bin/bash

url=$1
echo 'Finding assets...'
if [[ $2 == '-r' ]]
then
        raw=`assetfinder --subs-only $url`
        echo 'Resolving urls...'
        assets=`echo $raw | sed 's# #\n#g' | httprobe -c 200 | sed 's#http://##g; s#https://##g' | sort -u`
else
        assets=`assetfinder --subs-only $url | sort -u`
fi
total=`echo $assets | sed 's# #\n#g' | wc -l`
echo 'Number of urls:' $total
count=1
for i in $(echo $assets | sed 's# #\n#g'); do
        nameserver=`host -t ns $i 2>/dev/null 2>/dev/null | awk '{print $4}' | sed 's#\.$##'`
        for j in $(echo $nameserver |  sed 's# #\n#g'); do
                host -l $i $j 2>/dev/null
        done
        echo -ne $count 'out of' $total '\r'
        ((count++))
done
