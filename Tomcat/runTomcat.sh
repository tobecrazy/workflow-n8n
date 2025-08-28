#!/bin/bash

# Tomcat Docker Container Management Script
# Author: tobecrazy@qq.com

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print colored output
print_status() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[WARNING]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

print_header() {
    echo -e "${BLUE}================================${NC}"
    echo -e "${BLUE}  Tomcat Docker Container${NC}"
    echo -e "${BLUE}================================${NC}"
}

# Function to create necessary directories
create_directories() {
    print_status "Creating necessary directories..."
    mkdir -p webapps logs conf
    print_status "Directories created successfully"
}

# Function to copy initial config files
copy_initial_config() {
    if [ ! "$(ls -A conf)" ]; then
        print_status "Copying initial Tomcat configuration files..."
        
        # Clean up any existing temporary containers
        docker stop tomcat-config-temp 2>/dev/null || true
        docker rm tomcat-config-temp 2>/dev/null || true
        docker rmi tobecrazy/ubuntu-young 2>/dev/null || true
        
        # Build a temporary container to copy config files
        docker build -t tobecrazy/ubuntu-young .
        docker run -d --user root --name tomcat-config-temp tobecrazy/ubuntu-young tail -f /dev/null
        sleep 2
        docker cp tomcat-config-temp:/opt/tomcat/conf/. ./conf/
        docker stop tomcat-config-temp
        docker rm tomcat-config-temp
        docker rmi tobecrazy/ubuntu-young
        print_status "Initial configuration files copied to ./conf/"
    else
        print_status "Configuration directory already contains files, skipping copy"
    fi
}

# Function to build the Docker image
build_image() {
    print_status "Building Tomcat Docker image..."
    docker-compose build --no-cache
    print_status "Docker image built successfully"
}

# Function to start the container
start_container() {
    print_status "Starting Tomcat container..."
    docker-compose up -d
    print_status "Tomcat container started successfully"
    
    # Wait for container to be ready
    print_status "Waiting for Tomcat to start..."
    sleep 10
    
    # Check if container is running
    if docker-compose ps | grep -q "Up"; then
        print_status "Tomcat is running successfully!"
        print_status "Access Tomcat at: http://localhost:8090"
        print_status "Manager App: http://localhost:8090/manager (admin/admin)"
        print_status "Host Manager: http://localhost:8090/host-manager (admin/admin)"
    else
        print_error "Failed to start Tomcat container"
        docker-compose logs
        exit 1
    fi
}

# Function to stop the container
stop_container() {
    print_status "Stopping Tomcat container..."
    docker-compose down
    print_status "Tomcat container stopped"
}

# Function to show logs
show_logs() {
    print_status "Showing Tomcat logs..."
    docker-compose logs -f
}

# Function to show container status
show_status() {
    print_status "Container status:"
    docker-compose ps
}

# Function to clean up
cleanup() {
    print_status "Cleaning up..."
    docker-compose down -v
    docker system prune -f
    print_status "Cleanup completed"
}

# Main script logic
print_header

case "${1:-start}" in
    "build")
        create_directories
        build_image
        ;;
    "start")
        create_directories
        build_image
        copy_initial_config
        start_container
        ;;
    "stop")
        stop_container
        ;;
    "restart")
        stop_container
        sleep 2
        start_container
        ;;
    "logs")
        show_logs
        ;;
    "status")
        show_status
        ;;
    "clean")
        cleanup
        ;;
    "help"|"-h"|"--help")
        echo "Usage: $0 [COMMAND]"
        echo ""
        echo "Commands:"
        echo "  start     Build and start Tomcat container (default)"
        echo "  build     Build Docker image only"
        echo "  stop      Stop Tomcat container"
        echo "  restart   Restart Tomcat container"
        echo "  logs      Show container logs"
        echo "  status    Show container status"
        echo "  clean     Stop container and clean up"
        echo "  help      Show this help message"
        ;;
    *)
        print_error "Unknown command: $1"
        print_status "Use '$0 help' for usage information"
        exit 1
        ;;
esac
