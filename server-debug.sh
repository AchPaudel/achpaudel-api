#!/bin/bash

echo "🔍 Checking what's running on port 8080..."
sudo netstat -tlnp | grep :8080

echo ""
echo "🔍 Checking all Java processes..."
ps aux | grep java

echo ""
echo "🔍 Checking our Spring Boot service status..."
sudo systemctl status achpaudel-api

echo ""
echo "�� Checking what process is actually serving on port 8080..."
curl -v http://localhost:8080/ 2>&1 | head -20

echo ""
echo "🔍 Checking if there are any Docker containers running..."
docker ps 2>/dev/null || echo "Docker not running or not accessible"

echo ""
echo "🔍 Looking for other web services..."
sudo systemctl status jenkins 2>/dev/null || echo "Jenkins not running"
sudo systemctl status apache2 2>/dev/null || echo "Apache not running"
sudo systemctl status tomcat* 2>/dev/null || echo "Tomcat not running"

