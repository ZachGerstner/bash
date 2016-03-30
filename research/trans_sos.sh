#!/bin/bash
#variables
CONTROLLER_IP=130.127.38.2
CONTROLLER_REST_PORT=8080
CONTROLLER_FLUSH_FLOWS="curl http://130.127.38.2:8080/wm/staticflowpusher/clear/all/json"
CLIENT=130.127.39.193 #NOT ON PUBLIC NETWORK
SERVER=155.101.29.73
PCONSET="curl http://$CONTROLLER_IP:$CONTROLLER_REST_PORT/wm/sos/config/json -X POST -d '{\"parallel-connections\":"
OUTPUT="}' | python -m json.tool"
BCONSET="curl http://$CONTROLLER_IP:$CONTROLLER_REST_PORT/sm/sos/config/json -X POST -d '{\"buffer-size\":"

#loging
DATE=`date -u %Y%m%d-%H:%M:%S`
OUTDIR="$HOME/$DATE"
mkdir -p "$OUTDIR"
LLOG="$OUTDIR/local.log"
RLOG="$OUTDIR/remote.log"


function log_local {
	echo "=== $1 ===" >> "$LLOG"
        $1 >> "$LLOG" 2>&1
 }
 
function log_remote {
       echo "=== $1 ===" >> "$RLOG"
       $1 >> "$RLOG" 2>&1
}

function log_both {
	log_local "$@"
	log_remote "$@"
}

log_both "hostname -f"
log_both "date"
log_both "uptime"
log_both "who -b"
log_both "uname -a"
log_both "lsb_release -a"
log_both "cat /etc/hosts"
log_both "cat /etc/sysctl.conf"
log_both "sysctl -a"
log_both "/sbin/ip link"
log_both "/sbin/ip addr"
log_both "/sbin/ip route"
log_both "mount"
log_both "df -h"
log_both "ps aux"
log_local "ping -c 10 $SERVER"
log_remote "ping -c 10 $CLIENT"

#transfer loop
for stream in `seq 5 7`;do
	#set stream number
	sstream=$stream * 1000
	i=$PCONSET$sstream$OUTPUT
	eval $i
		for buff in 30000 50000 60000;do
			#set buff size
			j=$BCONSET$buff$OUTPUT
			eval $j
				for run in `seq 1 3`;do
					wget http://$SERVER//home/rizard/test.tar
					rm -r test.tar
				done
		done
done

