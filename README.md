# workflow-n8n

![n8n Logo](https://user-images.githubusercontent.com/10284570/173569848-c624317f-42b1-45a6-ab09-f0ea3c247648.png)

**English** | [中文](README_cn.md)

## Overview

This project provides a customized n8n workflow automation platform with additional Python integration capabilities and Playwright browser automation support. n8n is an extendable workflow automation tool that enables you to connect any app with an API.

## Features

- 🚀 Pre-configured Docker setup
- 🐍 Python integration for custom nodes
- 🌐 Playwright browser automation support
- 🔄 Easy workflow management
- 🔒 Secure credential handling
- 🐳 Tomcat server for web applications

## Installation

```bash
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

## Screenshot

![Workflow Example](n8n_mcp_demo.gif)

## Playwright Browser Automation

This n8n setup includes Playwright for browser automation, with the following features:

- **System Dependencies**: The Docker image includes all necessary system dependencies for Playwright and Chromium.
- **Chromium Browser**: Uses the system's own Chromium browser for better performance and compatibility.
- **Setup Script**: A `playwright-setup.sh` script runs on container startup to configure the environment, ensuring Playwright can locate and use the system's Chromium instance.
- **Environment Variables**: The `PLAYWRIGHT_BROWSERS_PATH` is set to `0` to prevent Playwright from downloading its own browser binaries, and other variables are configured for seamless integration.
- **n8n Node Support**: Fully supports n8n's Playwright nodes for building browser-based automation workflows.

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

## Troubleshooting Docker Build Issues

If you encounter dependency conflicts during the Docker image build, especially related to `openssl-dev` on Alpine Linux, it's likely due to inconsistencies between Alpine's stable and `edge` repositories. The `Dockerfile` has been updated to address this by:

1.  Ensuring both `main` and `community` `edge` repositories are used.
2.  Performing `apk update` and `apk upgrade` to update existing packages.
3.  Explicitly installing `openssl` and `openssl-dev` early in the `apk add` command to prioritize their dependency resolution.

If you still face issues, ensure your Docker cache is cleared and try rebuilding with `docker-compose up --build --force-recreate`.

---

## Getting Help

For support, please open an issue on GitHub.
