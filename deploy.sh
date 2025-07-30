#!/bin/bash

# Ach Paudel API Deployment Script
# This script builds and deploys the API to your server

echo "🚀 Starting Ach Paudel API Deployment..."

# Build the application
echo "📦 Building the application..."
mvn clean package -DskipTests

if [ $? -ne 0 ]; then
    echo "❌ Build failed!"
    exit 1
fi

echo "✅ Build completed successfully!"

# Check if JAR file exists
if [ ! -f "target/achpaudel-api-1.0.0.jar" ]; then
    echo "❌ JAR file not found!"
    exit 1
fi

echo "📋 JAR file created: target/achpaudel-api-1.0.0.jar"

# Create logs directory if it doesn't exist
mkdir -p logs

echo "🎯 Deployment ready!"
echo ""
echo "To deploy to your server:"
echo "1. Upload the JAR file to your server"
echo "2. Run: java -jar achpaudel-api-1.0.0.jar"
echo "3. The API will be available at: https://api.achpaudel.dev/api"
echo ""
echo "For production deployment, consider using:"
echo "- systemd service for auto-restart"
echo "- nginx as reverse proxy"
echo "- PM2 or similar process manager" 