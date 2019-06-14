#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############

report(){
	if [ "$?" == "0" ]; then
		echo `date +"%b %d %T"` $1 $2 complete! | tee -a ../../reborn_make_log
	else
		echo `date +"%b %d %T"` $1 $2 have some problem!!! | tee -a ../../reborn_make_log
	fi
	read -p "shall we continue? [Y/n]" i
	[ "$i" == "n" -o "$i" == "N" ] && exit
}

makesome(){
	local configure make make_install
	make="make"
	make_install="make install"
	case $1 in
		mpc)
			ls $1*tar* || curl -L "ftp://ftp.gnu.org/gnu/mpc/mpc-1.0.3.tar.gz" -o mpc-1.0.3.tar.gz
			configure="./configure --prefix=/usr --disable-static --docdir=/usr/share/doc/mpc-1.0.3"
			;;
		gcc)
			ls $1*tar* || curl -L "http://gcc.parentingamerica.com/releases/gcc-6.3.0/gcc-6.3.0.tar.bz2" -o gcc-6.3.0.tar.bz2
			configure="../configure --prefix=/usr --enable-languages=c,c++ --disable-multilib --disable-bootstrap --with-system-zlib"
			;;
		boost)
			ls $1*.7z || curl -L "https://sourceforge.net/projects/boost/files/latest/download?source=files" -o boost_1_63_0.7z
			configure="./bootstrap.sh --prefix=/usr"
			make="./b2"
			make_install="./b2 install"
			;;
		cmake)
			ls $1*tar* || curl -L "https://cmake.org/files/v3.7/cmake-3.7.2.tar.gz" -o cmake-3.7.2.tar.gz
			configure="./bootstrap --prefix=/usr"
			;;
		php)
			ls $1*tar* || curl -L "http://php.net/get/php-7.1.1.tar.xz/from/a/mirror" -o php-7.1.1.tar.xz
			configure="./configure --with-mysqli --enable-opcache --with-gd --with-openssl --with-curl --enable-mbstring  --with-apxs2=/usr/bin/apxs"
			;;
		pptpd)
			ls $1*tar* || curl -L "https://sourceforge.net/projects/poptop/files/latest/download?source=files" -o pptpd-1.4.0.tar.gz
			;;
	esac

	rm $1*/ -rf
	tar xf $1*tar* || 7za x $1*.7z
	pushd $1*/
	case $1 in
		gcc)
			mkdir -p build; cd build
			;;
	esac

	$configure; report $1 configure
	$make; report $1 make
	sudo $make_install; report $1 make_install

	case $1 in
		php)
			sudo cp ../php.ini-development /usr/local/lib/php.ini
			sudo sed -i \$a"zend_extension=/usr/local/lib/php/extensions/no-debug-non-zts-20160303/opcache.so" /usr/local/lib/php.ini
			sudo cp $scriptdir/../conf/httpd/php.conf /etc/httpd/conf.d/
			;;
	esac

	popd
}

