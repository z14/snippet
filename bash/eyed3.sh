#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############
artist='周杰倫'

for i in */*mp3; do
    title=$(basename "$i")
    title=${title%.mp3}
    album=$(dirname "$i")
    album=${album#*-}
    album=${album# }
    echo $i
    echo $album
    echo $title
    eyeD3 --encoding utf8 -a "$artist" -b "$artist" --composer "$artist" -A "$album" -t "$title" "$i"
done

