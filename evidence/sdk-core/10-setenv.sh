#!/bin/sh
export JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
export CATALINA_PID=/opt/domismp/temp/tomcat.pid
JAVA_OPTS="$JAVA_OPTS -Xms1024m -Xmx2048m"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
export JAVA_OPTS
