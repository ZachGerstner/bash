#!/bin/bash

#GLOBUS="globus-url-copy -vb -tcp-bs 2097152 -p 4 ftp://192.168.1.1:6080/users/zigers0/test1"
SOURCE=192.168.1.1
DEST=192.168.1.2
FILE="/users/zigers0/test1"
#change these
DATE=`date -u +%Y%m%d_%H:%M:%S`
OUT="$HOME/globus-wget-test/$DATE"
mkdir -p "$OUT"
LLOG="$OUT/local.log"

function log_local {
	echo "---$1---" >> "$LLOG"
	$1 >> "$LLOG" 2>&1
}

log_local "hostname -f"
log_local "date"
log_local "uptime"
log_local "who -b"
log_local "uname -a"
log_local "lsb_release -a"
log_local "cat /etc/hosts"
log_local "cat /etc/sysctl.conf"
log_local "sysctl -a"
log_local "/sbin/ip link"
log_local "/sbin/ip addr"
log_local "/sbin/ip route"
log_local "mount"
log_local "df -h"
log_local "ps aux"

for run in `seq 0 4`; do
	for trans in `seq 0 2`; do 
		globus-url-copy -vb -tcp-bs 2097152 -p 4 ftp://192.168.1.1/users/zigers0/test1 ./test1 >>g$run$trans.log 2>&1
		rm test1
		wget "$SOURCE/test1" ./test1 >>w$run$trans.log 2>&1
		rm test1
	done
done
	
