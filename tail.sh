#!/bin/sh

#################
# CONFIGURATION #
#################
JBOSS_PATH=/Users/chrisyoon/EAP-7.3.0	  # The path to the JBoss instance
#########################################################

# Tails JBoss log to console.
log(){
  echo "Tailing jboss log..."
  tail -f $JBOSS_PATH/standalone/log/server.log
}

log

exit 0