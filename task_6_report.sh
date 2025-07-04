#!/bin/bash

#Create script, that generates report file with following information:
# - current date and time;
#name of current user;
#internal IP address and hostname;
#external IP address;
#name and version of Linux distribution;
#system uptime;
#information about used and free space in / in GB;
#information about total and free RAM;
#number and frequency of CPU cores

FILENAME="report.txt"

if [[ ! -f "${FILENAME}" ]]; then
    touch "$FILENAME"
else
    : > $FILENAME
    echo "File $FILENAME already exists. File has been cleaned."
fi

date >> $FILENAME

echo "User: $USER" >> $FILENAME

echo -n "Hostname: " >> $FILENAME
hostname >> $FILENAME
echo  >> $FILENAME

echo -n "Internal IP address: " >> $FILENAME
ifconfig | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}' >> $FILENAME
echo >> $FILENAME

echo -n "External IP address: " >> $FILENAME
curl -s https://ifconfig.me >> $FILENAME
echo >> $FILENAME

echo -n "Kernel name: " >> $FILENAME
uname >> $FILENAME
echo -n "Kernel version: " >> $FILENAME
uname -r >> $FILENAME
echo >> $FILENAME

echo -n "System uptime: " >> $FILENAME
uptime | awk -F ',' '{print $1}' | awk -F ' ' '{print $3}' >> $FILENAME
echo >> $FILENAME

echo -n "Used: " >> $FILENAME
sed -n '7p' $( top ) | awk '{print $2}' >> $FILENAME
echo -n "and free: " >> $FILENAME
sed -n '7p' $( top ) | awk '{print $8}' >> $FILENAME
echo " memory." >> $FILENAME