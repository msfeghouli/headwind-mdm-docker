#!/bin/sh

# Start postgres
catalina.sh start
adb devices
#service postgresql restart
PSQL_CONNSTRING="postgresql://$SQL_USER:$SQL_PASS@$SQL_HOST:$SQL_PORT/$SQL_BASE"

# Create database if doesn't exist
if [ $HMDM_SQL_USER != 'hmdm' ]; then
    psql $PSQL_CONNSTRING -c "CREATE USER $HMDM_SQL_USER WITH PASSWORD '$HMDM_SQL_PASS';"
fi

if [ $HMDM_SQL_BASE != devices'hmdm' ]; then
    psql $PSQL_CONNSTRING -c "CREATE DATABASE $HMDM_SQL_BASE WITH OWNER=$HMDM_SQL_USER;"
fi

if [ ! -f '/usr/local/tomcat/conf/Catalina/localhost//hmdm.xml' ]; then
    cd /home/hmdmr/hmdm-install/
    ./hmdm_install.sh
fi

# Change the russian text in the dashboard to english

catalina.sh stop
sleep 30
cd ..
catalina.sh run