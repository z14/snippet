#!/bin/bash
#
# vim:ft=sh
#
# bulk whois

############### Variables ###############

############### Functions ###############

############### Main Part ###############

mkdir t
cd t

[ -f "$1" ] || exit

for i in $(cat "$1")
do
	whois $i.com > $i &
done

# exceptions
# empty # [ -s $filename ]
# grep -i 'timeout'
# too frequent?
# grep -i 'no match'
