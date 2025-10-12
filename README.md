# workflow-n8n

![n8n Logo](https://user-images.githubusercontent.com/10284570/173569848-c624317f-42b1-45a6-ab09-f0ea3c247648.png)

**English** | [中文](README_cn.md)

## Overview

This project provides a customized n8n workflow automation platform with additional Python integration capabilities and Playwright browser automation support. n8n is an extendable workflow automation tool that enables you to connect any app with an API.

## Features

- 🚀 Pre-configured Docker setup
- 🐍 Python integration for custom nodes (with uv package manager)
- 🌐 Playwright browser automation support
- 🔄 Easy workflow management
- 🔒 Secure credential handling
- 🐳 Tomcat server for web applications
- 🛠️ Built-in support for Model Context Protocol (MCP) servers

## Quick Start

### Option 1: Using Docker Compose (Default SQLite)
```bash
docker-compose up -d
```

### Option 2: Using PostgreSQL
```bash
docker-compose -f docker-compose-postgre.yml up -d
```

### Option 3: Build and run with fresh installation
```bash
# Run with automatic build and force recreate
./runMe.sh
# or run manually:
docker-compose up --build -d --force-recreate
```

### Option 4: Run with PostgreSQL setup
```bash
./runNewN8n.sh
# or run manually:
docker-compose -f docker-compose-postgre.yml up -d --force-recreate
```

## Installation

```bash
# Clone the repository
git clone https://github.com/tobecrazy/workflow-n8n.git
cd workflow-n8n

# Pull the latest pre-built image (alternative to building locally)
docker pull tobecrazy/n8n-python:latest
docker-compose up -d
```

## Configuration

Environment variables can be set in the `docker-compose.yml` or `.env` file:

```
# Enable/disable runners (set to true to use)
N8N_RUNNERS_ENABLED=true

# SQLite connection pool size
DB_SQLITE_POOL_SIZE=10

# Basic Auth
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=password

# PostgreSQL (optional)
DB_TYPE=postgresdb
DB_POSTGRESDB_DATABASE=n8n_Database
DB_POSTGRESDB_HOST=db
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_USER=n8n_user
DB_POSTGRESDB_SCHEMA=public
DB_POSTGRESDB_PASSWORD=dbn8n@2025

# Allow community packages to use tools
N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true
```

## Python and Package Management

This setup includes the latest uv package manager for faster Python package installations. The container includes:
- Python 3 with pip
- uv (fast Python package installer and resolver)
- Essential build tools for Python extensions
```
# Example of installing Python packages in the container
pip install package-name
# or using uv (faster)
uv pip install package-name
```

## Screenshot

![Workflow Example](n8n_mcp_demo.gif)

## Playwright Browser Automation

This n8n setup includes Playwright for browser automation, with the following features:

- **System Dependencies**: The Docker image includes all necessary system dependencies for Playwright and Chromium, including nss, freetype, harfbuzz, ttf-freefont, gcompat, bash, dbus, fontconfig, mesa-gl, udev, and xvfb.
- **Chromium Browser**: Uses the system's own Chromium browser for better performance and compatibility. Includes chromium-chromedriver.
- **Setup Script**: A `playwright-setup.sh` script runs on container startup to configure the environment, ensuring Playwright can locate and use the system's Chromium instance.
- **Environment Variables**: Properly configured environment variables including `PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1`, `PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser`, and others to prevent Playwright from downloading its own browser binaries and ensure seamless integration.
- **n8n Node Support**: Fully supports n8n's Playwright nodes for building browser-based automation workflows.
- **Continuous Monitoring**: The setup includes a background process that monitors for n8n-nodes-playwright installations and creates the necessary directory structures and symlinks for Playwright to work correctly with different versions.
- **Browser Symlinks**: Creates multiple symlinks and directory structures that the Playwright node expects to find for different browser versions.

## Tomcat Server

This project also includes a complete Tomcat server setup with:
- OpenJDK 21 on Ubuntu 25.10
- Tomcat 9.0.108
- Docker container management script
- Volume mapping for webapps, logs, and configuration
- Health check monitoring
- Non-root user security

See [Tomcat/README.md](Tomcat/README.md) for detailed Tomcat setup and management instructions.

## MCP Server Configuration

This n8n setup includes built-in support for Model Context Protocol (MCP) servers. To configure MCP servers, set the following environment variables in `docker-compose.yml`:

```
MCP_BRAVE_API_KEY=your-brave-api-key
MCP_OPENAI_API_KEY=your-openai-key
MCP_SERPER_API_KEY=your-serper-key
MCP_WEATHER_API_KEY=your-weather-api-key
```

To get these API keys:
- **Brave API Key**: Sign up at https://brave.com/search/api/
- **OpenAI API Key**: Create one at https://platform.openai.com/api-keys
- **Serper API Key**: Get one from https://serper.dev/
- **Weather API Key**: Various providers available (e.g., OpenWeatherMap, WeatherAPI)

MCP (Model Context Protocol) enables n8n workflows to access external tools and services through standardized interfaces, expanding the range of automation possibilities.

## Troubleshooting

### Docker Build Issues
If you encounter dependency conflicts during the Docker image build, especially related to `openssl-dev` on Alpine Linux, it's likely due to inconsistencies between Alpine's stable and `edge` repositories. The `Dockerfile` has been updated to address this by:

1.  Ensuring both `main` and `community` `edge` repositories are used.
2.  Performing `apk update` and `apk upgrade` to update existing packages.
3.  Explicitly installing `openssl` and `openssl-dev` early in the `apk add` command to prioritize their dependency resolution.

If you still face issues, ensure your Docker cache is cleared and try rebuilding with `docker-compose up --build --force-recreate`.

### Playwright Issues
If Playwright nodes don't work properly:
1. Make sure the container has started completely (the setup script runs in the background)
2. Check that the necessary symlinks have been created (should happen automatically)
3. Verify that environment variables are set correctly
4. The background monitor creates symlinks as needed, but you might need to restart the container if the Playwright node was installed after container start

### Running Scripts
We provide several scripts for different scenarios:
- `runMe.sh`: Builds and runs with force recreate (good for fresh installs)
- `runNewN8n.sh`: Runs with PostgreSQL configuration
- `docker-compose.yml`: Default setup with SQLite
- `docker-compose-postgre.yml`: PostgreSQL setup

---

## Getting Help

For support, please open an issue on GitHub.
