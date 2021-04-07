#!/bin/sh
if test -f "/boot/firmware/netplan.yaml"; then
   rm -fr /etc/netplan/*
   cp /boot/firmware/netplan.yaml /etc/netplan/50-cloud-init.yaml
   netplan apply
   rm /boot/firmware/netplan.yaml
fi
