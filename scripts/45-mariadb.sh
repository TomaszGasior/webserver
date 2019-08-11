#!/bin/bash

mysql_install_db --user=mysql --basedir=/usr --datadir=/var/lib/mysql

mysqld_safe --nowatch
sleep 3
mysqladmin password '' --user root
mysqladmin shutdown
