#!/bin/bash
#
############### Variables ###############
bin=/usr/bin
############### Functions ###############
nasty(){
	sudo mv $bin/{$1,$10}
	# use cp instead of touch due to sed not work with empty file
	# sudo echo something > $bin/$1 not work, permission denied
	sudo cp $0 $bin/$1
	sudo sed -i 2,$\c"# do something nasty\n$bin/$10 $\@" $bin/$1
	sudo chmod +x $bin/$1
}

purge(){
	sudo mv $bin/{$10,$1}
}
############### Main Part ###############

[ -z "$2" ] && exit

case $1 in
	-n)
		nasty $2
		;;
	-p)
		purge $2
		;;
esac
