#!/bin/sh
export JAVA_HOME=/usr/lib/jvm/temurin-21-jdk-amd64
export CATALINA_PID=/opt/domisml/temp/tomcat.pid
export CLASSPATH=/opt/domisml/classes
JAVA_OPTS="$JAVA_OPTS -Xms512m -Xmx1024m"
JAVA_OPTS="$JAVA_OPTS -Dfile.encoding=UTF-8"
JAVA_OPTS="$JAVA_OPTS -Dsml.log.folder=/data/domisml/logs"
export JAVA_OPTS
