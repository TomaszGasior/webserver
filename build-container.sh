#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

container_packages=(
    apache
    composer
    git
    mariadb
    php
    php-apcu
    php-fpm
    php-gd
    php-intl
    php-pgsql
    php-sqlite
    xdebug
)

extra_os_packages=(
    bash-completion
    bat
    p7zip
    sudo
    unzip
    wget
)

base_os_packages=(
    bash
    bzip2
    coreutils
    diffutils
    file
    filesystem
    findutils
    gawk
    gcc-libs
    gettext
    glibc
    grep
    gzip
    less
    licenses
    man-db
    nano
    pacman
    procps-ng
    sed
    shadow
    systemd
    systemd-sysvcompat
    tar
    which
)

container_name='webserver-'$(date +%Y-%m-%d-%H-%M-%S)
container_dir='/tmp/'$container_name

sudo mkdir $container_dir

sudo pacstrap -i -c -G -M $container_dir --noconfirm \
    ${base_os_packages[*]} ${extra_os_packages[*]} ${container_packages[*]}
sudo cp -Rn files/* $container_dir

sudo rm $container_dir/var/lib/pacman/sync/*
sudo reflector --latest 20 --sort rate --number 10 \
    --save $container_dir/etc/pacman.d/mirrorlist

sudo cp -Rn scripts $container_dir/opt
sudo systemd-nspawn -D $container_dir /bin/sh -c 'cat /opt/scripts/* | bash -x'
sudo rm -R $container_dir/opt/scripts

mkdir ./build || true
cd ./build
sudo tar --create --xz --file $container_name'.tar.xz' \
    --directory $container_dir --xattrs -v .
sudo cp ../webserver.nspawn $container_name'.nspawn'
sha256sum * > $container_name'.tar.xz.sha256'
cd ..

sudo rm -Rf $container_dir
