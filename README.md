# Ach Paudel API Server

A comprehensive Spring Boot API server for personal projects and portfolio management.

## Features

- **RESTful APIs** with comprehensive CRUD operations
- **MySQL Database** integration with your DreamHost server
- **Health Monitoring** with Spring Boot Actuator
- **Logging** with configurable log levels
- **Cross-Origin Support** for web applications
- **Exception Handling** with proper error responses
- **Project Management** API for portfolio projects

## Technology Stack

- **Java 17**
- **Spring Boot 3.2.0**
- **Spring Data JPA**
- **MySQL 8.0**
- **Maven**
- **Lombok**

## Database Configuration

The application is configured to connect to your DreamHost MySQL server:
- **Server**: ducksworth.iad1-mysql-e2-1b.dreamhost.com
- **Database**: achpaudel_api
- **Username**: api_achpaudel

## API Endpoints

### Health & Info
- `GET /api/v1/health` - Health check
- `GET /api/v1/info` - API information
- `GET /api/actuator/health` - Detailed health check
- `GET /api/actuator/metrics` - Application metrics

### Projects
- `GET /api/v1/projects` - Get all projects
- `GET /api/v1/projects/{id}` - Get project by ID
- `POST /api/v1/projects` - Create new project
- `PUT /api/v1/projects/{id}` - Update project
- `DELETE /api/v1/projects/{id}` - Delete project

## Setup Instructions

### Prerequisites
- Java 17 or higher
- Maven 3.6+
- MySQL database access

### Local Development

1. **Clone the repository**
   ```bash
   git clone https://github.com/AchPaudel/achpaudel-api.git
   cd achpaudel-api
   ```

2. **Build the project**
   ```bash
   mvn clean install
   ```

3. **Run the application**
   ```bash
   mvn spring-boot:run
   ```

4. **Access the API**
   - Base URL: `http://localhost:8080/api`
   - Health Check: `http://localhost:8080/api/v1/health`

### Production Deployment

1. **Build the JAR file**
   ```bash
   mvn clean package -DskipTests
   ```

2. **Deploy to your server**
   ```bash
   java -jar target/achpaudel-api-1.0.0.jar
   ```

3. **Configure your domain**
   - Point `api.achpaudel.dev` to your server
   - Ensure SSL certificate is properly configured

## Project Structure

```
src/main/java/com/achpaudel/api/
├── AchPaudelApiApplication.java    # Main application class
├── controller/                     # REST controllers
│   ├── ApiController.java         # Main API endpoints
│   └── ProjectController.java     # Project CRUD operations
├── service/                       # Business logic
│   └── ProjectService.java       # Project service
├── repository/                    # Data access layer
│   └── ProjectRepository.java    # Project repository
├── model/                        # Entity classes
│   └── Project.java             # Project entity
├── dto/                         # Data Transfer Objects
│   ├── ApiResponse.java         # Generic API response
│   └── HealthResponse.java      # Health check response
└── exception/                   # Exception handling
    └── GlobalExceptionHandler.java
```

## Database Schema

The application will automatically create the following table:

```sql
CREATE TABLE projects (
    id BIGINT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    github_url VARCHAR(255),
    live_url VARCHAR(255),
    tech_stack VARCHAR(255),
    created_at DATETIME,
    updated_at DATETIME
);
```

## Monitoring

The application includes comprehensive monitoring:

- **Health Checks**: `/api/actuator/health`
- **Metrics**: `/api/actuator/metrics`
- **Application Info**: `/api/actuator/info`
- **Logs**: Check `logs/achpaudel-api.log`

## Adding New APIs

To add new API endpoints:

1. Create a new entity in `model/`
2. Create a repository in `repository/`
3. Create a service in `service/`
4. Create a controller in `controller/`
5. Add DTOs if needed in `dto/`

## Environment Variables

The application uses the following configuration in `application.yml`:
- Database connection details
- Server port and context path
- Logging configuration
- Actuator endpoints

## Contributing

1. Create a new branch for your feature
2. Make your changes
3. Test thoroughly
4. Submit a pull request

## License

This project is for personal use by Ach Paudel.

## Support

For issues or questions, please contact Ach Paudel. 