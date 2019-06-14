#!/bin/bash
#
# handle all LFS jobs before chroot, the chrooted part named lfs2.bin.sh can be found in same directory. 

############### Variables ###############
# disalbe hash
set +h
#umask 022
# set some env
PATH=/tools/bin:/bin:/usr/bin # must take first place after clean env, otherwise uname and set have no path
LFS=/mnt/lfs
LFS_TGT=$(uname -m)-lfs-linux-gnu
LC_ALL=POSIX
export PATH LFS LC_ALL LFS_TGT # must be done, subprocess such as ./configure need them
# temporary tools, *_p2 means pass 2, gcc_p3 is libstdc++
tmptools="binutils gcc linux glibc gcc_p3 binutils_p2 gcc_p2 tcl expect dejagnu check ncurses bash bzip2 coreutils diffutils file findutils gawk gettext grep gzip m4 make patch perl sed tar texinfo util-linux xz"
#tmptools="binutils gcc linux glibc gcc_p3 binutils_p2"
#tmptools="gcc_p2 tcl expect dejagnu check ncurses bash bzip2 coreutils diffutils file findutils gawk gettext grep gzip m4 make patch perl sed tar texinfo util-linux xz"

############### Functions ###############
check_host_env(){
	[ -z "$LFS" ] && echo "\$LFS not set, check 2.6. Setting The \$LFS Variable to get detail" && exit
	echo "############## Printing block list ##############"
	echo
	lsblk
	echo
	echo "############### RE-CHECK the list ###############"
	echo
	read -p "Are you sure ALL LFS partions were mounted correctly? [Y/n]" i
	[ "$i" == "n" -o "$i" == "N" ] && exit
}

# 3.1. download packages
downloadpacks() {
	check_host_env
	wget http://www.linuxfromscratch.org/lfs/view/stable/wget-list --directory-prefix=$LFS/sources
	wget http://www.linuxfromscratch.org/lfs/view/stable/md5sums --directory-prefix=$LFS/sources
	wget --input-file=$LFS/sources/wget-list --continue --directory-prefix=$LFS/sources
	#wget -i $LFS/sources/wget-list -c -P $LFS/sources

	# check packages md5sums
	cd $LFS/sources
	md5sum -c $LFS/sources/md5sums
}

# 4.2. Creating the $LFS/tools Directory
temptooldir(){
	mkdir -pv $LFS/tools
	# and link $LFS/tools to /tools
	echo "link $LFS/tools to /tools, password needed"
	sudo ln -sf $LFS/tools /
}

# called by extract_compile(), log configure, make and make install status code
report(){
	if [ "$?" == "0" ]; then
		echo `date +"%b %d %T"` $1 $2 complete! | tee -a $LFS/sources/log
	else
		echo `date +"%b %d %T"` $1 $2 have some problem!!! | tee -a $LFS/sources/log
	fi
	read -p "shall we continue? [Y/n]" i
	[ "$i" == "n" -o "$i" == "N" ] && exit
}

# the main compile procedure
extract_compile(){
	cd $LFS/sources
	jj=$1 j=${jj%_p*}
	configure="./configure" conf_argu= make="make" make_check= make_install="make install"
	rm $j*/ -rf
	tar xf $j*tar*
	cd $j*/

	case $jj in
		gcc|gcc_p2)
			tar xf ../mpfr*tar*
			mv mpfr* mpfr
			tar xf ../gmp*tar*
			mv gmp* gmp
			tar xf ../mpc*tar*
			mv mpc* mpc

			for file in $(find gcc/config -name linux64.h -o -name linux.h -o -name sysv4.h)
			do
				cp -uv $file{,.orig}
				sed -e 's@/lib\(64\)\?\(32\)\?/ld@/tools&@g' -e 's@/usr@/tools@g' $file.orig > $file
				echo '
#undef STANDARD_STARTFILE_PREFIX_1
#undef STANDARD_STARTFILE_PREFIX_2
#define STANDARD_STARTFILE_PREFIX_1 "/tools/lib/"
#define STANDARD_STARTFILE_PREFIX_2 ""' >> $file
				touch $file.orig
			done
			;;&
		dejagnu|check|diffutils|file|findutils|gawk|grep|gzip|m4|make|patch|sed|tar|texinfo|xz)
			# 5.1.3 dejagnu, "make check" after "make install", different?
			make_check="make check"
			;;&
		binutils)
			echo "compiling binutils, pass 1, 1 SBU, 3 min on i5-4200U"
			conf_argu="--prefix=/tools --with-sysroot=$LFS --with-lib-path=/tools/lib --target=$LFS_TGT --disable-nls --disable-werror"
			configure=../configure
			;;
		gcc)
			echo "compiling gcc, pass 1, 8.3 SBU"
			conf_argu="--target=$LFS_TGT --prefix=/tools --with-glibc-version=2.11 --with-sysroot=$LFS --with-newlib --without-headers --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --disable-nls --disable-shared --disable-multilib --disable-decimal-float --disable-threads --disable-libatomic --disable-libgomp --disable-libmpx --disable-libquadmath --disable-libssp --disable-libvtv --disable-libstdcxx --enable-languages=c,c++"
			configure=../configure
			;;
		linux)
			echo "compiling headers, <0.1 SBU"
			conf_argu=""
			configure="echo I don't need configure..."
			make="make mrproper"
			make_install="make INSTALL_HDR_PATH=dest headers_install"
			;;
		glibc)
			echo "compiling glibc, 4 SBU"
			conf_argu="--prefix=/tools --host=$LFS_TGT --build=$(../scripts/config.guess) --enable-kernel=2.6.32 --with-headers=/tools/include libc_cv_forced_unwind=yes libc_cv_c_cleanup=yes"
			configure=../configure
			;;
		gcc_p3)
			echo "compiling libstdc++, 0.4 SBU"
			conf_argu="--host=$LFS_TGT --prefix=/tools --disable-multilib --disable-nls --disable-libstdcxx-threads --disable-libstdcxx-pch --with-gxx-include-dir=/tools/$LFS_TGT/include/c++/6.2.0"
			configure=../libstdc++-v3/configure
			;;
		binutils_p2)
			echo "compiling binutils, pass 2, 1.1 SBU"
			conf_argu="--prefix=/tools --disable-nls   --disable-werror --with-lib-path=/tools/lib --with-sysroot"
			configure="eval CC=$LFS_TGT-gcc AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib ../configure"
			;;
		gcc_p2)
			echo "compiling gcc, pass 2, 11 SBU"
			conf_argu="--prefix=/tools --with-local-prefix=/tools --with-native-system-header-dir=/tools/include --enable-languages=c,c++ --disable-libstdcxx-pch --disable-multilib --disable-bootstrap --disable-libgomp"
			configure="eval CC=$LFS_TGT-gcc CXX=$LFS_TGT-g++ AR=$LFS_TGT-ar RANLIB=$LFS_TGT-ranlib ../configure"
			cat gcc/limitx.h gcc/glimits.h gcc/limity.h > `dirname $($LFS_TGT-gcc -print-libgcc-file-name)`/include-fixed/limits.h
			;;
		tcl)
			echo "compiling tcl, 0.4 SBU"
			conf_argu="--prefix=/tools"
			cd unix
			make_check="eval TZ=UTC make test"
			;;
		expect)
			echo "compiling expect, 0.1 SBU"
			conf_argu="--prefix=/tools --with-tcl=/tools/lib --with-tclinclude=/tools/include"
			cp -v configure{,.orig}
			sed 's:/usr/local/bin:/bin:' configure.orig > configure
			make_check="make test"
			make_install="make SCRIPTS='' install"
			;;
		dejagnu)
			echo "compiling dejagnu, <0.1 SBU"
			conf_argu="--prefix=/tools"
			make="echo I don't need make..."
			;;
		check)
			echo "compiling check, 0.1 SBU"
			conf_argu="--prefix=/tools"
			configure="eval PKG_CONFIG= ./configure"
			;;
		ncurses)
			echo "compiling ncurses, 0.5 SBU"
			conf_argu="--prefix=/tools --with-shared --without-debug --without-ada --enable-widec --enable-overwrite"
			sed -i s/mawk// configure
			;;
		bash)
			echo "compiling bash, 0.4 SBU"
			conf_argu="--prefix=/tools --without-bash-malloc"
			make_check="make tests"
			;;
		bzip2)
			echo "compiling bzip2, <0.1 SBU"
			conf_argu=""
			configure="echo I don't need configure..."
			make_install="make PREFIX=/tools install"
			;;
		coreutils)
			echo "compiling coreutils, 0.6 SBU"
			conf_argu="--prefix=/tools --enable-install-program=hostname"
			make_check="make RUN_EXPENSIVE_TESTS=yes check"
			;;
		diffutils)
			echo "compiling diffutils, 0.2 SBU"
			conf_argu="--prefix=/tools"
			;;
		file)
			echo "compiling file, 0.1 SBU"
			conf_argu="--prefix=/tools"
			;;
		findutils)
			echo "compiling findutils, 0.3 SBU"
			conf_argu="--prefix=/tools"
			;;
		gawk)
			echo "compiling gawk, 0.2 SBU"
			conf_argu="--prefix=/tools"
			;;
		gettext)
			echo "compiling gettext, 0.9 SBU"
			conf_argu="--prefix=/tools --disable-shared"
			cd gettext-tools
			EMACS="no" $configure $conf_argu; report $jj configure
			make -C gnulib-lib
			make -C intl pluralx.c
			make -C src msgfmt
			make -C src msgmerge
			make -C src xgettext
			cp -v src/{msgfmt,msgmerge,xgettext} /tools/bin
			return
			;;
		grep)
			echo "compiling grep, 0.2 SBU"
			conf_argu="--prefix=/tools"
			;;
		gzip)
			echo "compiling gzip, 0.1 SBU"
			conf_argu="--prefix=/tools"
			;;
		m4)
			echo "compiling m4, 0.2 SBU"
			conf_argu="--prefix=/tools"
			;;
		make)
			echo "compiling make, 0.1 SBU"
			conf_argu="--prefix=/tools --without-guile"
			;;
		patch)
			echo "compiling patch, 0.2 SBU"
			conf_argu="--prefix=/tools"
			;;
		perl)
			echo "compiling perl, 1.3 SBU"
			conf_argu=""
			sh Configure -des -Dprefix=/tools -Dlibs=-lm
			make; report $jj make
			cp -v perl cpan/podlators/scripts/pod2man /tools/bin
			mkdir -pv /tools/lib/perl5/5.24.0
			cp -Rv lib/* /tools/lib/perl5/5.24.0
			return
			;;
		sed)
			echo "compiling sed, 0.1 SBU"
			conf_argu="--prefix=/tools"
			;;
		tar)
			echo "compiling tar, 0.3 SBU"
			conf_argu="--prefix=/tools"
			;;
		texinfo)
			echo "compiling texinfo, 0.2 SBU"
			conf_argu="--prefix=/tools"
			;;
		util-linux)
			echo "compiling util-linux, 0.8 SBU"
			conf_argu="--prefix=/tools --without-python --disable-makeinstall-chown --without-systemdsystemunitdir PKG_CONFIG=''"
			;;
		xz)
			echo "compiling xz, 0.2 SBU"
			conf_argu="--prefix=/tools"
			;;
	esac

	case $j in
		binutils|gcc|glibc)
			# binutils binutils_p2 gcc gcc_p2 gcc_3 glibc, so use $j
			rm build -rf; mkdir build; cd build
			;;
	esac

	$configure $conf_argu; report $jj configure

	$make; report $jj make

	#$make_check; report $jj make-check

	# something need to do after make but before make install
	case $jj in
		binutils)
			[ `uname -m` == "x86_64" ] && mkdir -p /tools/lib && ln -sf lib /tools/lib64
			;;
	esac

	$make_install; report $jj make-install

	# something need to do after make install
	case $jj in
		linux)
			cp -r dest/include/* /tools/include
			;;
		binutils_p2)
			make -C ld clean
			make -C ld LIB_PATH=/usr/lib:/lib
			cp -v ld/ld-new /tools/bin
			;;
		gcc_p2)
			ln -sf gcc /tools/bin/cc
			;;
		tcl)
			chmod -v u+w /tools/lib/libtcl8.6.so
			make install-private-headers
			ln -sf tclsh8.6 /tools/bin/tclsh
			;;
		bash)
			ln -sf bash /tools/bin/sh
			;;
	esac

	tree -I sources $LFS > $LFS/sources/dir_tree_after_$jj
}

stripping(){
	strip --strip-debug /tools/lib/*
	/usr/bin/strip --strip-unneeded /tools/{,s}bin/*
	rm -rf /tools/{,share}/{info,man,doc}
}

##### Chapter 6. Installing Basic System Software
# 6.2.Preparing Virtual Kernel File Systems
virtualfs(){
	mkdir -pv $LFS/{dev,proc,sys,run}
	# 6.2.1. Creating Initial Device Nodes
	sudo mknod -m 600 $LFS/dev/console c 5 1
	sudo mknod -m 666 $LFS/dev/null c 1 3
	# 6.2.2. Mounting and Populating /dev
	sudo mount -v --bind /dev $LFS/dev
	# 6.2.3. Mounting Virtual Kernel File Systems
	sudo mount -vt devpts devpts $LFS/dev/pts -o gid=5,mode=620
	sudo mount -vt proc proc $LFS/proc
	sudo mount -vt sysfs sysfs $LFS/sys
	sudo mount -vt tmpfs tmpfs $LFS/run

	if [ -h $LFS/dev/shm ]; then
		mkdir -pv $LFS/$(readlink $LFS/dev/shm)
	fi
}

# 6.3. Package Management
linkpackmanage(){
	# 6.3.2. Package Management Techniques
	./configure --prefix=/usr/pkg/libfoo/1.1
	make
	make install

	./configure --prefix=/usr
	make
	make DESTDIR=/usr/pkg/libfoo/1.1 install
}


# 6.4. Entering the Chroot Environment
nowletschroot(){
	echo "going to chroot, password needed"
	sudo chroot "$LFS" /tools/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin /tools/bin/bash --login +h
}

# use bash installed in 6.33
chrootnew(){
	echo "going to chroot, password needed"
	sudo chroot "$LFS" /tools/bin/env -i HOME=/root TERM="$TERM" PS1='\u:\w\$ ' PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin /bin/bash --login +h
}
############### Main Part ###############


case $1 in
	-d)
		downloadpacks
		;;
	-c)
		check_host_env
		;;
	-s)
		stripping
		;;
	-v)
		virtualfs
		;;
	-r)
		nowletschroot
		;;
	-rr)
		chrootnew
		;;
	"")
		check_host_env
		temptooldir
		for i in $tmptools
		do
			extract_compile $i
		done
		;;
	*)
		extract_compile $1
		;;
esac
