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


USED_MEM=$( df -h / | tail -n 1 | awk '{print $3}' )
USED_MEM=${USED_MEM%Gi}
USED_MEM_GB=$(echo "$USED_MEM * 8.5899" | bc)
echo -n "Used memory: $USED_MEM_GB GB" >> $FILENAME

FREE_MEM=$( df -h / | tail -n 1 | awk '{print $4}' )
FREE_MEM=${FREE_MEM%Gi}
FREE_MEM_GB=$(echo "$FREE_MEM * 8.5899" | bc)
echo -n ". Free space: $FREE_MEM_GB GB " >> $FILENAME

echo >> $FILENAME
free -h | sed -n "2p" | awk '{print "Total RAM:", $2, "; Free RAM:", $6}' >> $FILENAME

echo -n "Number of CPU Cores: " >> $FILENAME
nproc >> $FILENAME

echo -n ". Frequency: " >> $FILENAME
cat /proc/cpuinfo | grep "MHz" | sed -n "1p" | awk -F ': ' '{print $2}' >> $FILENAME
