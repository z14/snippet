#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############

say(){
    [ -z "$1" ] && echo "say what?" && return
    set $@ # so we can use quotes
    echo -en ${red}${bold}
    while :; do
        echo -n $1
        shift
        [ -z $1 ] && echo && break || echo -n " "
        local r=`date +%N`
        r=${r##*0}
        local r=${r:0:1} # a 1~9 random number
        sleep 0.$r
    done
    echo -en ${end}
}
