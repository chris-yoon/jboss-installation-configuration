#!/bin/sh

#################
# CONFIGURATION #
#################
JBOSS_PATH=/Users/chrisyoon/EAP-7.3.0	  # The path to the JBoss instance
IP_ADDR=127.0.0.1
HTTP_PORT=8080
PORT_OFFSET=0
#########################################################

# Starts the JBoss instance.
# Redirects console log to /dev/null to avoid spamming the shell.
start(){
  echo "Starting jboss..."
  $JBOSS_PATH/bin/standalone.sh -Djboss.bind.address=$IP_ADDR -Djboss.bind.address.management=$IP_ADDR -Djboss.http.port=$HTTP_PORT -Djboss.socket.binding.port-offset=$PORT_OFFSET> /dev/null 2>&1 &
}

start

exit 0