#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############

is_num(){
    local i
}

is_float(){
    local i
}

is_int(){
    local i
    i="$1"

    #if [[ "$i" =~ ^[-+]?[0-9]+$ ]]; then
    #	return 0
    #else
    #	return 1
    #fi

    # this solution has integer limit
    # https://stackoverflow.com/a/19116862/7714132
    #if [ "$i" -eq "$i" ] 2> /dev/null; then
    #	return 0
    #else
    #	return 1
    #fi

    # https://stackoverflow.com/a/18620446/7714132
    case ${i#[-+]} in
        *[!0-9]* | '')
            return 1
            ;;
        *)
            return 0
            ;;
    esac
}
