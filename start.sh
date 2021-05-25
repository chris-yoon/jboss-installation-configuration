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

start

exit 0