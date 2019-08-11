#!/bin/bash

sed -i /etc/httpd/conf/httpd.conf \
    -e 's#/srv/http#/srv#' \
    -e 's/^#\(LoadModule .*mod_proxy.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_proxy_fcgi.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_vhost_alias.so\)/\1/' \
    -e 's/^#\(LoadModule .*mod_rewrite.so\)/\1/' \
    -e 's/AllowOverride None/AllowOverride All/'

echo "Include /etc/httpd/conf/extra/php-fpm.conf" >> /etc/httpd/conf/httpd.conf
echo "Include /etc/httpd/conf/extra/vhosts-srv.conf" >> /etc/httpd/conf/httpd.conf
