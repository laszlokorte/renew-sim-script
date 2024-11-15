#!/usr/bin/env sh

set -e

XVBF_BIN='xvfb-run'

if ! command -v $XVBF_BIN 2>&1 >/dev/null
RUN_CMD='xvfb-run  -d '
then
RUN_CMD=''
fi


$RUN_CMD java \
-Dde.renew.splashscreen.enabled='false' \
-Dde.renew.gui.autostart='false' \
-Dde.renew.simulatorMode='-1' \
-Dlog4j.configuration=./log4j.properties \
-p ./renew41:./renew41/libs \
-m de.renew.loader \
script ./sim-script <&0 &

pid=$!

trap "echo 'Killing the background process with PID $pid'; kill $pid" EXIT

wait $pid