#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############

# Images to pdf
for i in *
do
    if [ -d "$i" ]; then
        echo $i
        for j in $i/*
        do
            l $j
            echo ${j/\//-}
            img2pdf $j/* -o ${j/\//-}.pdf
        done
        # pushd $i
        # l
        # popd
    fi
done

# Add text layer to pdf
dir=ocr
mkdir -p $dir

for i in *.pdf
do
    echo "$i"
    ocrmypdf -l chi_sim1 $i $dir/$i
done
