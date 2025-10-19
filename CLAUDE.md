# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a customized n8n workflow automation platform with enhanced capabilities for Python integration, Playwright browser automation, and Docker-based orchestration. The project extends the standard n8n platform with additional infrastructure components including Jenkins CI/CD, Tomcat web server, MySQL database, and WeChat bot integration.

## Development Commands

### Docker Operations

**Start the platform (SQLite - Default):**
```bash
docker-compose up -d
```

**Start with PostgreSQL:**
```bash
docker-compose -f docker-compose-postgre.yml up -d
```

**Build and run with fresh installation:**
```bash
./runMe.sh
# Equivalent to: docker-compose up --build -d --force-recreate
```

**Run with PostgreSQL setup:**
```bash
./runNewN8n.sh
# Equivalent to: docker-compose -f docker-compose-postgre.yml up -d --force-recreate
```

**Build custom n8n image:**
```bash
docker build -t n8n-python .
```

**Clean rebuild (resolve dependency conflicts):**
```bash
docker-compose up --build --force-recreate
```

### Python Package Management

**Install packages in container:**
```bash
# Using pip
docker exec -it <container_name> pip install package-name
# Using uv (faster)
docker exec -it <container_name> uv pip install package-name
```

## Architecture

### Core Components

1. **N8N Core**: Built on `n8nio/n8n:latest` with custom enhancements
2. **Python Integration**: Python 3 runtime with `uv` package manager
3. **Playwright Browser Automation**: System Chromium with continuous monitoring
4. **Database Options**: SQLite (default) or PostgreSQL
5. **Additional Services**: Jenkins, Tomcat, MySQL, WeChat bot integration

### Docker Architecture

- **Main Container**: Custom n8n image with Python and Playwright support
- **Data Persistence**: `workflow-n8n_n8n_data` volume for n8n configuration
- **Database**: Separate PostgreSQL container when using `docker-compose-postgre.yml`
- **Network**: All services communicate through Docker network

### Directory Structure

```
workflow-n8n/
├── Dockerfile                    # Main n8n container definition
├── docker-compose.yml           # SQLite setup
├── docker-compose-postgre.yml   # PostgreSQL setup
├── playwright-setup.sh          # Browser automation configuration
├── runMe.sh / runNewN8n.sh     # Deployment scripts
├── Jenkins/                     # CI/CD integration
├── Tomcat/                      # Java web server
├── Mysql/                       # MySQL database option
├── WeChatRobot/                # WeChat integration
└── webapps/                    # Web applications
```

## Key Configuration

### Environment Variables

**Required for MCP (Model Context Protocol) integration:**
- `MCP_BRAVE_API_KEY`: Brave Search API key
- `MCP_OPENAI_API_KEY`: OpenAI API key
- `MCP_SERPER_API_KEY`: Serper search API key
- `MCP_WEATHER_API_KEY`: Weather service API key

**N8N Configuration:**
- `N8N_RUNNERS_ENABLED=true`: Enable workflow runners
- `N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true`: Allow community packages as tools
- `DB_SQLITE_POOL_SIZE=10`: SQLite connection pooling

**Database (PostgreSQL):**
- `DB_TYPE=postgresdb`
- `DB_POSTGRESDB_DATABASE=n8n_Database`
- `DB_POSTGRESDB_HOST=db`
- `DB_POSTGRESDB_USER=n8n_user`
- `DB_POSTGRESDB_PASSWORD=dbn8n@2025`

### Playwright Configuration

The system uses Alpine Linux's system Chromium instead of downloading Playwright browsers. Key features:

- **Automatic Setup**: `playwright-setup.sh` runs on container startup
- **Continuous Monitoring**: Background process monitors for n8n-nodes-playwright installations
- **Browser Symlinks**: Creates multiple symlinks for different Playwright versions
- **Environment Variables**: Prevents browser downloads and ensures compatibility

## Troubleshooting

### Docker Build Issues

If encountering dependency conflicts (especially `openssl-dev` on Alpine):
1. Clear Docker cache: `docker system prune -a`
2. Rebuild with force: `docker-compose up --build --force-recreate`
3. The Dockerfile addresses Alpine edge repository conflicts

### Playwright Issues

If Playwright nodes don't work:
1. Ensure container has fully started (setup script runs in background)
2. Check browser symlinks were created automatically
3. Verify environment variables are set correctly
4. Restart container if Playwright node was installed after startup

### Database Switching

To switch from SQLite to PostgreSQL:
1. Stop current setup: `docker-compose down`
2. Start PostgreSQL setup: `docker-compose -f docker-compose-postgre.yml up -d`
3. Data migration may be required depending on existing workflows

## Integration Points

### Python Custom Nodes
- Install packages using `uv pip install` or `pip install --break-system-packages`
- Python 3 runtime available with all build tools
- Custom nodes can leverage full Python ecosystem

### Playwright Browser Automation
- System Chromium available at `/usr/bin/chromium-browser`
- Multiple browser symlinks created automatically
- Supports n8n's Playwright nodes out of the box

### MCP (Model Context Protocol)
- Configure API keys in environment variables
- Enables n8n workflows to access external tools and services
- Standardized interfaces for expanding automation possibilities

## Access Points

- **N8N Interface**: http://localhost:5678
- **Tomcat**: http://localhost:8080 (when configured)
- **Jenkins**: http://localhost:8081 (when configured)

## Volume Management

The system uses external Docker volumes for persistence:
- `workflow-n8n_n8n_data`: N8N configuration and workflows
- `postgres_data`: PostgreSQL data (when using PostgreSQL setup)

Volumes persist across container restarts and rebuilds, ensuring workflow and configuration data is maintained.