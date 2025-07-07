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

{
    date;

    echo "User: $USER";

    echo -n "Hostname: ";
    hostname;
    echo;

    echo -n "Internal IP address: ";
    ifconfig | grep "inet " | grep -v "127.0.0.1" | awk '{print $2}';
    echo;

    echo -n "External IP address: ";
    curl -s https://ifconfig.me;
    echo;

    echo -n "Kernel name: ";
    uname;
    echo -n "Kernel version: ";
    uname -r;
    echo;

    echo -n "System uptime: ";
    uptime | awk -F ',' '{print $1}' | awk -F ' ' '{print $3}';
    echo;
} >> $FILENAME

USED_MEM=$( df -h / | tail -n 1 | awk '{print $3}' )
USED_MEM=${USED_MEM%Gi}
USED_MEM_GB=$(echo "$USED_MEM * 8.5899" | bc)
echo -n "Used memory: $USED_MEM_GB GB" >> $FILENAME

FREE_MEM=$( df -h / | tail -n 1 | awk '{print $4}' )
FREE_MEM=${FREE_MEM%Gi}
FREE_MEM_GB=$(echo "$FREE_MEM * 8.5899" | bc)
FREQ=$( grep "MHz" /proc/cpuinfo  | sed -n "1p" | awk -F ': ' '{print $2}' )

{
    echo -n ". Free space: $FREE_MEM_GB GB ";

    echo;
    free -h | sed -n "2p" | awk '{print "Total RAM:", $2, "; Free RAM:", $6}';

    echo;
    echo -n "Number of CPU Cores: ";
    nproc;

    echo -n "Frequency: $FREQ MHz";
    echo;
 } >> $FILENAME

