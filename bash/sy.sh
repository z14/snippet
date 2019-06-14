#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############
#a=(r x j e u n y o t w s i q a m p f l d h b g k z c v)
#a=(v c j e u n y d l w s i a q m p f t o h b g k z x r)	# complements
#a=(z x r v c j e u n y d l w s i a q m p f t o h b g k)	# shift right 3
 a=(q m p f t o h b g k z x r v c j e u n y d l w s i a)	# shift right 10
#a=(a b c d e f g h i j k l m|n o p q r s t u v w x y z)

#s=$@
s=${1:-pgotnu}
i=0
while [ $i -lt ${#s} ]
do
	#c=${s:$i:1}
	c=${s:i:1}

	####
	#for k in ${!a[@]}
	#do
	#	[ "$c" == "${a[k]}" ] && printf "\\$(printf '%03o' "$((k+97))")" && break
	#done

	####

	let i++
	d=$(printf '%d' "'$c")

	#[ $d -eq 123 ] && echo -n ' ' && continue
	[ $d -lt 97 -o $d -gt 122 ] && echo -e \\nerr: lowercase letters only && exit 1

	#[ $d -le 99 ] && let d=d+26
	[ $d -le 109 ] && let d=d+26

	#echo -n ${a[$((d-97))]}
	#echo -n ${a[$((122-d))]}
	#echo -n ${a[$((135-d))]}
	#echo -n ${a[((135-d))]}
	#echo -n ${a[(135-d)]}
	echo -n ${a[135-d]}

done

echo
