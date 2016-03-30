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
