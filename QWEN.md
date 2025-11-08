# QWEN.md - workflow-n8n Project Context

## Project Overview

The workflow-n8n project is a comprehensive workflow automation platform built on n8n with extensive enhancements. It provides a complete ecosystem of tools and services including Python integration, Playwright browser automation, WeChat bot integration, multiple database options, Jenkins CI/CD, and Tomcat web server with demo applications. The platform extends standard n8n functionality with additional infrastructure components including Model Context Protocol (MCP) server support for AI-powered workflows.

## Architecture and Components

### Core n8n Service
- Built on top of official n8n image with custom Dockerfile enhancements
- Includes Python 3 with advanced package management via uv (faster package installer)
- Integrated Playwright browser automation using system Chromium
- MCP (Model Context Protocol) support for AI-powered workflows
- Multiple database options: SQLite (default), PostgreSQL, and MySQL

### Additional Services
1. **Tomcat Server**: Java web server with OpenJDK 21 and Tomcat 9.0.108
   - Includes interactive demo applications
   - Volume-mapped directories for persistent storage
   - Manager and host manager with default credentials (admin/admin)
   - Runs on port 8090

2. **Jenkins CI/CD**: Docker-based Jenkins for continuous integration/deployment
   - Accessible on port 8090 (conflicts with Tomcat by default)
   - Persistent volume for Jenkins data

3. **MySQL Database**: Alternative database option
   - Uses mysql:latest image
   - Accessible on port 3308 (host) → 3306 (container)
   - Pre-configured with sample database and users

## Building and Running

### Default n8n Setup (SQLite)
```bash
docker-compose up -d
```

### PostgreSQL Setup
```bash
docker-compose -f docker-compose-postgre.yml up -d
```

### Fresh Build and Run
```bash
# Using the run script
./runMe.sh
# Or manually with force recreate
docker-compose up --build -d --force-recreate
```

### PostgreSQL Build and Run
```bash
# Using the run script
./runNewN8n.sh
# Or manually
docker-compose -f docker-compose-postgre.yml up -d --force-recreate
```

### Access Points
- **N8N Interface**: http://localhost:5678
- **Tomcat Server**: http://localhost:8090 (when Tomcat service is running)
- **Jenkins CI/CD**: http://localhost:8090 (when Jenkins service is running)
- **MySQL Database**: localhost:3308 (when MySQL service is running)
- **Tomcat Manager**: http://localhost:8090/manager (admin/admin)

**Note**: Tomcat and Jenkins both use port 8090 by default. Run only one service at a time or modify port configurations to avoid conflicts.

## Key Configuration

### Environment Variables
The project uses several environment variables configured in docker-compose files:
- `N8N_RUNNERS_ENABLED`: Enable/disable runners
- `DB_SQLITE_POOL_SIZE`: SQLite connection pool size
- `N8N_BASIC_AUTH_USER/PASSWORD`: Basic authentication
- `N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE`: Allow community packages to use tools
- MCP server configuration variables for various API keys

### Python and Package Management
The container includes:
- Python 3 with pip (upgraded to latest version with PEP 668 compatibility)
- uv and uvx (fast Python package installer and resolver)
- Essential build tools for Python extensions
- System command aliases (python3→python, pip3→pip) for convenience

### Playwright Browser Automation
- Uses system Chromium instead of downloaded browsers
- Comprehensive setup script (playwright-setup.sh) that runs at container startup
- Implements symlinks for multiple Playwright versions (1129-1135) to ensure compatibility
- Background monitor that creates necessary directory structures and symlinks dynamically
- Environment variables configured to use system Chromium directly

## Development Conventions

### Docker-based Development
- All services are containerized using Docker
- Docker Compose for orchestration
- Persistent volumes for data persistence
- Build process includes system dependencies for Playwright and Python

### File Structure Organization
- Main n8n configuration in root directory
- Service-specific configurations in dedicated subdirectories (Jenkins, Tomcat, MySQL)
- Volume-mapped directories for persistent data and configurations
- Run scripts for common operations

### Security Practices
- Runs as non-root users where possible
- Secure credential handling through environment variables
- Default passwords should be changed in production
- Volume permissions should be properly managed

## Troubleshooting

### Docker Build Issues
- Clean Docker cache: `docker system prune -a`
- Force rebuild: `docker-compose up --build --force-recreate`
- Check for conflicting packages in build logs

### Playwright Issues
- Verify Chromium is working: `docker exec <container> /usr/bin/chromium-browser --version`
- Check for symlinks: `docker exec <container> find /home/node/.n8n -name "chrome" -type l`
- Monitor logs for Playwright-related messages

### Port Conflicts
- Tomcat and Jenkins both use port 8090 by default
- Modify docker-compose files to use different ports when needed
- Check port usage: `lsof -i :8090`

## Special Features

### MCP Server Configuration
Built-in support for Model Context Protocol (MCP) servers with:
- Brave API integration
- OpenAI API integration
- Serper API integration
- Weather API integration
- Standardized interfaces for external tools and services

### WeChat Integration
- Uses zhayujie/chatgpt-on-wechat for WeChat automation
- Support for various AI models and custom API endpoints
- Flexible configuration with chat modes and creative features
- Memory management and multi-language support

## Project Structure
```
workflow-n8n/
├── AI-workflow-Demo.mp4
├── CLAUDE.md
├── Dockerfile
├── README_cn.md
├── README.md
├── docker-compose-postgre.yml
├── docker-compose.yml
├── n8n_mcp_demo.gif
├── playwright-setup.sh
├── runMe.sh
├── runNewN8n.sh
├── Jenkins/
├── Mysql/
├── Tomcat/
├── conf/
├── logs/
├── n8n_data/
└── webapps/
```