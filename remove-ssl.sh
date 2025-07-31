#!/bin/bash

echo "🔧 Removing SSL and setting up HTTP-only configuration..."

# Create HTTP-only nginx configuration
cat > nginx-http-only.conf << 'NGINX_EOF'
server {
    listen 80;
    server_name api.achpaudel.dev www.api.achpaudel.dev;

    # Proxy to Spring Boot Application on port 8090
    location / {
        proxy_pass http://localhost:8090;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
        
        # Timeout settings
        proxy_connect_timeout 30s;
        proxy_send_timeout 30s;
        proxy_read_timeout 30s;
        
        # Buffer settings
        proxy_buffering on;
        proxy_buffer_size 4k;
        proxy_buffers 8 4k;
    }

    # Health check endpoint
    location /health {
        proxy_pass http://localhost:8090/api/v1/health;
        access_log off;
    }

    # Logging
    access_log /var/log/nginx/api.achpaudel.dev.access.log;
    error_log /var/log/nginx/api.achpaudel.dev.error.log;
}
NGINX_EOF

echo "✅ Created HTTP-only nginx configuration"
echo ""
echo "📋 Upload and run this script on your server:"
echo "scp remove-ssl.sh nginx-http-only.conf ubuntu@api.achpaudel.dev:/tmp/"
echo "ssh ubuntu@api.achpaudel.dev 'chmod +x /tmp/remove-ssl.sh && sudo /tmp/remove-ssl.sh'"
