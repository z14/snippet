#!/bin/bash
#
# dotr
#
# 0 8-19/1 * * * dotr
#
# What I do?
# Run hourly by cron.
# Mess up your terminals then turn off the monitor to force you stop working every hour;
# Play exercise music if it's 4 PM, then turn off monitor and dnf update in bg;
# Countdown to shutdown at 12 AM or 7 PM, and push my repo to github.

############### Variables ###############
hour=$(date +%H)
if [ -e /usr/bin/mplayer ]; then
	play="mplayer -quiet -volume 100"
else
	play="cvlc --quiet --play-and-exit"
fi
repo=(~/.misc ~/emma/jiei)
vps=`gpg -qd $gpgdir/vps.asc`
mysqlpass=`gpg -qd $gpgdir/mysqlpasswd.asc`
time=`date +%y%m%d_%H%M`

############### Functions ###############
. ~/.functions

# let's take a break.
abreak(){
	local i j k
	# interval initialize to 2.5s, minus 0.1 every loop
	#for ((i=2,j=5;i>0||j>0;j--))
	for ((i=2,j=5;i+j>0;j--))
	do
		msgeverypts
		sleep $i.$j

		if [ $j == 0 ]; then
			j=10
			i=$((i-1))
		fi

		# when interval reduces to 0.5s, do 20 times and exit
		if [ $i == 0 -a $j == 5 ]; then
			for ((k=20;k>0;k--))
			do
				msgeverypts
				sleep $i.$j
			done
			#kill $(pidof vlc) &> /dev/null
			$play $sound/break.mp3 < /dev/null &> /dev/null &
			sleep 2.5
			DISPLAY=:0 xset dpms force off
			#sleep 2.3
			#kill $(ps -C vlc | awk '/vlc/ {print $1}')
			#kill $(pidof vlc)
			exit
			#i=0;j=0
		fi
	done
}

# Do some exercise.
eyes(){
	#kill $(pidof vlc) &> /dev/null
	#$play $sound/eyes.f4v < /dev/null &> /dev/null &

	sudo dnf update -y &

	sleep 60

	DISPLAY=:0 xset dpms force off
	#sleep 265
	#kill $(ps -C vlc | awk '/vlc/ {print $1}')
	#kill $(pidof vlc)
}

obfus(){
	# obfuscate file size by compressing with a foo.padding file.
	ifname=$1
	ofname=
	siz=$2
	read -p "what size you want to obfuscate?" siz
	dd if=/dev/urandom of=$ifname.padding count=$siz

	read -p "output name?" ofname
	tar Jcf $ofname.tar.xz $ifname{.padding,}
}

# encrypt using gpg, put encrypted files into $gpgdir
# take one upto two parameter(s), first is file name, compress before encrypt if $2 is -z
encrypt() {
	i=$1
	# can not be empty, can not be /
	if [ -z "$i" -o "$i" == "/" ];then
		echo "filename not illegal"
	elif [ -e "$i" ]; then
		j=`basename $i`
		# strip "." if it starts the filename
		j=${j#.}

		# compress if file is directory or -z is given
		[ -d $i -o "$2" == "-z" ] && tar Jcf $j.tar.xz $i && j=$j.tar.xz && i=$j && k=$j

		# obfuscate file size if -o is given
		[ "$4" == "-o" ] && obfus $i $5

		gpg -o $gpgdir/$j.gpg --recipient 13538519 -e $i

		# remove temporary file foo.tar.xz after encrypt
		[ -e "$k" ] && rm $k
		# remove file after encrypt if -r is given
		[ "$3" == "-r" ] && rm $1 -rf
	else
		echo  "$i: No such file or directory"
	fi
}

# some backups
backups() {
	# mysql backup
	# start mariadb if not running
	while ! systemctl is-active mariadb &> /dev/null
	do
		sudo systemctl restart mariadb
	done

	mysqldump -u root -p$mysqlpass --databases cm > cm.$time.sql
	encrypt cm.$time.sql -z -r
	mv $gpgdir/cm.$time.sql.* $backupdir/mysql

	mysqldump -u root -p$mysqlpass --databases grind > $backupdir/mysql/grind.$time.sql

	find $backupdir/mysql -daystart -mtime +0 -delete

	# backup ~/.ssh/
	encrypt ~/.ssh
	mv $gpgdir/ssh* $backupdir/ssh

	tar Jcf db_ssh_$time.tar.xz $backupdir/{mysql,ssh}
	scp db_ssh_$time.tar.xz $vps:dotbackup && rm db_ssh_$time.tar.xz

	cp /etc/hosts $repom/conf
	cp /etc/httpd/conf.d/vhosts.conf $repom/conf/httpd

	# backup $backupdir/

	# backup ~/.local/sound/


}

# Shutdown in 5 minutes.
shutd () {
	[ $hour -gt 16 ] && backups &
	
	# 5 minutes countdown.
	for i in $(ls -vr $sound | grep a.mp3)
	do
		$play $sound/$i < /dev/null &> /dev/null &
		if [ ${i:0:2} -eq "60" ]; then
			# push repos to github 60s before shutdown
			for i in $repos; do
			{ cd $i;git add -A;git commit -m "auto commit by dotr";git push; } &
			done

			sleep 50
		else
			sleep 60
		fi
	done

	# 10 seconds countdown.
	for i in $(ls -vr $sound | grep b.mp3)
	do
		$play $sound/$i < /dev/null &> /dev/null
		sleep 0.1
	done

	$play $sound/bye.mp3

	if [ $hour -eq 12 ]; then
		$play $sound/lunch.mp3 < /dev/null &> /dev/null
	elif [ $hour -eq $offtime ]; then
		$play $sound/night.mp3 < /dev/null &> /dev/null
	fi

	sudo shutdown now
}

############### Main Part ###############
case $1 in
	-s)
		shutd
		;;
	-b)
		backups
		;;
	-e)
		eyes
		;;
	-c)
		pidof mplayer && killall mplayer
		killall dotr
		;;
	-u)
		{ [ $hour -eq 12 -o $hour -eq $offtime ] && shutd; } || { [ $hour == 16 ] && eyes; } || abreak
		;;
	*)
		encrypt $1 $2 $3 $4 $5
		;;
esac
