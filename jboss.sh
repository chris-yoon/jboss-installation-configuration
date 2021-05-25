#!/bin/sh

#################
# CONFIGURATION #
#################
JBOSS_PATH=/Users/chrisyoon/EAP-7.3.0	  # The path to the JBoss instance
IP_ADDR=172.30.1.43
PORT_OFFSET=0
#########################################################

# calculate new management port
MGMT_PORT=`expr 9990 + $PORT_OFFSET`
	
# Starts the JBoss instance.
# Redirects console log to /dev/null to avoid spamming the shell.
start(){
  echo "Starting jboss..."
  $JBOSS_PATH/bin/standalone.sh -Djboss.bind.address=$IP_ADDR -Djboss.bind.address.management=$IP_ADDR -Djboss.socket.binding.port-offset=$PORT_OFFSET> /dev/null 2>&1 &
}

# Gracefully stops JBoss instance via management CLI interface.
stop(){
  echo "Stopping jboss..."
  sh $JBOSS_PATH/bin/jboss-cli.sh --connect controller=$IP_ADDR:$MGMT_PORT command=:shutdown
  if [ $? -ne 0 ]
    then echo "Failed to gracefully stop JBoss."
  fi
}

# Restarts JBoss. Experimental.
restart(){
  stop
  if [ $? -ne 0 ]
    then
	echo "Killing Java processes..."
	# protect against any services that can't stop before we restart
	# (warning: this kills all Java instances running as current user)
	killall java
  fi
  start
}

# Tails JBoss log to console.
log(){
  echo "Tailing jboss log..."
  tail -f $JBOSS_PATH/standalone/log/server.log
}

# Cleans temp directories of JBoss.
clean(){
#  echo "Cleaning JBoss directory..."
#	echo "Deleting data.."
# rm -rf $JBOSS_PATH/standalone/data/content
#   echo "Deleting tmp.."
#   rm -rf $JBOSS_PATH/standalone/tmp/vfs
  echo "Success, please start JBoss again."
}

case "$1" in
 start)
   start
   ;;
 stop)
   stop
   ;;
 restart)
   restart
   ;;
 log)
   log
   ;;
 clean)
   stop
   if [ $? -eq 0 ]
     then clean
     else echo "Failed to stop JBoss. Cancel clean."
   fi
   ;;
 *)
   echo "JBoss Management Script"
   echo "[ip address $IP_ADDR]"
   echo "[port offset $PORT_OFFSET]"
   echo ""
   echo "Usage: jboss {start|stop|restart|log}"
   exit 1
esac

exit 0