#!/bin/sh
netstat -a46p --numeric-ports --numeric-hosts | sed -n '1!p' | sed -n '1!p' |   while IFS= read -r line;    do

echo $(echo $line | tr -s '/' | cut -d '/' -f 1 | grep -oP "\S+$") $(echo -n $line | tr -s ' ' | cut -d ' ' -f 4) $(echo $line | tr -s '/' | cut -d '/' -f 1 | grep -oP "\S+$" | xargs ps -f -p | sed -n '1!p' | tr -s ' ' | cut -d ' ' -f 8) ;

done
