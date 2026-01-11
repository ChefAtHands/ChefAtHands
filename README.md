# ChefAtHands 🍳

![Build Status](https://github.com/yourusername/ChefAtHands/actions/workflows/deploy.yml/badge.svg)
![Tests](https://img.shields.io/badge/tests-passing-brightgreen)
![Deployment](https://img.shields.io/badge/deployment-AKS-blue)

Microservices-based recipe recommendation system that helps users find recipes based on their available ingredients. Built with Spring Boot microservices, React frontend, and deployed on Azure Kubernetes Service (AKS).

## Architecture Overview

ChefAtHands is a cloud-native microservices application featuring:
- **9 Spring Boot Microservices**
- **React Frontend (SPA)**
- **Azure SQL Database**
- **Kubernetes Orchestration (AKS)**
- **Automated CI/CD Pipeline**
- **Docker Containerization**

## Live Deployment

The application is automatically deployed to **Azure Kubernetes Service (AKS)** on every commit to the `main` branch.

**Production URL:** `http://9.235.148.20/`

## 📋 Prerequisites

### For Development:
- Java 17
- Maven 3.6+
- Docker & Docker Compose
- Node.js 20+ & npm
- kubectl (for Kubernetes operations)

## CI/CD Pipeline

Our automated CI/CD pipeline is built with **GitHub Actions** and performs the following on every commit:

```
┌─────────────┐      ┌─────────────┐      ┌─────────────┐      ┌─────────────┐
│   Commit    │ ───> │    Test     │ ───> │    Build    │ ───> │   Deploy    │
│   to main   │      │  All Tests  │      │   Docker    │      │   to AKS    │
└─────────────┘      └─────────────┘      └─────────────┘      └─────────────┘
```

## Microservices Architecture

### Utility Services
| Service | Port | Description | Status |
|---------|------|-------------|--------|
| **ingredient-service** | 8081 | Manages ingredients and user inventory | ✅ Active |
| **user-service** | 8083 | User authentication and profiles | ✅ Active |
| **logging-service** | 8082 | Centralized logging | ✅ Active |
| **favourites-service** | 8086 | User recipe favourites | ✅ Active |
| **notification-service** | 8087 | User notifications | ✅ Active |
| **history-service** | 8088 | Recipe search history | ✅ Active |

### Processing Services
| Service | Port | Description | Status |
|---------|------|-------------|--------|
| **recommendation-service** | 8084 | recipe recommendations | ✅ Active |

### External API Services
| Service | Port | Description | Status |
|---------|------|-------------|--------|
| **recipe-search-service** | 8085 | Spoonacular API integration | ✅ Active |

### Gateway & Frontend
| Component | Port | Description | Status |
|-----------|------|-------------|--------|
| **frontend-gateway** | 8080 | API Gateway for React frontend | ✅ Active |
| **React Frontend** | 3000 (dev) / 80 (prod) | User interface | ✅ Active |

## 🐳 Docker Quick Start

### Pull and Run 

```bash
# Pull all services from Docker Hub
docker-compose pull

# Start all services
docker-compose up -d

# Check status
docker-compose ps

# View logs
docker-compose logs -f

# Stop all services
docker-compose down
```

## Docker Hub Images

All container images are publicly available at Docker Hub:

**Registry:** https://hub.docker.com/u/anejt

**Available Images:**
- `anejt/chefathands-ingredient-service:latest`
- `anejt/chefathands-user-service:latest`
- `anejt/chefathands-logging-service:latest`
- `anejt/chefathands-favourites-service:latest`
- `anejt/chefathands-history-service:latest`
- `anejt/chefathands-notification-service:latest`
- `anejt/chefathands-recipe-search-service:latest`
- `anejt/chefathands-recommendation-service:latest`
- `anejt/chefathands-frontend-gateway:latest`
- `anejt/chefathands-frontend:latest`

## Project Structure

```
ChefAtHands/
├── .github/
│   └── workflows/
│       └── deploy.yml              # CI/CD pipeline configuration
├── k8s/                            # Kubernetes manifests
│   ├── database-secret.yaml
│   ├── ingredient-service.yaml
│   ├── user-service.yaml
│   ├── frontend-gateway.yaml
│   ├── ingress.yaml
│   └── ...
├── utility-services/               # Core utility microservices
│   ├── ingredient-service/
│   ├── user-service/
│   ├── logging-service/
│   ├── favourites-service/
│   ├── history-service/
│   └── notification-service/
├── processing-services/            # Data processing services
│   └── recommendation-service/
├── external-api-services/          # External API integrations
│   └── recipe-search-service/
├── frontend-gateway/               # API Gateway
├── frontend/                       # React frontend (submodule)
│   └── chefathands-frontend/
├── docker-compose.yml              # Local development setup
├── pom.xml                         # Maven parent POM
└── README.md
```

## Module Repositories (Git Submodules)

This project uses Git submodules for modular development:

- [db](https://github.com/ChefAtHands/db) - Database schemas
- [frontend](https://github.com/ChefAtHands/frontend) - React application
- [frontend-gateway](https://github.com/ChefAtHands/frontend-gateway) - API Gateway
- [processing-services](https://github.com/ChefAtHands/processing-services) - Processing microservices
- [utility-services](https://github.com/ChefAtHands/utility-services) - Utility microservices
- [external-api-services](https://github.com/ChefAtHands/external-api-services) - External integrations

### Cloning with Submodules:

```bash
# Clone with all submodules
git clone --recursive https://github.com/yourusername/ChefAtHands.git

# Or if already cloned
git submodule update --init --recursive
```

## Technology Stack

### Backend:
- **Framework:** Spring Boot 3.x
- **Language:** Java 17
- **Build Tool:** Maven
- **Database:** Azure SQL Database
- **ORM:** Spring Data JPA / Hibernate
- **API Documentation:** OpenAPI/Swagger

### Frontend:
- **Framework:** React 18
- **State Management:** React Context / Redux
- **Styling:** CSS Modules / Styled Components
- **HTTP Client:** Axios

### DevOps & Infrastructure:
- **Containerization:** Docker
- **Orchestration:** Kubernetes (AKS)
- **CI/CD:** GitHub Actions
- **Cloud Provider:** Microsoft Azure
- **Container Registry:** Docker Hub
- **Monitoring:** Azure Monitor (planned)

## Monitoring & Logging
### Health Checks:
Each service exposes health endpoints:
- `GET /actuator/health` - Service health status
- `GET /actuator/info` - Service information

## Security

- **Secrets Management:** Kubernetes secrets
- **Database:** Encrypted connections to Azure SQL
- **API Gateway:** Rate limiting and request validation

## Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

**Note:** All PRs trigger automated tests. Ensure tests pass before requesting review.

## API Documentation

API documentation is available at:
- api_specification.yaml


## Team

**ChefAtHands Development Team**
- Anej Tomplak - Full Stack Development, DevOps
- Matej Kristan - Full Stack Development
- Jan Napast - Full Stack Development

---