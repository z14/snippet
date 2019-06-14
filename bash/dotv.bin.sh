#!/bin/bash
#
# dotv

# Show version
function version(){
	echo "dotv 1.0 by Dot(dotcra@gmail.com) Aug 10, 2016"
	echo "More details on http://dotcra.com"
}

# Display help
function readme(){
	echo "\
Usage:
  dotv [username] [password]
  dotv [options]

Options:
  -c			connet vpn
  -d			disconnet vpn
  -s			show vpn interface info
  -g <gateway>		edit vpn gateway
  -u <username>		edit vpn username
  -b <string>		decode base64
  -h			display this help
  -v			display version information

Visit http://dotcra.com for more details."
}

function unknown_para(){
	echo dotv: invalid option: $1
	echo
	readme
	exit 1
}

# Get vpn connection name by awk and RE
# the nmcli output doesn't use tab(\t), so only -F "  "(double space) can be used to handle name included space
cid=$(nmcli connection show | awk -F "  " '/vpn/{print $1}')

function nmcli_conn(){
	# connect vpn
	nmcli c up "$cid"
}

function nmcli_dis(){
	# disconnect vpn
	nmcli connection down "$cid"
}

function nmcli_show(){
	# show vpn connection interface info
	nmcli connection show "$cid"
}

function nmcli_chgw(){
	# change vpn gateway
	nmcli c modify "$cid" +vpn.data "gateway = $1"
}

function nmcli_chuser(){
	# change vpn username
	nmcli c modify "$cid" +vpn.data "user = $1"
}

# function to register username
function reg(){
	# Check the username validity
 	if [[ $1 =~ ^[[:alnum:]_]*$ ]]; then
		echo "Registering username $1"

		# If no password given, set to 1111
		if [ -z "$2" ]; then
			passwd=1111
			echo "No password given, default 1111"
		else 
			echo "Passwd set to $2"
			passwd=$2
		fi

		# POST request by curl
		curl --data "username=$1&password1=$passwd&password2=$passwd&srvid=1&acceptterms=1&adduser=%200K%20" "http://user.tover.net/reg.php?cont=store_user"
		echo "Register Complete!  Try to change the vpn user."

		nmcli_chuser $1

	else
		echo "Invalid character"
		exit 2
 	fi
}
function debase64() {
	echo -n $1 | sed 's/\<thunder:\/\///' | base64 -d | sed 's/\<AA//' | sed 's/ZZ\>//'
	echo

}

function fnmcli(){
	case $1 in
		"-c" | "")
			nmcli_conn
			;;
		"-d")
			nmcli_dis
			;;
		"-s")
			nmcli_show
			;;
		"-g")
			nmcli_chgw $2
			;;
		"-u")
			nmcli_chuser $2
			;;
		"-b")
			debase64 $2
			;;
		"-h")
			readme
			;;
		"-v")
			version
			;;
		-?*)
			unknown_para $1
			;;
		*)
			reg $1 $2
			;;
	esac

}

fnmcli $1 $2
