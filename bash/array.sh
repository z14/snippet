#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############

# assign array a to array b
assign_array(){
    local a=$1
    unset b
    # declare array b as associaitve if a is
    declare -A $a 2> /dev/null && declare -A $b

    for i in $(eval echo \${!$a[@]})
    do
        eval $b[$i]=\${$a[$i]}
    done
}

# get key of the value in an array
getkey(){
    # $1 value, $2 array
    local i v=$1 a=$2
    # assign_array $2 $a
    for i in $(eval echo \${!$a[@]})
    do
        #echo $i
        eval [ "$v" == \${$a[$i]} ] && echo $i && return 0
    done
    return 1
}
