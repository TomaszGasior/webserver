#!/bin/bash

pacman-key --init
pacman-key --populate archlinux

pacman -Sy

sed -i /etc/pacman.conf \
    -e 's/#IgnorePkg   =/IgnorePkg   = linux linux-firmware/' \
    -e 's/^#\(Color\)/\1/'
