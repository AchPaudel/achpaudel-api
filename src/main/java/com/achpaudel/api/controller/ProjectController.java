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
