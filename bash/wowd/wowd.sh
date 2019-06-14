#!/bin/bash
#
# vim:ft=sh

############### Variables ###############
vanilla=1.12
tbc=2.4.3
wotlk=3.3.5
cataclysm=4.3.4
mop=5.4.1
legion=latest
#all="1.12 2.43 3.3.5 4.3.4 5.4.1 latest IDK"
#list="$vanilla $tbc $wotlk $cataclysm $mop $legion IDK"
list="vanilla tbc wotlk cata mop legion IDK"

thisdir=$(dirname $0)
user=dot
dir=/home/$user/wowd

############### Functions ###############

############### Main Part ###############

mkdir -p $dir/repo $dir/db

echo "We have vanilla(1.12), tbc(2.4.3), wotlk(3.3.5), cataclysm(4.3.4), mop(5.4.1) and legion(7.2.X)"
echo Which one do you want?
select ver in $list
do
	case $ver in
		vanilla)
			opt="mangos cmangos"
			;;
		tbc)
			opt="mangos cmangos"
			;;
		wotlk)
			opt="mangos cmangos TrinityCore"
			;;
		cata)
			opt="mangos"
			;;
		mop)
			opt="mangos"
			;;
		legion)
			opt="TrinityCore"
			;;
		IDK)
			opt="mangos cmangos TrinityCore"
			;;
	esac
	[ "$ver" ] && break
done

echo "for $ver, you can choose:"

set $opt
if [ $# -eq 1 ];then
	one=$opt
	echo $one
else
	select one in $opt
	do
		[ $one ] && break
	done
fi

case $one in
	mangos)
		case $ver in
			vanilla)
				remote="https://github.com/mangoszero/server"
				db_remote="https://github.com/mangoszero/database"
				repo=zero
				;;
			tbc)
				remote="https://github.com/mangosone/server"
				db_remote="https://github.com/mangosone/database"
				repo=one
				;;
			wotlk)
				remote="https://github.com/mangostwo/server"
				db_remote="https://github.com/mangostwo/database"
				repo=two
				;;
			cata)
				remote="https://github.com/mangosthree/server"
				db_remote="https://github.com/mangosthree/database"
				repo=three
				;;
			mop)
				remote="https://github.com/mangosfour/server"
				db_remote="https://github.com/mangosfour/database"
				repo=four
				;;
		esac
		echo run mangos.sh
		;;
	cmangos)
		case $ver in
			vanilla)
				remote="https://github.com/cmangos/mangos-classic"
				db_remote="https://github.com/cmangos/classic-db"
				repo=classic
				;;
			tbc)
				remote="https://github.com/cmangos/mangos-tbc"
				db_remote="https://github.com/cmangos/tbc-db"
				repo=tbc
				;;
			wotlk)
				remote="https://github.com/cmangos/mangos-wotlk"
				db_remote="https://github.com/cmangos/wotlk-db"
				repo=wotlk
				;;
		esac
		echo run cmangos.sh
		;;
	TrinityCore)
		remote="https://github.com/TrinityCore/TrinityCore"
		case $ver in
			wotlk)
				db_remote="https://github.com/TrinityCore/TrinityCore/releases/download/TDB335.63/TDB_full_335.63_2017_04_18.7z"
				ver=3.3.5
				;;
			legion)
				db_remote="https://github.com/TrinityCore/TrinityCore/releases/download/TDB720.00/TDB_full_720.00_2017_04_18.7z"
				ver=master
				;;
		esac
		echo run $thisdir/tcinit.sh --init -b $ver -r $dir/repo/tc -d $dir/db/$ver -s $dir/$ver
		;;
esac

echo version is $ver
echo using $one
echo repo is $repo
echo github is $remote
echo database $db
echo db_remote $db_remote
