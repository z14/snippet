#!/bin/bash
#
# tcinit
# version 2.0
#
# TODO tdb, execute functions

# A Bash script to implement TrinityCore 3.3.5 or master. Including requirements installation, clone repo, cmake, make, sql import, maps extraction and more.
# All you need to do is download the TDB_full_*.7z from https://github.com/TrinityCore/TrinityCore/releases and put it into directory where tcinit at, tcinit --init will do the rest.
#
# Dot Craft(dotcra@gmail.com) Sep 5, 2016
# More details on http://dotcra.com

# @Parameters
# -a do all
# -b branch
# -c compile
# -d server path, -DCMAKE_INSTALL_PREFIX
# -e Extract DBC, Maps
# -f setconf
# -h help
# -i install requirement
# -k kill
# -m Extract MMaps
# -r repo path
# -s create sql
# -s start with screen
# -t tdb path
# -v Extract VMaps
# -w wow path
# -V version
# --db database server
# --fun funny settings
# --notools -DTOOLS=0
# --noserver -DSERVER=0
# --nowarn -DWITH_WARNINGS=0

a=$(getopt -o "ab:cd:efhikmr:st:vw:V" -l "nt,ns,nw,fun,db:" -- "$@")
set -- ${a%--*}

############### Variables ###############
say(){
	[ $? -eq 0 ] && echo -e '\e[33;1m'$@'\e[m' || echo -e '\e[31;1m'$@'\e[m'
}

while [ "$1" ]
do
	case "$1" in
		-a)
			echo do all
			;;
		-b)
			[ "$2" ] && bran="$2"
			;;
		-c)
			echo do compile
			;;
		-d)
			[ "$2" ] && srvdir="$2"
			;;
		-e)
			echo do extract dbc and maps
			map=1
			;;
		-f)
			echo do setconf
			;;
		-h)
			echo help
			;;
		-i)
			echo do install requi
			;;
		-k)
			killall authserver
			killall bnetserver
			killall worldserver
			exit 0
			;;
		-m)
			echo do extract mmaps
			let map+=2
			;;
		-r)
			[ "$2" ] && repodir="$2"
			;;
		-s)
			echo do create sql
			;;
		-t)
			[ "$2" ] && tdb="$2"
			;;
		-v)
			echo do extract vmaps
			let map+=4
			;;
		-V)
			echo version
			;;
		-w)
			[ "$2" ] && wowdir="$2"
			[ ! -d "$wowdir" ] && { say "$wowdir is not a WOW directory"; exit; }	# why the { list; } is executed when wowdir is set?
			;;
		--db)
			dbserver="$2"
			;;
		--fun)
			echo do funny settings
			;;
		--nt)
			dt=0
			;;
		--ns)
			ds=0
			;;
		--nw)
			dw=0
			;;
	esac
	shift
done

if [ "$map" ];then
	[ "$wowdir" ] || { say "please use -w to specify WOW directory for maps extracting."; exit; }
fi
dt=${dt:-1} ds=${ds:-1} dw=${dw:-1}
repodir=${repodir:-'wowd/repo/tc'}
bran=${bran:-'3.3.5'}
srvdir=${srvdir:-"wowd/${bran}"}
dbserver=${dbserver:-localhost}
#distro=$(lsb_release -si)
distro=$(uname -s)
if [ "$distro" == Linux ];then
	. /etc/os-release
	distro=$ID
else
	echo linux only; exit
fi
case $distro in
	fedora)
		install="dnf -y install"
		requi="cmake gcc gcc-c++ mariadb-devel bzip2-devel readline-devel ncurses-devel boost-devel"
		;;
	centos|rhel)
		distro=rh
		install="yum -y install"
		$install epel-release
		requi="cmake3 clang mariadb-devel openssl-devel bzip2-devel readling-devel ncurses-devel libquadmath-devel python-devel"
		;;
	debian)
		install="apt-get -y install"
		requi="cmake gcc g++ libmariadbclient-dev libssl1.0-dev libbz2-dev libreadline-dev libncurses-dev libboost-all-dev"
		;;
	FreeBSD)
		;;
	*)
		# what about the distros not listed here?
		# i think it's better to list package managers
		;;
esac
requi="$requi git make mariadb-server p7zip screen" # libxml2-devel zlib-devel
thisdir=$(dirname $0)
[ ${thisdir::1} != / ] && thisdir=$(pwd)/$thisdir

############### Functions ###############

# Show version
version() {
	echo "tcinit 2.0 by Dot Craft(dotcra@gmail.com) Sep 7, 2016"
	echo "More details on http://dotcra.com"
}

# Display help
readme() {
	echo "\
tcinit is a script for Redhat derivative to implement TrinityCore 3.3.5 or master
Including requirements installation, clone repo, cmake, make, sql import, maps extraction and more.
All you need to do is download the TDB_full_*.7z from https://github.com/TrinityCore/TrinityCore/releases and put it into directory where tcinit at, tcinit --init will do the rest.

Usage:
  tcinit [option]

Options:
  -s			shutdown all servers
  --init		implement a brandnew TrinityCore
  -d, --debug		debug
  -h			display this help
  -v			display version information
  -q			run server in background
  			run server as interactive cli if no parameter is given
  -c			some configuration to *.conf
  -b			create TrinityCore database
  -t			place TDB file

Visit http://dotcra.com for more details."
}

makesome(){
	make="make"
	make_install="make install"
	case $1 in
		mpc)
			ls $1*tar* || curl -L "ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz" -o mpc-1.0.3.tar.gz
			configure="../configure --prefix=/usr --disable-static --docdir=/usr/share/doc/mpc-1.0.3"
			;;
		gcc)
			say "gcc in repo not match requirements(4.9.0), you must compile it yourself. " 
			sudo $install gmp-devel mpfr-devel libmpc-devel
			ls $1*tar* || curl -L "http://gcc.parentingamerica.com/releases/gcc-6.3.0/gcc-6.3.0.tar.bz2" -o gcc-6.3.0.tar.bz2
			configure="../configure --prefix=/usr --enable-languages=c,c++ --disable-multilib --disable-bootstrap --with-system-zlib"
			;;
		boost)
			say "Boost in repo not match requirements(1.56), you must compile it yourself. "
			ls $1*tar* || curl -L "https://sourceforge.net/projects/boost/files/latest/download?source=files" -o boost_1_63_0.tar.bz2
			configure="../bootstrap.sh --prefix=/usr"
			make="../b2"
			make_install="../b2 install"
			;;
		cmake)
			ls $1*tar* || curl -L "https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz" -o cmake-3.7.2.tar.gz
			configure="../bootstrap --prefix=/usr"
			;;
	esac

	rm $1*/ -rf
	tar xf $1*tar*
	pushd $1*/
	mkdir build; cd build
	$configure
	$make
	sudo $make_install
	popd
}

# install requirements
install_requi (){
	# processor with SSE2 support
	# boost >= 1.56
	# mysql >= 5.1.0
	# openssl = 1.0.x
	# cmake >= 3.0.2
	# gcc >= 4.9.3 or clang >= 3.5
	# zlib >= 1.2.7

	sudo ${install%install} update
	[ "$distro" = debian ] && sudo ${install%install} upgrade
	sudo $install $requi

	ver=$(openssl version | cut -d" " -f2)
	[ ${ver%.*} \> 1.0 -a $distro == fedora ] && sudo $install --allowerasing compat-openssl10-devel

	[ "$distro" == rh ] && sudo ln -s /usr/bin/cmake3 /usr/bin/cmake

	[ "$distro" == rh ] && makesome boost
}

# choose branch
chbran (){
	# when $repodir exists, keep trying git clone or git checkout until success
	local i=1
	while [ -d $repodir -a $i != 0 ]
	do
		# if $repodir is empty
		if [ $(ls -a $repodir | wc -w) == 2 ]; then
			# clone if empty
			say "$repodir is empty, start git clone"
			git clone -b $bran git://github.com/TrinityCore/TrinityCore.git $repodir && i=0
		else
			# try git checkout if not empty, ask for another directory when fails
			git -C $repodir checkout $bran 2> /dev/null
			i=$?
			[ $i == 0 ] && git -C $repodir pull
			[ $i != 0 ] && { say "$repodir is not empty, and seems not a TrinityCore repo."; exit; }
		fi
	done

	[ -f "$repodir" ] && { say "there's a file named "$repodir""; exit; }
	[ ! -e $repodir ] && git clone -b $bran git://github.com/TrinityCore/TrinityCore.git $repodir
}

runcmake (){
	[ "${srvdir::1}" != / ] && srvdir=$(pwd)/$srvdir
	mkdir -p $repodir/build; cd $repodir/build && rm * -rf
	say "Running cmake with parameters: -DCMAKE_INSTALL_PREFIX=$srvdir -DSERVERS=$ds -DTOOLS=$dt -DWITH_WARNINGS=$dw"
	cmake ../ -DCMAKE_INSTALL_PREFIX=$srvdir -DSERVERS=$ds -DTOOLS=$dt -DWITH_WARNINGS=$dw || exit
}

# make & make install
runmake (){
	say "################## start Make ##################"
	echo -e "start make TrinityCore at\t$(date +%T)" > $repodir/build/make_tc_time_cost
	make -j $(nproc) || exit
	echo -e "finish make TrinityCore at\t$(date +%T)" >> $repodir/build/make_tc_time_cost
	make install
}

# copy conf
setconf (){
	mkdir -p $srvdir/log
	cd $srvdir/etc
	say "Creating configuration files...  "
	cp worldserver.conf.dist worldserver.conf
	if [ "$bran" != "3.3.5" ]; then
		cp bnetserver.conf.dist bnetserver.conf
		# edit "LogsDir" value to "$srvdir/log" in bnetserver.conf(6.x only), default "."
		# there're slashes in $srvdir, so the delimiter / have to be replaced with : in sed substitution
		sed -i /^LogsDir/s:\".*\":\"$srvdir/log\": bnetserver.conf
		# edit path of "CertificateFile" and "PrivateKeyFile" in bnetserver.conf so server can be start at any PWD
		sed -i /^Certific/s:\"\.:\"$srvdir/bin: bnetserver.conf
		sed -i /^PrivateK/s:\"\.:\"$srvdir/bin: bnetserver.conf
	else
		cp authserver.conf.dist authserver.conf
		# edit "LogsDir" value to "$srvdir/log" in authserver.conf(3.3.5 only), default "."
		sed -i /^LogsDir/s:\".*\":\"$srvdir/log\": authserver.conf
	fi
	# edit "LogsDir" value to "$srvdir/log" in worldserver.conf, default "."
	sed -i /^LogsDir/s:\".*\":\"$srvdir/log\": worldserver.conf
	# edit "DataDir" value to "$srvdir/data" in worldserver.conf so server can be start at any PWD
	sed -i /^DataDir/s:\".*\":\"$srvdir/data\": worldserver.conf
	sed -i /Motd/s/\".*/"\"Visit w.dotcra.com for more info.\""/ $srvdir/etc/worldserver.conf
	say "done!"
}

# import sql to create MySQL user & create tables & grant privilege
createsql (){
	if [ "$dbserver" = localhost ];then
		say "Checking MySQL server status"
		while ! systemctl is-active mariadb &> /dev/null
		do
			say "MySQL server is not running, need password to start it"
			sudo systemctl start mariadb
		done
		say "MySQL server is ready"
	fi

	say "Try to create trinity user in MySQL, MySQL root password is needed."
	# once passwd wrong, no more chance?
	mysql --default-character-set=utf8 -h $dbserver -u root -p < $repodir/sql/create/create_mysql.sql
}

# extract DBC & Maps
exmaps (){
	if cd "$wowdir" ;then
		say "STARTING to extract Map and DBC."
		$srvdir/bin/mapextractor
		mkdir -p $srvdir/data
		[ "$bran" != "3.3.5" ] && { mv dbc maps gt $srvdir/data;:; } || mv dbc maps Cameras $srvdir/data
	else
		say "Can't access $wowdir"
		exit
	fi
}

# extract VMaps & MMaps
exvmap (){
	i= # unnecessary but safer. read will set var to null when time out
	say "STARTING to extract vmmaps in 5 sec."
	read -p "START vmaps? [Y/n]" -t5 -n1 i
	echo
	if [ "$i" == n -o "$i" == N ];then
		sed -i /^vmap/s/1/0/ $srvdir/etc/worldserver.conf
		say "\
!!! vmaps skipped !!!
Some corresponding changes have been made in $srvdir/etc/worldserver.conf to disable vmaps:
##########################################
vmap.enableLOS = 1 – set to 0
vmap.enableHeight = 1 – set to 0
vmap.petLOS = 1 – set to 0
vmap.enableIndoorCheck = 1 – set to 0
##########################################
If you change your mind and decide to extract and use vmaps later, make sure to change these values back to "1" to take advantage of them."
		return
	fi

	if cd "$wowdir";then
		$srvdir/bin/vmap4extractor
		mkdir -p vmaps
		$srvdir/bin/vmap4assembler Buildings vmaps
		mv vmaps $srvdir/data
		rm -rf Buildings
		# sed -i /^vmap/s/0/1/ $srvdir/etc/worldserver.conf
	else
		say "Can't access $wowdir"
	fi
}

exmmap (){
	if cd "$wowdir";then
		mkdir -p mmaps
		$srvdir/bin/mmaps_generator
		mv mmaps $srvdir/data
		sed -i /^mmap/s/0/1/ $srvdir/etc/worldserver.conf
		say "\
!!! mmaps is ready! !!!
Corresponding change have been made in $srvdir/etc/worldserver.conf to enable mmaps:
##########################################
mmap.enablePathFinding = 1
##########################################
If you decide to disable mmaps later, just change this value back to "0"."
	else
		say "Can't access $wowdir"
		exit
	fi

}

# place TDB_*.sql
tdb (){
	# check if any TDB_full_* file in $srvdir/bin
	say "Checking TDB in $srvdir/bin."
	cd $srvdir/bin
	# if no TDB_* files in $srvdir/bin, try to fetch some from this script's dir then check again
	# how to use text+regex instead of ls?
	ls TDB_* &> /dev/null || mv $thisdir/TDB_* .
	ls TDB_*.sql &> /dev/null && return
	ls TDB_full_*/TDB_*.sql &> /dev/null && cp TDB_full_*/TDB_*.sql . && return
	ls TDB_full_*.7z &> /dev/null && 7za x TDB_full_*.7z && cp TDB_full_*/TDB_*.sql . && return
	say "############### IMPORTANT !!! ###############"
	say "The required TDB_*.sql not found in $srvdir/bin"
	say "You need to download the corresponding TDB_full_*.7z file at https://github.com/TrinityCore/TrinityCore/releases, extract and place the TDB_*.sql file(s) at $srvdir/bin, then MUST go into $srvdir/bin use ./worldserver to import the world and hotfixes(6.x only) databases."
	say "############### IMPORTANT !!! ###############"
}

funnysettings(){
	sed -i /MaxPlayerLevel/s/[0-9].*/110/ $srvdir/etc/worldserver.conf
	sed -i /StartPlayerLevel/s/[0-9].*/110/ $srvdir/etc/worldserver.conf
	sed -i /StartDemonHunterPlayerLevel/s/[0-9].*/110/ $srvdir/etc/worldserver.conf
	sed -i /StartPlayerMoney/s/[0-9].*/999999999/ $srvdir/etc/worldserver.conf
	sed -i /AllFlightPaths/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /InstantFlightPaths/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /Motd/s/\".*/"\"Visit w.dotcra.com for more info.\""/ $srvdir/etc/worldserver.conf
	sed -i /AllowTwoSide.Interaction.Calendar/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /AllowTwoSide.Interaction.Channel/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /AllowTwoSide.Interaction.Group/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /AllowTwoSide.Interaction.Guild/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /AllowTwoSide.Interaction.Auction/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /AllowTwoSide.Trade/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /PlayerStart.AllReputation/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /PlayerStart.AllSpells/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /PlayerStart.MapsExplored/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
	sed -i /AlwaysMaxWeaponSkill/s/[0-9].*/1/ $srvdir/etc/worldserver.conf
}
############### Main Part ###############

case $1 in
	--init)
		install_requi
		chbran
		runcmake
		runmake
		setconf
		createsql
		tdb
		exmaps
		;;
	-a)
		chbran
		runcmake
		runmake
		setconf
		;;
	"")
		[ "$bran" = 3.3.5 ] && auth=authserver || auth=bnetserver
		world=worldserver
		screen -dmS wowd
		if ! pgrep $auth;then
			screen -S wowd -X screen $srvdir/bin/$auth
		else
			say "$auth is already running"
		fi
		if ! pgrep $world;then
			screen -S wowd -X screen $srvdir/bin/$world
		else
			say "$world is already running"
		fi
		;;
esac
