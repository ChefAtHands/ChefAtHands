# ChefAtHands

Microservices-based recipe recommendation system that helps users find recipes based on their available ingredients.

## Prerequisites

- Java 19
- Maven 3.6+
- Docker & Docker Compose
- Node.js & npm (for frontend development)

## Quick Start with Docker

### 1. Pull and Run All Services

The easiest way to run the entire application:

```bash
# Pull all services from Docker Hub
docker-compose pull

# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f
```

All backend services will be available:
- Frontend Gateway: `http://localhost:8080`
- Ingredient Service: `http://localhost:8081`
- Logging Service: `http://localhost:8082`
- User Service: `http://localhost:8083`
- Recommendation Service: `http://localhost:8084`
- Recipe Search Service: `http://localhost:8085`
- Favourites Service: `http://localhost:8086`
- Notification Service: `http://localhost:8087`
- History Service: `http://localhost:8088`

### 2. Run Frontend (React)

```bash
cd frontend/chefathands-frontend
npm install
npm start
```

Frontend will be available at `http://localhost:3000`

### 3. Stop All Services

```bash
docker-compose down
```

## Building from Source

### 1. Install Parent POM

```bash
mvn clean install
```

### 2. Build Individual Services

```bash
# Example: Build ingredient service
cd utility-services/ingredient-service
mvn clean package -DskipTests
```

### 3. Build Docker Images

```bash
# Build individual service
cd utility-services/ingredient-service
docker build -t chefathands-ingredient-service:latest .

# Or use the provided script to build all services
# (Create a build script if needed)
```

### 4. Push to Docker Hub (for contributors)

```bash
# Tag with your Docker Hub username
docker tag chefathands-ingredient-service:latest yourusername/chefathands-ingredient-service:latest

# Push
docker push yourusername/chefathands-ingredient-service:latest
```

## Architecture

ChefAtHands consists of the following microservices:

### Utility Services
- **ingredient-service** - Manages ingredients and user ingredient inventory
- **user-service** - User authentication and profile management
- **logging-service** - Centralized logging
- **favourites-service** - User recipe favourites
- **notification-service** - User notifications
- **history-service** - Recipe search history

### Processing Services
- **recommendation-service** - Recipe recommendations based on available ingredients

### External API Services
- **recipe-search-service** - Integration with external recipe APIs (Spoonacular)

### Gateway
- **frontend-gateway** - API gateway for frontend requests

### Frontend
- **React SPA** - User interface

## Module Repositories

- [db](https://github.com/ChefAtHands/db)
- [frontend](https://github.com/ChefAtHands/frontend)
- [frontend-gateway](https://github.com/ChefAtHands/frontend-gateway)
- [processing-services](https://github.com/ChefAtHands/processing-services)
- [utility-services](https://github.com/ChefAtHands/utility-services)
- [external-api-services](https://github.com/ChefAtHands/external-api-services)

## Docker Hub Images

All images are available at: https://hub.docker.com/u/anejt

