#!/bin/bash

echo "🔧 Updating database credentials..."

# Update application.yml with correct database credentials
cat > src/main/resources/application.yml << 'YAML_EOF'
server:
  port: 8090
  servlet:
    context-path: /api

spring:
  application:
    name: achpaudel-api
  
  profiles:
    active: default
  
  datasource:
    url: jdbc:mysql://ducksworth.iad1-mysql-e2-1b.dreamhost.com:3306/achpaudel_api?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC&requireSSL=false&verifyServerCertificate=false&autoReconnect=true
    username: api_achpaudel
    password: kansasolathe
    driver-class-name: com.mysql.cj.jdbc.Driver
    hikari:
      maximum-pool-size: 3
      minimum-idle: 1
      connection-timeout: 20000
      idle-timeout: 300000
      max-lifetime: 1200000
      connection-test-query: SELECT 1
    
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: false
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQLDialect
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
        include: health,info
      base-path: /actuator
  endpoint:
    health:
      show-details: when-authorized
  server:
    port: 8091

# Logging Configuration
logging:
  level:
    com.achpaudel: INFO
    org.springframework.web: WARN
    org.hibernate: WARN
    org.springframework.boot: INFO
    ROOT: WARN
  pattern:
    console: "%d{yyyy-MM-dd HH:mm:ss} - %msg%n"
  file:
    name: logs/achpaudel-api.log

# Custom Application Properties
app:
  name: Ach Paudel API
  version: 1.0.0
  description: Personal API Server for Ach Paudel
YAML_EOF

echo "✅ Database credentials updated!"
echo "📋 New database configuration:"
echo "   - Database: achpaudel_api"
echo "   - Username: api_achpaudel"
echo "   - Password: kansasolathe (unchanged)"
echo "   - DDL auto set back to 'update' to create tables"
