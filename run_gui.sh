#!/usr/bin/env sh
XVBF_BIN='xvfb-run'

if ! command -v $XVBF_BIN 2>&1 >/dev/null
RUN_CMD='xvfb-run  -d '
then
RUN_CMD=''
fi


$RUN_CMD java \
-Dde.renew.splashscreen.enabled='false' \
-Dde.renew.gui.autostart='true' \
-p ./renew41:./renew41/libs \
-m de.renew.loader \
gui