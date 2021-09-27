#!/bin/sh

CATALINA_OPTS="$CATALINA_OPTS -javaagent:/pinpoint-agent/pinpoint-bootstrap-1.7.0-RC2.jar -Dpinpoint.agentId=xx-yy_GXB-GITLAB"
CATALINA_OPTS="$CATALINA_OPTS -Dpinpoint.applicationName=xx-yy"