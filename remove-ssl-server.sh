#!/bin/bash

echo "🔧 Removing SSL configuration from server..."

# Backup current nginx configuration
sudo cp /etc/nginx/sites-available/api.achpaudel.dev /etc/nginx/sites-available/api.achpaudel.dev.backup.$(date +%Y%m%d_%H%M%S)

# Remove SSL site if it exists
sudo rm -f /etc/nginx/sites-enabled/api.achpaudel.dev

# Copy the HTTP-only configuration
sudo cp nginx-http-only.conf /etc/nginx/sites-available/api.achpaudel.dev

# Enable the HTTP-only site
sudo ln -sf /etc/nginx/sites-available/api.achpaudel.dev /etc/nginx/sites-enabled/

# Test nginx configuration
sudo nginx -t

if [ $? -eq 0 ]; then
    # Restart nginx
    sudo systemctl restart nginx
    echo "✅ SSL removed successfully!"
    echo "🌐 Your API is now available at: http://api.achpaudel.dev/api"
    
    # Test the endpoint
    echo ""
    echo "🧪 Testing HTTP endpoint..."
    curl -I http://api.achpaudel.dev/api/v1/health
else
    echo "❌ Nginx configuration test failed. Please check the configuration."
    echo "📋 You can restore the backup with:"
    echo "sudo cp /etc/nginx/sites-available/api.achpaudel.dev.backup.* /etc/nginx/sites-available/api.achpaudel.dev"
fi

# Show current nginx status
echo ""
echo "📋 Nginx status:"
sudo systemctl status nginx --no-pager -l

# Show enabled sites
echo ""
echo "📋 Enabled nginx sites:"
ls -la /etc/nginx/sites-enabled/
