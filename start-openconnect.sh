#!/bin/sh
if [ -n "$OPENCONNECT_HOST" ]; then
  echo "starting openconnect juniper vpn...."
  echo "${OPENCONNECT_PASSWORD}" |  openconnect --juniper ${OPENCONNECT_HOST} -u ${OPENCONNECT_USER} --passwd-on-stdin --servercert ${OPENCONNECT_SERVER_CERT}
  echo "done."
fi
