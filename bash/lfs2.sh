#!/bin/bash
#
# handle all LFS jobs after chrooted, the part before chroot named lfs1.bin.sh can be found in same directory.
# some env
PATH=/bin:/usr/bin:/sbin:/usr/sbin:/tools/bin
export TZ='Asia/Shanghai' # or put it in glibc?
set +h
# export PATH # not necessary

############### Variables ###############
#systools="linux man-pages glibc zlib file binutils gmp mpfr mpc gcc bzip2 pkg-config ncurses attr acl libcap sed shadow psmisc iana-etc m4 bison flex grep readline bash bc libtool gdbm gperf expat inetutils perl XML-Parser intltool autoconf automake xz kmod gettext procps-ng e2fsprogs coreutils diffutils gawk findutils groff grub less gzip iproute2 kbd libpipeline make patch sysklogd sysvinit eudev util-linux man-db tar texinfo vim"
systools="diffutils gawk findutils groff grub less gzip iproute2 kbd libpipeline make patch sysklogd sysvinit eudev util-linux man-db tar texinfo vim"

############### Functions ###############

# 6.5. Creating Directories
create_lfs_dir_structure(){
	mkdir -pv /{bin,boot,etc/{opt,sysconfig},home,lib/firmware,mnt,opt}
	mkdir -pv /{media/{floppy,cdrom},sbin,srv,var}
	install -dv -m 0750 /root
	install -dv -m 1777 /tmp /var/tmp
	mkdir -pv /usr/{,local/}{bin,include,lib,sbin,src}
	mkdir -pv /usr/{,local/}share/{color,dict,doc,info,locale,man}
	mkdir -v  /usr/{,local/}share/{misc,terminfo,zoneinfo}
	mkdir -v  /usr/libexec
	mkdir -pv /usr/{,local/}share/man/man{1..8}

	case $(uname -m) in
		x86_64) ln -sv lib /lib64
			ln -sv lib /usr/lib64
			ln -sv lib /usr/local/lib64 ;;
	esac

	mkdir -v /var/{log,mail,spool}
	ln -sv /run /var/run
	ln -sv /run/lock /var/lock
	mkdir -pv /var/{opt,cache,lib/{color,misc,locate},local}
}

# 6.6. Creating Essential Files and Symlinks
create_lfs_essential_files(){
	ln -sv /tools/bin/{bash,cat,echo,pwd,stty} /bin
	ln -sv /tools/bin/perl /usr/bin
	ln -sv /tools/lib/libgcc_s.so{,.1} /usr/lib
	ln -sv /tools/lib/libstdc++.so{,.6} /usr/lib
	sed 's/tools/usr/' /tools/lib/libstdc++.la > /usr/lib/libstdc++.la
	ln -sv bash /bin/sh

	ln -sv /proc/self/mounts /etc/mtab

	cat > /etc/passwd << "EOF"
root:x:0:0:root:/root:/bin/bash
bin:x:1:1:bin:/dev/null:/bin/false
daemon:x:6:6:Daemon User:/dev/null:/bin/false
messagebus:x:18:18:D-Bus Message Daemon User:/var/run/dbus:/bin/false
nobody:x:99:99:Unprivileged User:/dev/null:/bin/false
EOF

	cat > /etc/group << "EOF"
root:x:0:
bin:x:1:daemon
sys:x:2:
kmem:x:3:
tape:x:4:
tty:x:5:
daemon:x:6:
floppy:x:7:
disk:x:8:
lp:x:9:
dialout:x:10:
audio:x:11:
video:x:12:
utmp:x:13:
usb:x:14:
cdrom:x:15:
adm:x:16:
messagebus:x:18:
systemd-journal:x:23:
input:x:24:
mail:x:34:
nogroup:x:99:
users:x:999:
EOF

	# exec /tools/bin/bash --login +h

	touch /var/log/{btmp,lastlog,faillog,wtmp}
	chgrp -v utmp /var/log/lastlog
	chmod -v 664  /var/log/lastlog
	chmod -v 600  /var/log/btmp

}

# called by extract_compile(), log configure, make and make install status code
report(){
	if [ "$?" == "0" ]; then
		echo `date +"%b %d %T"` $1 $2 complete! | tee -a /sources/log2
	else
		echo `date +"%b %d %T"` $1 $2 have some problem!!! | tee -a /sources/log2
	fi
	read -p "shall we continue? [Y/n]" i
	[ "$i" == "n" -o "$i" == "N" ] && exit
}

# 6.10. Adjusting the Toolchain
adjust_toolchain(){
	mv -v /tools/bin/{ld,ld-old}
	mv -v /tools/$(uname -m)-pc-linux-gnu/bin/{ld,ld-old}
	mv -v /tools/bin/{ld-new,ld}
	ln -sv /tools/bin/ld /tools/$(uname -m)-pc-linux-gnu/bin/ld

	gcc -dumpspecs | sed -e 's@/tools@@g' -e '/\*startfile_prefix_spec:/{n;s@.*@/usr/lib/ @}' -e '/\*cpp:/{n;s@$@ -isystem /usr/include@}' > `dirname $(gcc --print-libgcc-file-name)`/specs
	# sanity checks
	echo 'int main(){}' > dummy.c
	cc dummy.c -v -Wl,--verbose &> dummy.log
	readelf -l a.out | grep ': /lib'
	grep -o '/usr/lib.*/crt[1in].*succeeded' dummy.log
	grep -B1 '^ /usr/include' dummy.log
	grep 'SEARCH.*/usr/lib' dummy.log |sed 's|; |\n|g'
	grep "/lib.*/libc.so.6 " dummy.log
	grep found dummy.log
	rm -v dummy.c a.out dummy.log
}

# the main compile procedure
extract_compile(){
	cd /sources
	jj=$1
	conf_argu= configure="./configure" make="make" make_check="make check" make_install="make install"
	rm $jj*/ -rf
	tar xf $jj*tar*
	cd $jj*/

	case $jj in
		linux|man-pages|bzip2|libcap|iana-etc|perl|XML-Parser|iproute2|sysklogd|sysvinit)
			configure="echo I don't need configure..."
			;;&
		linux|man-pages|bzip2|ncurses|acl|libcap|shadow|psmisc|iana-etc|bison|readline|bash|bc|kmod|groff|grub|less|iproute2|sysklogd|sysvinit)
			make_check="echo I don't need check..."
			;;&
		linux)
			echo "compiling linux headers, < 0.1 SBU"
			conf_argu=""
			make="make mrproper"
			make_install="make INSTALL_HDR_PATH=dest headers_install"
			;;
		man-pages)
			echo "compiling man-pages, < 0.1 SBU"
			conf_argu=""
			make="echo I don't need make..."
			;;
		glibc)
			echo "compiling glibc, 17 SBU"
			conf_argu="--prefix=/usr --enable-kernel=2.6.32 --enable-obsolete-rpc"
			configure=../configure 
			patch -Np1 -i ../glibc-2.24-fhs-1.patch
			;;
		zlib)
			echo "compiling zlib, SBU"
			conf_argu="--prefix=/usr"
			;;
		file)
			echo "compiling file, SBU"
			conf_argu="--prefix=/usr"
			;;
		binutils)
			echo "compiling binutils, SBU"
			conf_argu="--prefix=/usr --enable-shared --disable-werror"
			configure=../configure 
			expect -c "spawn ls"
			make="make tooldir=/usr"
			make_check="make -k check"
			make_install="make tooldir=/usr install"
			;;
		gmp)
			echo "compiling gmp, SBU"
			conf_argu="--prefix=/usr --enable-cxx --disable-static --docdir=/usr/share/doc/gmp-6.1.1"
			make_check="echo I had a exclusive check..."
			;;
		mpfr)
			echo "compiling mpfr, SBU"
			conf_argu="--prefix=/usr --disable-static --enable-thread-safe --docdir=/usr/share/doc/mpfr-3.1.4"
			;;
		mpc)
			echo "compiling mpc, 0.3 SBU"
			conf_argu="--prefix=/usr --disable-static --docdir=/usr/share/doc/mpc-1.0.3"
			;;
		gcc)
			echo "compiling gcc, 79 SBU(with tests)"
			conf_argu="--prefix=/usr --enable-languages=c,c++ --disable-multilib --disable-bootstrap --with-system-zlib"
			configure="eval SED=sed ../configure"
			make_check="make -k check"
			;;
		bzip2)
			echo "compiling bzip2, SBU"
			conf_argu=""
			patch -Np1 -i ../bzip2-1.0.6-install_docs-1.patch
			sed -i 's@\(ln -s -f \)$(PREFIX)/bin/@\1@' Makefile
			sed -i "s@(PREFIX)/man@(PREFIX)/share/man@g" Makefile
			make -f Makefile-libbz2_so
			make clean
			make_install="make PREFIX=/usr install"
			;;
		pkg-config)
			echo "compiling pkg-config, SBU"
			conf_argu="--prefix=/usr --with-internal-glib --disable-compile-warnings --disable-host-tool --docdir=/usr/share/doc/pkg-config-0.29.1"
			;;
		ncurses)
			echo "compiling ncurses, SBU"
			conf_argu="--prefix=/usr --mandir=/usr/share/man --with-shared --without-debug --without-normal --enable-pc-files --enable-widec"
			sed -i '/LIBTOOL_INSTALL/d' c++/Makefile.in
			;;
		attr)
			echo "compiling attr, SBU"
			conf_argu="--prefix=/usr --bindir=/bin --disable-static"
			make_check="make -j1 tests root-tests"
			sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
			sed -i -e "/SUBDIRS/s|man[25]||g" man/Makefile
			make_install="make install install-dev install-lib"
			;;
		acl)
			echo "compiling acl, SBU"
			conf_argu="--prefix=/usr --bindir=/bin --disable-static --libexecdir=/usr/lib"
			sed -i -e 's|/@pkg_name@|&-@pkg_version@|' include/builddefs.in
			sed -i "s:| sed.*::g" test/{sbits-restore,cp,misc}.test
			sed -i -e "/TABS-1;/a if (x > (TABS-1)) x = (TABS-1);" libacl/__acl_to_any_text.c
			make_install="make install install-dev install-lib"
			;;
		libcap)
			echo "compiling libcap, SBU"
			conf_argu=""
			sed -i '/install.*STALIBNAME/d' libcap/Makefile
			make_install="make RAISE_SETFCAP=no prefix=/usr install"
			;;
		sed)
			echo "compiling sed, SBU"
			conf_argu="--prefix=/usr --bindir=/bin --htmldir=/usr/share/doc/sed-4.2.2"
			;;
		shadow)
			echo "compiling shadow, SBU"
			conf_argu="--sysconfdir=/etc --with-group-name-max-length=32"
			sed -i 's/groups$(EXEEXT) //' src/Makefile.in
			find man -name Makefile.in -exec sed -i 's/groups\.1 / /'   {} \;
			find man -name Makefile.in -exec sed -i 's/getspnam\.3 / /' {} \;
			find man -name Makefile.in -exec sed -i 's/passwd\.5 / /'   {} \;
			sed -i -e 's@#ENCRYPT_METHOD DES@ENCRYPT_METHOD SHA512@' -e 's@/var/spool/mail@/var/mail@' etc/login.defs
			# sed -i 's@DICTPATH.*@DICTPATH\t/lib/cracklib/pw_dict@' etc/login.defs
			sed -i 's/1000/999/' etc/useradd
			;;
		psmisc)
			echo "compiling psmisc, SBU"
			conf_argu="--prefix=/usr"
			;;
		iana-etc)
			echo "compiling iana-etc, SBU"
			conf_argu=""
			;;
		m4)
			echo "compiling m4, SBU"
			conf_argu="--prefix=/usr"
			;;
		bison)
			echo "compiling bison, SBU"
			conf_argu="--prefix=/usr --docdir=/usr/share/doc/bison-3.0.4"
			;;
		flex)
			echo "compiling flex, SBU"
			conf_argu="--prefix=/usr --docdir=/usr/share/doc/flex-2.6.1"
			;;
		grep)
			echo "compiling grep, SBU"
			conf_argu="--prefix=/usr --bindir=/bin"
			;;
		readline)
			echo "compiling readline, SBU"
			conf_argu="--prefix=/usr --disable-static --docdir=/usr/share/doc/readline-6.3"
			patch -Np1 -i ../readline-6.3-upstream_fixes-3.patch
			sed -i '/MV.*old/d' Makefile.in
			sed -i '/{OLDSUFF}/c:' support/shlib-install
			make="make SHLIB_LIBS=-lncurses"
			make_install="make SHLIB_LIBS=-lncurses install"
			;;
		bash)
			echo "compiling bash, SBU"
			conf_argu="--prefix=/usr --docdir=/usr/share/doc/bash-4.3.30 --without-bash-malloc --with-installed-readline"
			patch -Np1 -i ../bash-4.3.30-upstream_fixes-3.patch
			;;
		bc)
			echo "compiling bc, SBU"
			conf_argu="--prefix=/usr --with-readline --mandir=/usr/share/man --infodir=/usr/share/info"
			patch -Np1 -i ../bc-1.06.95-memory_leak-1.patch
			;;
		libtool)
			echo "compiling libtool, SBU"
			conf_argu="--prefix=/usr"
			;;
		gdbm)
			echo "compiling gdbm, SBU"
			conf_argu="-prefix=/usr --disable-static --enable-libgdbm-compat"
			;;
		gperf)
			echo "compiling gperf, SBU"
			conf_argu="--prefix=/usr --docdir=/usr/share/doc/gperf-3.0.4"
			make_check="make -j1 check"
			;;
		expat)
			echo "compiling expat, SBU"
			conf_argu="--prefix=/usr --disable-static"
			;;
		inetutils)
			echo "compiling inetutils, SBU"
			conf_argu="--prefix=/usr --localstatedir=/var --disable-logger --disable-whois --disable-rcp --disable-rexec --disable-rlogin --disable-rsh --disable-servers"
			;;
		perl)
			echo "compiling perl, SBU"
			conf_argu=""
			make_check="make -k test"
			echo "127.0.0.1 localhost $(hostname)" > /etc/hosts
			export BUILD_ZLIB=False
			export BUILD_BZIP2=0
			sh Configure -des -Dprefix=/usr -Dvendorprefix=/usr -Dman1dir=/usr/share/man/man1 -Dman3dir=/usr/share/man/man3 -Dpager="/usr/bin/less -isR"  -Duseshrplib
			;;
		XML-Parser)
			echo "compiling XML::Parser, SBU"
			conf_argu=""
			make_check="make test"
			perl Makefile.PL
			;;
		intltool)
			echo "compiling intltool, SBU"
			conf_argu="--prefix=/usr"
			sed -i 's:\\\${:\\\$\\{:' intltool-update.in
			;;
		autoconf)
			echo "compiling autoconf, SBU"
			conf_argu="--prefix=/usr"
			;;
		automake)
			echo "compiling automake, SBU"
			conf_argu="--prefix=/usr --docdir=/usr/share/doc/automake-1.15"
			sed -i 's:/\\\${:/\\\$\\{:' bin/automake.in
			make_check="make -j4 check"
			;;
		xz)
			echo "compiling xz, SBU"
			conf_argu="--prefix=/usr --disable-static --docdir=/usr/share/doc/xz-5.2.2"
			sed -e '/mf\.buffer = NULL/a next->coder->mf.size = 0;' -i src/liblzma/lz/lz_encoder.c
			;;
		kmod)
			echo "compiling kmod, SBU"
			conf_argu="--prefix=/usr --bindir=/bin --sysconfdir=/etc --with-rootlibdir=/lib --with-xz --with-zlib"
			;;
		gettext)
			echo "compiling gettext, SBU"
			conf_argu="--prefix=/usr --disable-static --docdir=/usr/share/doc/gettext-0.19.8.1"
			;;
		procps-ng)
			echo "compiling procps, SBU"
			conf_argu="--prefix=/usr --exec-prefix= --libdir=/usr/lib --docdir=/usr/share/doc/procps-ng-3.3.12 --disable-static --disable-kill"
			;;
		e2fsprogs)
			echo "compiling e2fsprogs, SBU"
			conf_argu="--prefix=/usr --bindir=/bin --with-root-prefix="" --enable-elf-shlibs --disable-libblkid --disable-libuuid --disable-uuidd --disable-fsck"
			sed -i -e 's:\[\.-\]::' tests/filter.sed
			configure="eval LIBS=-L/tools/lib CFLAGS=-I/tools/include PKG_CONFIG_PATH=/tools/lib/pkgconfig ../configure"
			make_check="make LD_LIBRARY_PATH=/tools/lib check"
			;;	
		coreutils)
			echo "compiling coreutils, SBU"
			conf_argu="--prefix=/usr --enable-no-install-program=kill,uptime"
			patch -Np1 -i ../coreutils-8.25-i18n-2.patch
			configure="eval FORCE_UNSAFE_CONFIGURE=1 ./configure"
			make="eval FORCE_UNSAFE_CONFIGURE=1 make"
			make_check="make NON_ROOT_USERNAME=nobody check-root"
			;;
		diffutils)
			echo "compiling diffutils, SBU"
			conf_argu="--prefix=/usr"
			sed -i 's:= @mkdir_p@:= /bin/mkdir -p:' po/Makefile.in.in
			;;
		gawk)
			echo "compiling gawk, SBU"
			conf_argu="--prefix=/usr"
			;;
		findutils)
			echo "compiling findutils, SBU"
			conf_argu="--prefix=/usr --localstatedir=/var/lib/locate"
			;;
		groff)
			echo "compiling groff, SBU"
			conf_argu="--prefix=/usr"
			configure="eval PAGE=A4 ./configure"
			;;
		grub)
			echo "compiling grub, SBU"
			conf_argu="--prefix=/usr --sbindir=/sbin --sysconfdir=/etc --disable-efiemu --disable-werror"
			;;
		less)
			echo "compiling less, SBU"
			conf_argu="--prefix=/usr --sysconfdir=/etc"
			;;
		gzip)
			echo "compiling gzip, SBU"
			conf_argu="--prefix=/usr"
			;;
		iproute2)
			echo "compiling iproute2, SBU"
			conf_argu=""
			sed -i /ARPD/d Makefile
			sed -i 's/arpd.8//' man/man8/Makefile
			rm -v doc/arpd.sgml
			sed -i 's/m_ipt.o//' tc/Makefile
			make_install="make DOCDIR=/usr/share/doc/iproute2-4.7.0 install"
			;;
		kbd)
			echo "compiling kbd, SBU"
			conf_argu="--prefix=/usr --disable-vlock"
			configure="eval PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure"
			patch -Np1 -i ../kbd-2.0.3-backspace-1.patch
			sed -i 's/\(RESIZECONS_PROGS=\)yes/\1no/g' configure
			sed -i 's/resizecons.8 //' docs/man/man8/Makefile.in
			;;
		libpipeline)
			echo "compiling libpipeline, SBU"
			conf_argu="--prefix=/usr"
			configure="eval PKG_CONFIG_PATH=/tools/lib/pkgconfig ./configure"
			;;
		make)
			echo "compiling make, SBU"
			conf_argu="--prefix=/usr"
			;;
		patch)
			echo "compiling patch, SBU"
			conf_argu="--prefix=/usr"
			;;
		sysklogd)
			echo "compiling sysklogd, SBU"
			conf_argu=""
			sed -i '/Error loading kernel symbols/{n;n;d}' ksym_mod.c
			sed -i 's/union wait/int/' syslogd.c
			make_install="make BINDIR=/sbin install"
			;;
		sysvinit)
			echo "compiling sysvinit, SBU"
			conf_argu=""
			patch -Np1 -i ../sysvinit-2.88dsf-consolidated-1.patch
			make="make -C src"
			make_install="make -C src install"
			;;
		eudev)
			echo "compiling eudev, SBU"
			conf_argu="--prefix=/usr --bindir=/sbin --sbindir=/sbin --libdir=/usr/lib --sysconfdir=/etc --libexecdir=/lib --with-rootprefix= --with-rootlibdir=/lib --enable-manpages --disable-static --config-cache"
			sed -r -i 's|/usr(/bin/test)|\1|' test/udev-test.pl
			cat > config.cache << "EOF"
HAVE_BLKID=1
BLKID_LIBS="-lblkid"
BLKID_CFLAGS="-I/tools/include"
EOF
			make="eval LIBRARY_PATH=/tools/lib make"
			make_check="make LD_LIBRARY_PATH=/tools/lib check"
			make_install="make LD_LIBRARY_PATH=/tools/lib install"
			;;
		util-linux)
			echo "compiling util-linux, SBU"
			conf_argu="ADJTIME_PATH=/var/lib/hwclock/adjtime --docdir=/usr/share/doc/util-linux-2.28.1 --disable-chfn-chsh --disable-login --disable-nologin --disable-su --disable-setpriv --disable-runuser --disable-pylibmount --disable-static --without-python --without-systemd --without-systemdsystemunitdir"
			mkdir -pv /var/lib/hwclock
			make_check="echo I'll check later..."
			;;
		man-db)
			echo "compiling man-db, SBU"
			conf_argu="--prefix=/usr --docdir=/usr/share/doc/man-db-2.7.5 --sysconfdir=/etc --disable-setuid --with-browser=/usr/bin/lynx --with-vgrind=/usr/bin/vgrind --with-grap=/usr/bin/grap"
			;;
		tar)
			echo "compiling tar, SBU"
			conf_argu="--prefix=/usr --bindir=/bin"
			configure="eval FORCE_UNSAFE_CONFIGURE=1 ./configure"
			;;
		texinfo)
			echo "compiling texinfo, SBU"
			conf_argu="--prefix=/usr --disable-static"
			;;
		vim)
			echo "compiling vim, SBU"
			conf_argu="--prefix=/usr"
			echo '#define SYS_VIMRC_FILE "/etc/vimrc"' >> src/feature.h
			make_check="make -j1 test"
			;;
		lfs-bootscripts)
			echo "compiling lfs-bootscripts, SBU"
			conf_argu=
			configure=
			make=
			make_check=
			;;
	esac

	case $jj in
		glibc|binutils|gcc|e2fsprogs)
			rm build -rf; mkdir build; cd build
			;;
	esac

	$configure $conf_argu; report $jj configure

	$make; report $jj make

	case $jj in
		gcc)
			ulimit -s 32768
			;;
		gmp|mpfr|mpc|sed)
			make html
			;;
		automake)
			sed -i "s:./configure:LEXLIB=/usr/lib/libfl.a &:" t/lex-{clean,depend}-cxx.sh
			;;
		procps-ng)
			sed -i -r 's|(pmap_initname)\\\$|\1|' testsuite/pmap.test/pmap.exp
			;;
		e2fsprogs)
			ln -sfv /tools/lib/lib{blk,uu}id.so.1 lib
			;;
		eudev)
			mkdir -pv /lib/udev/rules.d
			mkdir -pv /etc/udev/rules.d
			;;
	esac

	$make_check; report $jj make-check

	# something need to do after make but before make install
	case $jj in
		glibc)
			touch /etc/ld.so.conf
			;;
		gmp)
			make check 2>&1 | tee gmp-check-log
			awk '/# PASS:/{total+=$3} ; END{print total}' gmp-check-log
			;;
		gcc)
			../contrib/test_summary
			;;
		bash)
			chown -Rv nobody .
			su nobody -s /bin/bash -c "PATH=$PATH make tests"
			;;
		bc)
			echo "quit" | ./bc/bc -l Test/checklib.b
			;;
		coreutils)
			echo "dummy:x:1000:nobody" >> /etc/group
			chown -Rv nobody .
			su nobody -s /bin/bash -c "PATH=$PATH make RUN_EXPENSIVE_TESTS=yes check"
			sed -i '/dummy/d' /etc/group
			;;
		util-linux)
			#bash tests/run.sh --srcdir=$PWD --builddir=$PWD
			chown -Rv nobody .
			su nobody -s /bin/bash -c "PATH=$PATH make -k check"
			;;
	esac

	$make_install; report $jj make-install

	# something need to do after make install
	case $jj in
		linux)
			find dest/include \( -name .install -o -name ..install.cmd \) -delete
			cp -rv dest/include/* /usr/include
			;;
		glibc)
			cp -v ../nscd/nscd.conf /etc/nscd.conf
			mkdir -pv /var/cache/nscd

			mkdir -pv /usr/lib/locale
			localedef -i cs_CZ -f UTF-8 cs_CZ.UTF-8
			localedef -i de_DE -f ISO-8859-1 de_DE
			localedef -i de_DE@euro -f ISO-8859-15 de_DE@euro
			localedef -i de_DE -f UTF-8 de_DE.UTF-8
			localedef -i en_GB -f UTF-8 en_GB.UTF-8
			localedef -i en_HK -f ISO-8859-1 en_HK
			localedef -i en_PH -f ISO-8859-1 en_PH
			localedef -i en_US -f ISO-8859-1 en_US
			localedef -i en_US -f UTF-8 en_US.UTF-8
			localedef -i es_MX -f ISO-8859-1 es_MX
			localedef -i fa_IR -f UTF-8 fa_IR
			localedef -i fr_FR -f ISO-8859-1 fr_FR
			localedef -i fr_FR@euro -f ISO-8859-15 fr_FR@euro
			localedef -i fr_FR -f UTF-8 fr_FR.UTF-8
			localedef -i it_IT -f ISO-8859-1 it_IT
			localedef -i it_IT -f UTF-8 it_IT.UTF-8
			localedef -i ja_JP -f EUC-JP ja_JP
			localedef -i ru_RU -f KOI8-R ru_RU.KOI8-R
			localedef -i ru_RU -f UTF-8 ru_RU.UTF-8
			localedef -i tr_TR -f UTF-8 tr_TR.UTF-8
			localedef -i zh_CN -f GB18030 zh_CN.GB18030

			make localedata/install-locales

			cat > /etc/nsswitch.conf << "EOF"
# Begin /etc/nsswitch.conf

passwd: files
group: files
shadow: files

hosts: files dns
networks: files

protocols: files
services: files
ethers: files
rpc: files

# End /etc/nsswitch.conf
EOF

			tar -xf ../../tzdata2016f.tar.gz

			ZONEINFO=/usr/share/zoneinfo
			mkdir -pv $ZONEINFO/{posix,right}

			for tz in etcetera southamerica northamerica europe africa antarctica asia australasia backward pacificnew systemv
			do
				zic -L /dev/null   -d $ZONEINFO       -y "sh yearistype.sh" ${tz}
				zic -L /dev/null   -d $ZONEINFO/posix -y "sh yearistype.sh" ${tz}
				zic -L leapseconds -d $ZONEINFO/right -y "sh yearistype.sh" ${tz}
			done

			cp -v zone.tab zone1970.tab iso3166.tab $ZONEINFO
			zic -d $ZONEINFO -p America/New_York
			unset ZONEINFO

			#tzselect
			#export TZ='Asia/Shanghai' # put it at beginning
			cp -v /usr/share/zoneinfo/$TZ /etc/localtime

			cat > /etc/ld.so.conf << "EOF"
# Begin /etc/ld.so.conf
/usr/local/lib
/opt/lib

EOF
			cat >> /etc/ld.so.conf << "EOF"
# Add an include directory
include /etc/ld.so.conf.d/*.conf

EOF
			mkdir -pv /etc/ld.so.conf.d

			adjust_toolchain
			;;
		zlib)
			mv -v /usr/lib/libz.so.* /lib
			ln -sfv ../../lib/$(readlink /usr/lib/libz.so) /usr/lib/libz.so
			;;
		gmp|mpfr|mpc)
			make install-html
			;;
		gcc)
			ln -sv ../usr/bin/cpp /lib
			ln -sv gcc /usr/bin/cc
			install -v -dm755 /usr/lib/bfd-plugins
			ln -sfv ../../libexec/gcc/$(gcc -dumpmachine)/6.2.0/liblto_plugin.so /usr/lib/bfd-plugins/
			# something more, see 6.17
			;;
		bzip2)
			cp -v bzip2-shared /bin/bzip2
			cp -av libbz2.so* /lib
			ln -sv ../../lib/libbz2.so.1.0 /usr/lib/libbz2.so
			rm -v /usr/bin/{bunzip2,bzcat,bzip2}
			ln -sv bzip2 /bin/bunzip2
			ln -sv bzip2 /bin/bzcat
			;;
		ncurses)
			mv -v /usr/lib/libncursesw.so.6* /lib
			ln -sfv ../../lib/$(readlink /usr/lib/libncursesw.so) /usr/lib/libncursesw.so
			for lib in ncurses form panel menu ; do
				rm -vf                    /usr/lib/lib${lib}.so
				echo "INPUT(-l${lib}w)" > /usr/lib/lib${lib}.so
				ln -sfv ${lib}w.pc        /usr/lib/pkgconfig/${lib}.pc
			done
			rm -vf                     /usr/lib/libcursesw.so
			echo "INPUT(-lncursesw)" > /usr/lib/libcursesw.so
			ln -sfv libncurses.so      /usr/lib/libcurses.so
			mkdir -v       /usr/share/doc/ncurses-6.0
			cp -v -R doc/* /usr/share/doc/ncurses-6.0
			# make distclean
			# ./configure --prefix=/usr --with-shared --without-normal --without-debug --without-cxx-binding --with-abi-version=5 
			# make sources libs
			# cp -av lib/lib*.so.5* /usr/lib
			;;
		attr)
			chmod -v 755 /usr/lib/libattr.so
			mv -v /usr/lib/libattr.so.* /lib
			ln -sfv ../../lib/$(readlink /usr/lib/libattr.so) /usr/lib/libattr.so
			;;
		acl)
			chmod -v 755 /usr/lib/libacl.so
			mv -v /usr/lib/libacl.so.* /lib
			ln -sfv ../../lib/$(readlink /usr/lib/libacl.so) /usr/lib/libacl.so
			;;
		libcap)
			chmod -v 755 /usr/lib/libcap.so
			mv -v /usr/lib/libcap.so.* /lib
			ln -sfv ../../lib/$(readlink /usr/lib/libcap.so) /usr/lib/libcap.so
			;;
		sed)
			make -C doc install-html
			;;
		shadow)
			mv -v /usr/bin/passwd /bin
			pwconv
			grpconv
			sed -i 's/yes/no/' /etc/default/useradd
			;;
		psmisc)
			mv -v /usr/bin/fuser   /bin
			mv -v /usr/bin/killall /bin
			;;
		flex)
			ln -sv flex /usr/bin/lex
			;;
		readline)
			mv -v /usr/lib/lib{readline,history}.so.* /lib
			ln -sfv ../../lib/$(readlink /usr/lib/libreadline.so) /usr/lib/libreadline.so
			ln -sfv ../../lib/$(readlink /usr/lib/libhistory.so ) /usr/lib/libhistory.so
			install -v -m644 doc/*.{ps,pdf,html,dvi} /usr/share/doc/readline-6.3
			;;
		bash)
			mv -vf /usr/bin/bash /bin
			#exec /bin/bash --login +h
			;;
		expat)
			install -v -dm755 /usr/share/doc/expat-2.2.0
			install -v -m644 doc/*.{html,png,css} /usr/share/doc/expat-2.2.0
			;;
		inetutils)
			mv -v /usr/bin/{hostname,ping,ping6,traceroute} /bin
			mv -v /usr/bin/ifconfig /sbin
			;;
		perl)
			unset BUILD_ZLIB BUILD_BZIP2
			;;
		intltool)
			install -v -Dm644 doc/I18N-HOWTO /usr/share/doc/intltool-0.51.0/I18N-HOWTO
			;;
		xz)
			mv -v   /usr/bin/{lzma,unlzma,lzcat,xz,unxz,xzcat} /bin
			mv -v /usr/lib/liblzma.so.* /lib
			ln -svf ../../lib/$(readlink /usr/lib/liblzma.so) /usr/lib/liblzma.so
			;;
		kmod)
			for target in depmod insmod lsmod modinfo modprobe rmmod; do
				ln -sfv ../bin/kmod /sbin/$target
			done
			ln -sfv kmod /bin/lsmod
			;;
		gettext)
			chmod -v 0755 /usr/lib/preloadable_libintl.so
			;;
		procps-ng)
			mv -v /usr/lib/libprocps.so.* /lib
			ln -sfv ../../lib/$(readlink /usr/lib/libprocps.so) /usr/lib/libprocps.so
			;;
		e2fsprogs)
			make install-libs
			chmod -v u+w /usr/lib/{libcom_err,libe2p,libext2fs,libss}.a
			gunzip -v /usr/share/info/libext2fs.info.gz
			install-info --dir-file=/usr/share/info/dir /usr/share/info/libext2fs.info
			makeinfo -o doc/com_err.info ../lib/et/com_err.texinfo
			install -v -m644 doc/com_err.info /usr/share/info
			install-info --dir-file=/usr/share/info/dir /usr/share/info/com_err.info
			;;
		coreutils)
			mv -v /usr/bin/{cat,chgrp,chmod,chown,cp,date,dd,df,echo} /bin
			mv -v /usr/bin/{false,ln,ls,mkdir,mknod,mv,pwd,rm} /bin
			mv -v /usr/bin/{rmdir,stty,sync,true,uname} /bin
			mv -v /usr/bin/chroot /usr/sbin
			mv -v /usr/share/man/man1/chroot.1 /usr/share/man/man8/chroot.8
			sed -i s/\"1\"/\"8\"/1 /usr/share/man/man8/chroot.8
			mv -v /usr/bin/{head,sleep,nice,test,[} /bin
			;;
		gawk)
			mkdir -v /usr/share/doc/gawk-4.1.3
			cp -v doc/{awkforai.txt,*.{eps,pdf,jpg}} /usr/share/doc/gawk-4.1.3
			;;
		findutils)
			mv -v /usr/bin/find /bin
			sed -i 's|find:=${BINDIR}|find:=/bin|' /usr/bin/updatedb
			;;
		gzip)
			mv -v /usr/bin/gzip /bin
			;;
		kbd)
			mkdir -v /usr/share/doc/kbd-2.0.3
			cp -R -v docs/doc/* /usr/share/doc/kbd-2.0.3
			;;
		sysklogd)
			cat > /etc/syslog.conf << "EOF"
# Begin /etc/syslog.conf

auth,authpriv.* -/var/log/auth.log
*.*;auth,authpriv.none -/var/log/sys.log
daemon.* -/var/log/daemon.log
kern.* -/var/log/kern.log
mail.* -/var/log/mail.log
user.* -/var/log/user.log
*.emerg *

# End /etc/syslog.conf
EOF
			;;
		eudev)
			tar -xvf ../udev-lfs-20140408.tar.bz2
			make -f udev-lfs-20140408/Makefile.lfs install
			LD_LIBRARY_PATH=/tools/lib udevadm hwdb --update
			;;
		man-db)
			sed -i "s:man root:root root:g" /usr/lib/tmpfiles.d/man-db.conf
			;;
		tar)
			make -C doc install-html docdir=/usr/share/doc/tar-1.29
			;;
		texinfo)
			make TEXMF=/usr/share/texmf install-tex
			pushd /usr/share/info
			rm -v dir
			for f in *
			do install-info $f dir 2>/dev/null
			done
			popd
			;;
		vim)
			ln -sv vim /usr/bin/vi
			for L in  /usr/share/man/{,*/}man1/vim.1; do
				ln -sv vim.1 $(dirname $L)/vi.1
			done
			ln -sv ../vim/vim74/doc /usr/share/doc/vim-7.4
			cat > /etc/vimrc << "EOF"
" Begin /etc/vimrc

set nocompatible
set backspace=2
syntax on
if (&term == "iterm") || (&term == "putty")
  set background=dark
endif

" End /etc/vimrc
EOF
			# vim -c ':options'
			;;
	esac
}


strip_again(){
	/tools/bin/find /usr/lib -type f -name \*.a \
		-exec /tools/bin/strip --strip-debug {} ';'

	/tools/bin/find /lib /usr/lib -type f -name \*.so* \
		-exec /tools/bin/strip --strip-unneeded {} ';'

	/tools/bin/find /{bin,sbin} /usr/{bin,sbin,libexec} -type f \
		-exec /tools/bin/strip --strip-all {} ';'
}

newbash(){
	exec /bin/bash --login +h
}
############### Main Part ###############
case $1 in
	-c)
		create_lfs_dir_structure
		create_lfs_essential_files
		;;
	-t)
		adjust_toolchain
		;;
	-r)
		newbash
		;;
	"")
		for i in $systools
		do
			extract_compile $i
		done
		;;
	*)
		extract_compile $1
		;;
esac
