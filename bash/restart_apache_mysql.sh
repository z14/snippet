#!/bin/bash
#
# vim:ft=sh

############### Variables ###############

############### Functions ###############

############### Main Part ###############

am(){
    local start_target httpd web_server mariadb stop_target fpm i
    mariadb=mariadb
    httpd=httpd
    stop_target=nginx
    case $ID in
        debian)
            pushd /etc/apache2/conf-enabled/
            fpm=$(echo php*)
            popd
            fpm=${fpm//.conf/}
            httpd=apache2
            mariadb=mysql
            ;;
        fedora)
            fpm=php-fpm
            ;;
    esac

    web_server=$httpd

    if [ "$1" = -n ]; then
        web_server=nginx
        stop_target=$httpd
    fi

    # WSL do have systemctl but not working, so test with a sub-command rather than `which systemctl`
    if systemctl list-jobs &> /dev/null; then
        sudo systemctl stop $stop_target
        sudo systemctl restart $web_server $mariadb $fpm
    else
        sudo service $stop_target stop
        sudo service $web_server stop
        sudo service $mariadb stop
        sudo service $web_server start
        sudo service $mariadb start
        for i in $fpm
        do
            sudo service $i stop
            sudo service $i start
        done
    fi
}
