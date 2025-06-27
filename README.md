# Deployment Config

This repository contains Docker configurations to help you run the Spong application stack locally with support for multiple environments (dev, staging, prod) without needing to configure each service individually.

## Services Included

The following services can be deployed with different environment tags:

- **auth-service** - Authentication service (Port 3001)
- **customer-service** - Customer management service (Port 3002)  
- **spong-ml** - Machine learning service (Port 8000)
- **spong** - Main application service (Port 3000)

## Quick Start (Environment-Based Deployment)

### Prerequisites
- Docker and Docker Compose installed
- Make installed (usually pre-installed on Mac/Linux, Windows users can use Git Bash or WSL)

### Setup

1. **Clone this repository:**
   ```bash
   git clone <repository-url>
   cd deployment-config
   ```

2. **Update Docker Hub username:**
   Edit the `Makefile` and replace `your-dockerhub-username` with your actual Docker Hub username

### Environment Deployment Commands

```bash
# Quick environment deployment
make dev        # Deploy development environment (dev tag)
make staging    # Deploy staging environment (staging tag)  
make prod       # Deploy production environment (prod tag)

# Alternative syntax
make deploy ENV=dev
make deploy ENV=staging
make deploy ENV=prod
```

### Common Commands

```bash
# Deploy specific environment
make dev                    # Development
make staging               # Staging
make prod                  # Production

# Update to latest version of specific environment
make update ENV=dev
make update ENV=staging
make update ENV=prod

# Pull images for specific environment
make pull ENV=staging

# View all available commands
make help

# Check service status
make status

# View logs
make logs

# Stop all services
make stop

# Clean up everything
make clean
```

## Environment Tags System

### Supported Environments:
- **`dev`** - Development environment
- **`staging`** - Staging environment  
- **`prod`** - Production environment

### How it works:
1. Images are tagged with environment names: `username/service:dev`, `username/service:staging`, `username/service:prod`
2. Container names include environment: `auth-service-dev`, `auth-service-staging`, etc.
3. Networks are isolated per environment: `spong-network-dev`, `spong-network-staging`, etc.
4. Environment variables are set automatically based on the deployed environment

### Accessing Services

Once running, you can access the services at:

- **Main App**: http://localhost:3000
- **Auth Service**: http://localhost:3001
- **Customer Service**: http://localhost:3002
- **ML Service**: http://localhost:8000

*Note: All environments use the same ports, but you can only run one environment at a time locally.*

## Development Workflow

### For Maintainers (Pushing Images)

1. **Build and tag images for different environments:**
   ```bash
   # Development
   docker build -t your-dockerhub-username/auth-service:dev .
   docker push your-dockerhub-username/auth-service:dev
   
   # Staging
   docker build -t your-dockerhub-username/auth-service:staging .
   docker push your-dockerhub-username/auth-service:staging
   
   # Production
   docker build -t your-dockerhub-username/auth-service:prod .
   docker push your-dockerhub-username/auth-service:prod
   ```

2. **Or use the helper command:**
   ```bash
   make build-and-push ENV=dev
   make build-and-push ENV=staging
   make build-and-push ENV=prod
   ```

### For Team Members (Using Images)

Simply choose your environment and deploy:

```bash
# For development testing
make dev

# For staging testing  
make staging

# For production testing
make prod
```

This automatically:
- Pulls the latest images from Docker Hub for that environment
- Starts all services with the correct environment configuration
- Shows you the access URLs

### Switching Environments

```bash
# Switch from dev to staging
make stop
make staging

# Update staging to latest and deploy
make update ENV=staging
```

## Manual Docker Compose (Alternative)

If you prefer not to use Make:

```bash
# Set environment variables and deploy
DOCKER_HUB_USER=your-dockerhub-username IMAGE_TAG=dev docker-compose up -d

# Stop
docker-compose down
```

## Development Notes

- Services run with environment-specific configuration
- Services can communicate using service names (e.g., `http://auth-service:3000`)
- Each environment is isolated with its own network
- Container names include environment tags to avoid conflicts
- Environment variables are automatically set based on deployment environment

## Building Images

If you need to build images locally, you can use the included Dockerfile as a base for Node.js services.

## Benefits

✅ **Multi-environment support** - dev, staging, prod  
✅ **One command deployment** per environment  
✅ **Automatic image pulling** from Docker Hub  
✅ **Environment isolation** - separate networks and containers  
✅ **Easy environment switching**  
✅ **No manual configuration** needed for teammates  

## Future Notes

We might need to create separate configuration files for environment-specific settings like database URLs, API keys, etc.
