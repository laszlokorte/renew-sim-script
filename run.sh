#!/usr/bin/env sh
XVBF='xvfb-run  -d '
XVBF=''

$XVBF java \
-Dlog4j.logger.simulation='DEBUG, SimFileLog, SimConLog' \
-Dde.renew.gui.autostart=false \
-Dde.renew.simulatorMode=-1 \
-Dde.renew.splashscreen.enabled=false \
 -p ./renew41:./renew41/libs -m de.renew.loader script ./sim-script