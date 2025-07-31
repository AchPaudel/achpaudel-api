#!/bin/bash

echo "🔍 Debugging nginx issues..."

echo "1. Checking nginx status:"
sudo systemctl status nginx

echo ""
echo "2. Checking if nginx is running:"
ps aux | grep nginx

echo ""
echo "3. Checking what's listening on port 80:"
sudo netstat -tlnp | grep :80

echo ""
echo "4. Testing nginx configuration:"
sudo nginx -t

echo ""
echo "5. Checking nginx error logs:"
sudo tail -20 /var/log/nginx/error.log

echo ""
echo "6. Checking if our site config exists:"
ls -la /etc/nginx/sites-available/api.achpaudel.dev
ls -la /etc/nginx/sites-enabled/api.achpaudel.dev

echo ""
echo "🔧 Attempting to fix nginx..."

# Stop nginx
sudo systemctl stop nginx

# Kill any hanging nginx processes
sudo pkill -f nginx

# Start nginx fresh
sudo systemctl start nginx

# Enable nginx
sudo systemctl enable nginx

echo ""
echo "7. Checking nginx status after restart:"
sudo systemctl status nginx

echo ""
echo "8. Testing Spring Boot connection from nginx perspective:"
curl -v http://localhost:8090/api/v1/health

echo ""
echo "9. Testing if port 80 is now accessible:"
curl -v http://localhost:80/

