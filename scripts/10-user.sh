#!/bin/bash

useradd --no-create-home --user-group user
passwd --delete user

chown -R user:user /home/user

passwd --delete root
