#!/bin/sh

#################
# CONFIGURATION #
#################
JBOSS_PATH=/Users/chrisyoon/EAP-7.3.0	  # The path to the JBoss instance
IP_ADDR=127.0.0.1
PORT_OFFSET=0
#########################################################

# calculate new management port
# 
# JBOSS EAP 6.4 uses port 9999 for native management (management CLI)
# MGMT_PORT=`expr 9999 + $PORT_OFFSET`

MGMT_PORT=`expr 9990 + $PORT_OFFSET`
	
# Gracefully stops JBoss instance via management CLI interface.
stop(){
  echo "Stopping jboss..."
  sh $JBOSS_PATH/bin/jboss-cli.sh --connect controller=$IP_ADDR:$MGMT_PORT command=:shutdown
  if [ $? -ne 0 ]
    then echo "Failed to gracefully stop JBoss."
  fi
}

stop

exit 0