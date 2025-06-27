# Deployment Config

This repository contains Docker configurations to help you run the Spong application stack locally without needing to configure each service individually.

## Services Included

The following services are defined in `services.yaml` and can be deployed using Docker Compose:

- **auth-service** - Authentication service (Port 3001)
- **customer-service** - Customer management service (Port 3002)  
- **spong-ml** - Machine learning service (Port 8000)
- **spong** - Main application service (Port 3000)

## Quick Start

### Prerequisites
- Docker and Docker Compose installed
- All service images built and available locally

### Running All Services

1. **Clone this repository:**
   ```bash
   git clone <repository-url>
   cd deployment-config
   ```

2. **Start all services:**
   ```bash
   docker-compose up -d
   ```

3. **Check service status:**
   ```bash
   docker-compose ps
   ```

4. **View logs:**
   ```bash
   # All services
   docker-compose logs -f
   
   # Specific service
   docker-compose logs -f auth-service
   ```

### Accessing Services

Once running, you can access the services at:

- **Main App**: http://localhost:3000
- **Auth Service**: http://localhost:3001
- **Customer Service**: http://localhost:3002
- **ML Service**: http://localhost:8000

### Stopping Services

```bash
# Stop all services
docker-compose down
```

## Development flow
after your pull or latest update merged into main you can push the newest version of the services to here to help you teamate working with your projcect, so your teamate only have to adjust their project image to do the test

## Development Notes

- All services run in development mode
- Services can communicate with each other using their service names (e.g., `http://auth-service:3000`)
- Data persistence can be added by mounting volumes as needed

## Building Images

If you need to build the images locally, you can use the included Dockerfile as a base for Node.js services.


## Future notes

we might need to create one more yaml for storing all the environtment and maybe consider to seperate the yaml for production and development
