#!/bin/bash

echo "🔧 Fixing database connection issue..."

# Backup original files
cp src/main/resources/application.yml src/main/resources/application.yml.backup
cp src/main/java/com/achpaudel/api/AchPaudelApiApplication.java src/main/java/com/achpaudel/api/AchPaudelApiApplication.java.backup

# Create temporary application.yml without database
cat > src/main/resources/application.yml << 'YAML_EOF'
server:
  port: 8080
  servlet:
    context-path: /api

spring:
  application:
    name: achpaudel-api
  
  # Temporarily disable JPA to avoid database connection issues
  autoconfigure:
    exclude:
      - org.springframework.boot.autoconfigure.jdbc.DataSourceAutoConfiguration
      - org.springframework.boot.autoconfigure.orm.jpa.HibernateJpaAutoConfiguration
        
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
        include: health,info,metrics,prometheus
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

# Update main application class
cat > src/main/java/com/achpaudel/api/AchPaudelApiApplication.java << 'JAVA_EOF'
package com.achpaudel.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
public class AchPaudelApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(AchPaudelApiApplication.class, args);
    }
}
JAVA_EOF

echo "✅ Database issues fixed temporarily"
echo "📝 Your API will work without database until you whitelist the server IP in DreamHost"
