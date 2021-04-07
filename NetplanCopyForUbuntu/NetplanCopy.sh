#!/bin/sh
if test -f "/boot/firmware/netplan.yaml"; then
   rm -fr /etc/netplan/*
   cp /boot/firmware/network-config /etc/netplan/50-cloud-init.yaml
   netplan apply
fi
