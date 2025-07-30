#!/bin/bash

echo "🔧 Removing SSL and configuring for HTTP..."

# Update application.yml to remove SSL and use HTTP
cat > src/main/resources/application.yml << 'YAML_EOF'
server:
  port: 8080
  servlet:
    context-path: /api

spring:
  application:
    name: achpaudel-api
  
  datasource:
    url: jdbc:mysql://ducksworth.iad1-mysql-e2-1b.dreamhost.com:3306/achpaudeldb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&requireSSL=false&verifyServerCertificate=false
    username: achpaudeldb
    password: kansasolathe
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 5
      minimum-idle: 2
      connection-timeout: 30000
      idle-timeout: 300000
      max-lifetime: 1800000
    
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: false
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect
        format_sql: false
        
  jackson:
    default-property-inclusion: non_null
    serialization:
      write-dates-as-timestamps: false
    deserialization:
      fail-on-unknown-properties: false

# Actuator Configuration for Monitoring
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics
      base-path: /actuator
  endpoint:
    health:
      show-details: always
    metrics:
      enabled: true

# Logging Configuration
logging:
  level:
    com.achpaudel: INFO
    org.springframework.web: INFO
    org.hibernate.SQL: INFO
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} - %msg%n"
    file: "%d{yyyy-MM-dd HH:mm:ss} [%thread] %-5level %logger{36} - %msg%n"
  file:
    name: logs/achpaudel-api.log

# Custom Application Properties
app:
  name: Ach Paudel API
  version: 1.0.0
  description: Personal API Server for Ach Paudel
YAML_EOF

# Update nginx configuration for HTTP only
cat > nginx.conf << 'NGINX_EOF'
server {
    listen 80;
    server_name api.achpaudel.dev;

    # Security Headers (basic)
    add_header X-Frame-Options DENY;
    add_header X-Content-Type-Options nosniff;
    add_header X-XSS-Protection "1; mode=block";

    # Proxy to Spring Boot Application
    location / {
        proxy_pass http://localhost:8080;
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
        proxy_pass http://localhost:8080/api/v1/health;
        access_log off;
    }

    # Logging
    access_log /var/log/nginx/api.achpaudel.dev.access.log;
    error_log /var/log/nginx/api.achpaudel.dev.error.log;
}
NGINX_EOF

echo "✅ SSL removed and HTTP configuration complete"
echo "🌐 Your API will be available at: http://api.achpaudel.dev/api"
