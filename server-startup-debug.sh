#!/bin/bash

echo "🔍 Checking Spring Boot startup logs..."
sudo journalctl -u achpaudel-api --no-pager -n 50

echo ""
echo "🔍 Checking if port 8090 is available..."
sudo netstat -tlnp | grep :8090

echo ""
echo "🔍 Checking current service status..."
sudo systemctl status achpaudel-api --no-pager

echo ""
echo "🔍 Testing JAR file directly..."
cd /opt/achpaudel-api
sudo -u www-data java -jar achpaudel-api-1.0.0.jar --spring.profiles.active=production > /tmp/spring-debug.log 2>&1 &
sleep 10
kill $!
echo "Direct JAR execution log:"
cat /tmp/spring-debug.log

echo ""
echo "🔍 Checking Java version..."
java -version

echo ""
echo "🔍 Checking available memory..."
free -h

echo ""
echo "🔍 Checking disk space..."
df -h

