#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############

countdown(){
    local i j from to interval
    from=${1:-100}
    echo -en ${red}${bold}
    for i in `seq -w 0 $from | sort -rn`; do
        for j in `seq ${#i}`; do
            echo -ne \\b
        done
        echo -n $i
        [ $i -gt 0 ] && sleep 1
    done
    echo -e ${end}
}
