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