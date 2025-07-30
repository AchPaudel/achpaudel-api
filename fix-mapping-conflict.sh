#!/bin/bash

echo "🔧 Fixing Spring Boot mapping conflict..."

# Update ApiController to remove the conflicting /v1/projects endpoint
cat > src/main/java/com/achpaudel/api/controller/ApiController.java << 'JAVA_EOF'
package com.achpaudel.api.controller;

import com.achpaudel.api.dto.ApiResponse;
import com.achpaudel.api.dto.HealthResponse;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;
import java.util.HashMap;
import java.util.Map;

@RestController
@RequestMapping("/v1")
@CrossOrigin(origins = "*")
public class ApiController {

    @Value("${app.name}")
    private String appName;

    @Value("${app.version}")
    private String appVersion;

    @GetMapping("/health")
    public ResponseEntity<HealthResponse> health() {
        HealthResponse response = HealthResponse.builder()
                .status("UP")
                .timestamp(LocalDateTime.now())
                .service(appName)
                .version(appVersion)
                .build();
        return ResponseEntity.ok(response);
    }

    @GetMapping("/info")
    public ResponseEntity<ApiResponse> getApiInfo() {
        Map<String, Object> data = new HashMap<>();
        data.put("name", appName);
        data.put("version", appVersion);
        data.put("description", "Personal API Server for Ach Paudel");
        data.put("endpoints", new String[]{
                "/v1/health",
                "/v1/info",
                "/v1/projects (see ProjectController)",
                "/actuator/health",
                "/actuator/metrics"
        });

        ApiResponse response = ApiResponse.builder()
                .success(true)
                .message("API Information retrieved successfully")
                .data(data)
                .build();

        return ResponseEntity.ok(response);
    }

    @GetMapping("/status")
    public ResponseEntity<ApiResponse> getStatus() {
        Map<String, Object> data = new HashMap<>();
        data.put("status", "API is running");
        data.put("database", "Connected");
        data.put("uptime", "Since startup");
        
        ApiResponse response = ApiResponse.builder()
                .success(true)
                .message("API status retrieved successfully")
                .data(data)
                .build();

        return ResponseEntity.ok(response);
    }
}
JAVA_EOF

echo "✅ Mapping conflict fixed!"
echo "📋 Endpoints are now properly separated:"
echo "   - ApiController: /v1/health, /v1/info, /v1/status"
echo "   - ProjectController: /v1/projects/*"
