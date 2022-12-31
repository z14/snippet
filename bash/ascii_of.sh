#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############

ascii_of(){
    if [ "$1" == -c ];then
        [ "$2" -lt 256 ] || return 1
        printf "\\$(printf '%03o' "$2")"
        return 0
    fi
    printf '%d\n' "'$1"
}
