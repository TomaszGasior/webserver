#!/bin/bash

sed -i /etc/php/php-fpm.d/www.conf \
    -e 's/user = http/user = user/' \
    -e 's/group = http/group = user/'
