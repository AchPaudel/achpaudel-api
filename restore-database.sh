#!/bin/bash

echo "🔄 Restoring full database functionality..."

# Restore the original application.yml with database configuration
cat > src/main/resources/application.yml << 'YAML_EOF'
server:
  port: 8080
  servlet:
    context-path: /api

spring:
  application:
    name: achpaudel-api
  
  datasource:
    url: jdbc:mysql://ducksworth.iad1-mysql-e2-1b.dreamhost.com:3306/achpaudeldb?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
    username: achpaudeldb
    password: kansasolathe
    driver-class-name: com.mysql.cj.jdbc.Driver
    
  jpa:
    hibernate:
      ddl-auto: update
    show-sql: true
    properties:
      hibernate:
        dialect: org.hibernate.dialect.MySQL8Dialect
        format_sql: true
        
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
  metrics:
    export:
      prometheus:
        enabled: true

# Logging Configuration
logging:
  level:
    com.achpaudel: DEBUG
    org.springframework.web: DEBUG
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE
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

# Restore the main application class with JPA enabled
cat > src/main/java/com/achpaudel/api/AchPaudelApiApplication.java << 'JAVA_EOF'
package com.achpaudel.api;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.data.jpa.repository.config.EnableJpaRepositories;

@SpringBootApplication
@EnableJpaRepositories
public class AchPaudelApiApplication {

    public static void main(String[] args) {
        SpringApplication.run(AchPaudelApiApplication.class, args);
    }
}
JAVA_EOF

# Restore the full ProjectController with database functionality
cat > src/main/java/com/achpaudel/api/controller/ProjectController.java << 'JAVA_EOF'
package com.achpaudel.api.controller;

import com.achpaudel.api.dto.ApiResponse;
import com.achpaudel.api.model.Project;
import com.achpaudel.api.service.ProjectService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/v1/projects")
@CrossOrigin(origins = "*")
@RequiredArgsConstructor
public class ProjectController {
    
    private final ProjectService projectService;
    
    @GetMapping
    public ResponseEntity<ApiResponse> getAllProjects() {
        List<Project> projects = projectService.getAllProjects();
        return ResponseEntity.ok(ApiResponse.success("Projects retrieved successfully", projects));
    }
    
    @GetMapping("/{id}")
    public ResponseEntity<ApiResponse> getProjectById(@PathVariable Long id) {
        return projectService.getProjectById(id)
                .map(project -> ResponseEntity.ok(ApiResponse.success("Project retrieved successfully", project)))
                .orElse(ResponseEntity.notFound().build());
    }
    
    @PostMapping
    public ResponseEntity<ApiResponse> createProject(@RequestBody Project project) {
        Project createdProject = projectService.createProject(project);
        return ResponseEntity.ok(ApiResponse.success("Project created successfully", createdProject));
    }
    
    @PutMapping("/{id}")
    public ResponseEntity<ApiResponse> updateProject(@PathVariable Long id, @RequestBody Project projectDetails) {
        try {
            Project updatedProject = projectService.updateProject(id, projectDetails);
            return ResponseEntity.ok(ApiResponse.success("Project updated successfully", updatedProject));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
    
    @DeleteMapping("/{id}")
    public ResponseEntity<ApiResponse> deleteProject(@PathVariable Long id) {
        try {
            projectService.deleteProject(id);
            return ResponseEntity.ok(ApiResponse.success("Project deleted successfully", null));
        } catch (RuntimeException e) {
            return ResponseEntity.notFound().build();
        }
    }
}
JAVA_EOF

echo "✅ Database functionality restored!"
echo "🚀 Ready to deploy with full database support"
