# ChefAtHands

Parent POM for the ChefAtHands microservices project.

## Prerequisites

- Java 17
- Maven 3.6+

## Building the Project

### 1. Install Parent POM

First, install the parent POM to your local Maven repository:

```bash
mvn clean install
```

### 2. Build Individual Modules

After installing the parent, you can build each module separately:

```bash
# Clone and build a module (example: utility-services)
cd utility-services
mvn clean install

# Or skip tests
mvn clean install -DskipTests
```

### 3. Build All Modules (if cloned together)

If you have all repositories cloned in the same parent directory:

```bash
# From ChefAtHands directory
cd db && mvn clean install
cd frontend && mvn clean install
cd frontend-gateway && mvn clean install
cd processing-services && mvn clean install
cd utility-services && mvn clean install
```

## Module Repositories

- [db](https://github.com/ChefAtHands/db)
- [frontend](https://github.com/ChefAtHands/frontend)
- [frontend-gateway](https://github.com/ChefAtHands/frontend-gateway)
- [processing-services](https://github.com/ChefAtHands/processing-services)
- [utility-services](https://github.com/ChefAtHands/utility-services)

## Development Workflow

1. Clone the parent repository
2. Install parent POM: `mvn install`
3. Clone desired module repositories
4. Build modules as needed

**Note:** Always rebuild and install the parent POM when making changes to shared dependencies or properties.
```