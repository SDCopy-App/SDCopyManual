#!/bin/sh

systemctl daemon-reload
rm $BootMountingPoint/ExecBoot.sh
exit 0;
