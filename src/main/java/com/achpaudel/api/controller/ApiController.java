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
                "/v1/projects",
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

    @GetMapping("/projects")
    public ResponseEntity<ApiResponse> getProjects() {
        Map<String, Object> data = new HashMap<>();
        data.put("projects", new String[]{
                "Personal API Server",
                "Portfolio API",
                "Blog API"
        });

        ApiResponse response = ApiResponse.builder()
                .success(true)
                .message("Projects retrieved successfully")
                .data(data)
                .build();

        return ResponseEntity.ok(response);
    }
}
