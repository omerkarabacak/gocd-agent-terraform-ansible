#!/bin/sh
if [ -n "$OPENCONNECT_HOST" ]; then
  echo "starting openconnect juniper vpn...."
  echo "${OPENCONNECT_PASSWORD}" |  openconnect --juniper ${OPENCONNECT_HOST} --script=/etc/vpnc-script -u ${OPENCONNECT_USER} --passwd-on-stdin --servercert ${OPENCONNECT_SERVER_CERT}
  
  if [ -n "$DNS" ]; then
    cat "nameserver ${DNS}" >> /etc/resolv.conf
  fi

  echo "done."
fi
