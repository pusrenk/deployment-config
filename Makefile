# Makefile for Spong Application Deployment
# This handles pulling images from Docker Hub with dynamic environment tags

# Docker Hub configuration - Update with your actual Docker Hub username/org
DOCKER_HUB_USER = your-dockerhub-username

# Environment configuration - can be overridden via command line
# Usage: make deploy ENV=staging
ENV ?= dev
IMAGE_TAG = $(ENV)

# Service names
SERVICES = auth-service customer-service spong-ml spong

# Dynamic image names with environment tags
AUTH_IMAGE = $(DOCKER_HUB_USER)/auth-service:$(IMAGE_TAG)
CUSTOMER_IMAGE = $(DOCKER_HUB_USER)/customer-service:$(IMAGE_TAG)
SPONG_ML_IMAGE = $(DOCKER_HUB_USER)/spong-ml:$(IMAGE_TAG)
SPONG_IMAGE = $(DOCKER_HUB_USER)/spong:$(IMAGE_TAG)

.PHONY: help pull deploy stop restart logs status clean update build-and-push dev staging prod

# Default target
help:
	@echo "🚀 Spong Application Deployment"
	@echo ""
	@echo "Environment Commands:"
	@echo "  make dev           - Deploy development environment (dev tag)"
	@echo "  make staging       - Deploy staging environment (staging tag)"
	@echo "  make prod          - Deploy production environment (prod tag)"
	@echo ""
	@echo "Generic Commands:"
	@echo "  make deploy        - Deploy with default environment (ENV=dev)"
	@echo "  make deploy ENV=X  - Deploy specific environment (dev/staging/prod)"
	@echo "  make pull ENV=X    - Pull images for specific environment"
	@echo "  make stop          - Stop all services"
	@echo "  make restart ENV=X - Restart with specific environment"
	@echo "  make logs          - Show logs for all services"
	@echo "  make status        - Show status of all services"
	@echo "  make update ENV=X  - Pull latest images and redeploy for environment"
	@echo "  make clean         - Stop services and remove containers/networks"
	@echo ""
	@echo "Maintainer Commands:"
	@echo "  make build-and-push ENV=X - Build and push images with specific tag"
	@echo ""
	@echo "Examples:"
	@echo "  make dev                    # Deploy development"
	@echo "  make staging               # Deploy staging"
	@echo "  make prod                  # Deploy production"
	@echo "  make deploy ENV=staging    # Deploy staging (alternative)"
	@echo "  make update ENV=prod       # Update production"

# Environment shortcuts
dev:
	$(MAKE) deploy ENV=dev

staging:
	$(MAKE) deploy ENV=staging

prod:
	$(MAKE) deploy ENV=prod

# Pull latest images from Docker Hub
pull:
	@echo "🔄 Pulling $(ENV) images from Docker Hub..."
	@echo "Environment: $(ENV)"
	@echo "Images to pull:"
	@echo "  - $(AUTH_IMAGE)"
	@echo "  - $(CUSTOMER_IMAGE)"
	@echo "  - $(SPONG_ML_IMAGE)"
	@echo "  - $(SPONG_IMAGE)"
	@echo ""
	docker pull $(AUTH_IMAGE)
	docker pull $(CUSTOMER_IMAGE)
	docker pull $(SPONG_ML_IMAGE)
	docker pull $(SPONG_IMAGE)
	@echo "✅ All $(ENV) images pulled successfully!"

# Deploy all services (auto-pulls latest images)
deploy: pull
	@echo "🚀 Deploying $(ENV) environment..."
	IMAGE_TAG=$(IMAGE_TAG) DOCKER_HUB_USER=$(DOCKER_HUB_USER) docker-compose up -d
	@echo ""
	@echo "✅ All services are now running in $(ENV) mode!"
	@echo ""
	@echo "🌐 Access your services at:"
	@echo "  Main App: http://localhost:3000"
	@echo "  Auth Service: http://localhost:3001"
	@echo "  Customer Service: http://localhost:3002"
	@echo "  ML Service: http://localhost:8000"
	@echo ""
	@echo "Environment: $(ENV)"

# Stop all services
stop:
	@echo "🛑 Stopping all services..."
	docker-compose down
	@echo "✅ All services stopped!"

# Restart all services
restart: stop deploy

# Show logs
logs:
	@echo "📋 Showing logs for all services..."
	docker-compose logs -f

# Show service status
status:
	@echo "📊 Service Status:"
	docker-compose ps

# Update: pull latest and redeploy
update:
	@echo "🔄 Updating $(ENV) environment to latest versions..."
	$(MAKE) stop
	$(MAKE) pull ENV=$(ENV)
	$(MAKE) deploy ENV=$(ENV)
	@echo "✅ Update complete for $(ENV) environment!"

# Clean up everything
clean:
	@echo "🧹 Cleaning up containers, networks, and unused images..."
	docker-compose down -v --remove-orphans
	docker system prune -f
	@echo "✅ Cleanup complete!"

# For maintainers: Build and push images to Docker Hub
build-and-push:
	@echo "🔨 Building and pushing $(ENV) images..."
	@echo "Environment: $(ENV)"
	@echo "Make sure you're logged in to Docker Hub: docker login"
	@echo ""
	@echo "Commands to run from each service directory:"
	@echo "Auth Service:"
	@echo "  docker build -t $(AUTH_IMAGE) . && docker push $(AUTH_IMAGE)"
	@echo ""
	@echo "Customer Service:"
	@echo "  docker build -t $(CUSTOMER_IMAGE) . && docker push $(CUSTOMER_IMAGE)"
	@echo ""
	@echo "Spong ML:"
	@echo "  docker build -t $(SPONG_ML_IMAGE) . && docker push $(SPONG_ML_IMAGE)"
	@echo ""
	@echo "Spong:"
	@echo "  docker build -t $(SPONG_IMAGE) . && docker push $(SPONG_IMAGE)"
	@echo ""
	@echo "Or run this one-liner if all services are in subdirectories:"
	@echo "for service in auth-service customer-service spong-ml spong; do (cd \$$service && docker build -t $(DOCKER_HUB_USER)/\$$service:$(IMAGE_TAG) . && docker push $(DOCKER_HUB_USER)/\$$service:$(IMAGE_TAG)); done" 