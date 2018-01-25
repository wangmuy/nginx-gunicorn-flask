#!/bin/bash
echo "start_private.sh"
# pip conf
mkdir /home/$USER_NAME/.pip
cp /root/.pip/pip.conf /home/$USER_NAME/.pip/
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.pip

# pip cache
mkdir -p /home/$USER_NAME/.cache
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.cache

# conda conf
cp /root/.condarc /home/$USER_NAME/.condarc
chown -R $USER_NAME:$USER_NAME /home/$USER_NAME/.condarc