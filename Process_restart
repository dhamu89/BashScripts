#!/bin/bash
echo -e "\e[31mScrit to restart the process if not running\e[0m"
echo "Type to find the process name:"
read process
if pidof $process > /dev/null
then
echo "service $process is running"
else
systemctl start $process && echo " $process Service started and it is running now"
fi
