# workflow-n8n

![n8n Logo](https://user-images.githubusercontent.com/10284570/173569848-c624317f-42b1-45a6-ab09-f0ea3c247648.png)

**English** | [中文](README_cn.md)

## Overview

This project provides a comprehensive workflow automation platform built on n8n with extensive enhancements including Python integration, Playwright browser automation, WeChat bot integration, and multiple deployment options. The platform extends the standard n8n functionality with additional infrastructure components including Jenkins CI/CD, Tomcat web server with demo applications, multiple database options (SQLite, PostgreSQL, MySQL), and Model Context Protocol (MCP) server support for AI-powered workflows.

## Features

- 🚀 Pre-configured Docker setup with custom n8n image
- 🐍 Python 3 integration for custom nodes (with uv package manager)
- 🌐 Playwright browser automation with system Chromium
- 🔄 Easy workflow management with multiple deployment scripts
- 🔒 Secure credential handling and environment configuration
- 🐳 Tomcat 9.0.108 server with OpenJDK 21 and demo web applications
- 🛠️ Built-in support for Model Context Protocol (MCP) servers
- 💬 WeChat bot integration with ChatGPT using zhayujie/chatgpt-on-wechat
- 🔧 Jenkins CI/CD integration with customizable build environment
- 🗄️ Multiple database options (SQLite default, PostgreSQL, MySQL)
- 📦 Advanced package management with uv for faster Python installations
- 🎭 Continuous Playwright monitoring and automatic symlink creation
- 🌏 China-optimized mirror sources for faster downloads in China regions

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
# MCP server environment variables
MCP_BRAVE_API_KEY=your-brave-api-key
MCP_OPENAI_API_KEY=your-openai-key
MCP_SERPER_API_KEY=your-serper-key
MCP_WEATHER_API_KEY=your-weather-api-key

# Timezone configuration
GENERIC_TIMEZONE=Asia/Shanghai
TZ=Asia/Shanghai

# Security settings
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# Enable/disable runners (set to true to use)
N8N_RUNNERS_ENABLED=true

# SQLite connection pool size
DB_SQLITE_POOL_SIZE=10

# Allow community packages to use tools
N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true

# Basic Auth (optional)
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

## China Mirror Sources Configuration

This Docker image is optimized for users in China regions with pre-configured mirror sources to ensure fast and reliable downloads:

### Configured Mirror Sources:

- **Alpine Linux**: Uses Alibaba Cloud mirror (`mirrors.aliyun.com`) for fast package installation
- **Python pip**: Uses Tsinghua University mirror (`pypi.tuna.tsinghua.edu.cn/simple`) for Python packages
- **Node.js npm**: Uses Taobao npm mirror (`registry.npmmirror.com`) for Node.js packages
- **uv package manager**: Uses Tsinghua University mirror for fast Python package management

### Benefits:

- 🚀 **Faster Downloads**: Significantly faster package downloads in China regions
- 🔒 **Reliable Connection**: Reduces connection failures and timeouts
- 📦 **Universal Coverage**: All package managers (apk, pip, npm, uv) are optimized
- 🛡️ **Automatic Fallback**: Uses trusted mirrors with high uptime

### Mirror Source Verification:

You can verify the mirror sources are working:

```bash
# Check Alpine package source
docker exec <container> cat /etc/apk/repositories

# Check pip configuration
docker exec -u node <container> cat /home/node/.pip/pip.conf

# Check npm configuration
docker exec -u node <container> npm config get registry
```

## Python and Package Management

This setup includes the latest uv package manager for faster Python package installations. The container includes:
- Python 3 with pip (upgraded to latest version with PEP 668 compatibility)
- uv and uvx (fast Python package installer and resolver, installed via official method)
- Essential build tools for Python extensions (gcc, musl-dev, libffi-dev)
- System command aliases (python3→python, pip3→pip) for convenience

```
# Example of installing Python packages in the container
pip install package-name
# or using uv (faster, recommended)
uv pip install package-name
# or using uvx for running tools directly
uvx tool-name
```

## Screenshot

![Workflow Example](n8n_mcp_demo.gif)

## Playwright Browser Automation

This n8n setup includes comprehensive Playwright browser automation with advanced features:

- **System Dependencies**: Pre-installed all necessary system dependencies including nss, freetype, harfbuzz, ttf-freefont, gcompat, bash, dbus, fontconfig, mesa-gl, udev, and xvfb.
- **Chromium Browser**: Uses Alpine Linux system Chromium with chromium-chromedriver for optimal performance and compatibility.
- **Advanced Setup Script**: `playwright-setup.sh` runs on container startup with comprehensive environment configuration and browser detection.
- **Environment Variables**: Complete Playwright environment setup including `PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1`, `PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser`, and Puppeteer compatibility variables.
- **n8n Node Support**: Full support for n8n's Playwright nodes with automatic browser detection and configuration.
- **Continuous Monitoring**: Background process monitors for n8n-nodes-playwright installations and creates necessary directory structures and symlinks dynamically.
- **Multi-Version Support**: Creates browser symlinks for multiple Playwright versions (1129-1135) to ensure compatibility.
- **Smart Browser Detection**: Implements fake npx command to skip unnecessary browser downloads and uses system Chromium directly.
- **Chrome Wrapper Scripts**: Creates wrapper scripts with proper sandbox settings for headless operation.

## Additional Services

### Tomcat Server with Demo Applications

This project includes a complete Tomcat server setup with demo web applications:
- **Base**: OpenJDK 21 on Ubuntu 25.10 with Tomcat 9.0.108
- **Management Scripts**: Comprehensive `runTomcat.sh` script with start/stop/logs/clean commands
- **Volume Mapping**: Persistent storage for webapps, logs, and configuration
- **Health Monitoring**: Built-in health checks and non-root user security
- **Demo Applications**: Pre-loaded with interactive HTML demos including:
  - Bernoulli principle animations (Claude and GPT-5 versions)
  - AI model comparison pages (DeepSeek, Kimi-dev, Qwen3-coder)
  - Interactive scientific visualizations

**Access Points**:
- Main Application: http://localhost:8090
- Manager App: http://localhost:8090/manager (admin/admin)
- Host Manager: http://localhost:8090/host-manager

See [Tomcat/README.md](Tomcat/README.md) for detailed setup and management instructions.

### WeChat Bot Integration

The project includes WeChat bot integration through the `WeChatRobot` directory, featuring:
- **ChatGPT Integration**: Uses `zhayujie/chatgpt-on-wechat` image for WeChat automation
- **Enhanced Security**: Configured with `seccomp:unconfined` security option for optimal compatibility
- **Flexible Configuration**: Support for various AI models and custom API endpoints
- **Chat Modes**: Single chat prefix (`["bot", "@bot"]`) and group chat support
- **Creative Features**: Image creation with prefixes `["画", "看", "找"]` (draw, see, find)
- **Memory Management**: Configurable conversation max tokens (1000 default)
- **Multi-language**: Built-in multilingual support with customizable character description
- **Plugin System**: Global plugin configuration support and LinkAI integration options

**Quick Start**:
```bash
cd WeChatRobot
# Edit docker-compose.yml to set your OPEN_AI_API_KEY and other settings
docker-compose up -d
# WeChat bot service will be accessible on port 9899
```

**Key Configuration**:
- Set `OPEN_AI_API_KEY` to your OpenAI API key
- Configure `MODEL` for specific AI model (empty for default)
- Adjust `GROUP_NAME_WHITE_LIST` for allowed group chats
- Customize `CHARACTER_DESC` for bot personality

### Jenkins CI/CD Integration

The project includes Jenkins integration for continuous integration and deployment workflows:
- **Custom Build Environment**: Docker-based Jenkins with customizable build context
- **Port Configuration**: Accessible on port 8090 with agent port 50000
- **Persistent Storage**: Volume mapping for Jenkins data and job configurations
- **Easy Setup**: Simple docker-compose configuration for quick deployment

**Quick Start**:
```bash
cd Jenkins
docker-compose up -d
# Access Jenkins at http://localhost:8090
```

### MySQL Database Integration

Alternative database option through MySQL integration for workflows requiring MySQL:
- **Latest MySQL**: Uses mysql:latest image with optimized configuration
- **Security**: Configured with secure passwords and user permissions
- **Port Mapping**: Accessible on port 3308 to avoid conflicts
- **Persistent Storage**: Dedicated volume for MySQL data persistence
- **Pre-configured Database**: Includes sample database and user setup

**Configuration**:
- Root Password: `9ol.6yhn3edc`
- User: `study` with Password: `5tgb3edc1qaz`
- Database: `mysql`
- Port: `3308` (host) → `3306` (container)

**Quick Start**:
```bash
cd Mysql
docker-compose up -d
# Connect to MySQL at localhost:3308
```

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

## Access Points

Once the services are running, you can access them at:

- **N8N Interface**: http://localhost:5678
- **Tomcat Server**: http://localhost:8090 (when Tomcat service is running)
  - Manager App: http://localhost:8090/manager (admin/admin)
- **Jenkins CI/CD**: http://localhost:8090 (when Jenkins service is running)
- **MySQL Database**: localhost:3308 (when MySQL service is running)
- **WeChat Bot**: Configured through the WeChat application after setup (service on port 9899)

**Note**: Tomcat and Jenkins both use port 8090 by default. Run only one service at a time or modify port configurations to avoid conflicts.

## Troubleshooting

### Docker Build Issues
This Docker image includes China-optimized mirror sources that resolve most network-related build issues. However, if you encounter dependency conflicts during Docker image build:

1. **Repository Management**: Uses Alibaba Cloud mirror for faster and more reliable Alpine package downloads
2. **Package Updates**: Performs `apk update` and `apk upgrade` with China mirrors before installing dependencies
3. **Dependency Priority**: Explicitly installs `openssl` and `openssl-dev` early to prioritize their resolution
4. **PEP 668 Compatibility**: Upgrades pip with `--break-system-packages` flag using Tsinghua University mirror
5. **UV Installation**: Uses official uv installation method with China mirror for reliable package management

**Common Issues Resolved by China Mirrors**:
- ❌ Connection timeouts when downloading from default international mirrors
- ❌ Slow package downloads in China regions
- ❌ Intermittent network failures during build
- ❌ npm package installation failures
- ❌ pip package download timeouts

**Solutions**:
- **Network Issues**: China mirror sources should resolve most network problems
- **Force Rebuild**: `docker-compose up --build --force-recreate`
- **Clear Cache**: `docker system prune -a` (only if necessary)
- **Verify Mirrors**: Check mirror configuration as described in the [China Mirror Sources Configuration](#china-mirror-sources-configuration) section

### Playwright Issues
If Playwright nodes don't work properly:
1. **Container Startup**: Ensure the container has fully started (setup script runs in background)
2. **Symlink Creation**: Check that browser symlinks were created automatically (monitor runs every 10 seconds)
3. **Environment Variables**: Verify all Playwright environment variables are correctly set
4. **Node Installation**: If Playwright node was installed after container start, restart the container to trigger symlink creation
5. **Browser Detection**: Check that `/usr/bin/chromium-browser` exists and is executable
6. **Monitor Process**: The background monitor should create symlinks for versions 1129-1135 automatically

**Debug Commands**:
```bash
# Check if Chromium is working
docker exec <container> /usr/bin/chromium-browser --version
# Check for symlinks
docker exec <container> find /home/node/.n8n -name "chrome" -type l
# View monitor logs
docker logs <container> | grep -i playwright
```

### Running Scripts
We provide several scripts for different scenarios:
- `runMe.sh`: Builds and runs with force recreate (good for fresh installs)
- `runNewN8n.sh`: Runs with PostgreSQL configuration
- `docker-compose.yml`: Default setup with SQLite
- `docker-compose-postgre.yml`: PostgreSQL setup

## Project Documentation

The project includes comprehensive documentation for different development contexts:

- **[CLAUDE.md](CLAUDE.md)**: Development guide for Claude Code AI assistant
- **[QWEN.md](QWEN.md)**: Detailed project context and architecture documentation
- **[README_cn.md](README_cn.md)**: Chinese version of this documentation

## Project Structure
```
workflow-n8n/
├── .claude/                          # Claude AI assistant configuration
├── .gitignore                        # Git ignore rules
├── AI-workflow-Demo.mp4             # Demo video file
├── CLAUDE.md                        # Claude Code development guide
├── Dockerfile                       # Main n8n container definition
├── QWEN.md                          # Project context and architecture documentation
├── README.md                        # Main documentation (English)
├── README_cn.md                     # Chinese documentation
├── docker-compose.yml               # SQLite setup configuration
├── docker-compose-postgre.yml       # PostgreSQL setup configuration
├── n8n_mcp_demo.gif                # Demo GIF animation
├── playwright-setup.sh              # Playwright browser automation setup
├── runMe.sh                         # SQLite deployment script
├── runNewN8n.sh                     # PostgreSQL deployment script
├── conf/                            # N8N configuration (volume mount)
├── logs/                            # Application logs (volume mount)
├── n8n_data/                        # N8N data persistence (volume mount)
├── webapps/                         # Web applications (volume mount)
├── Jenkins/                         # Jenkins CI/CD integration
│   ├── Dockerfile                   # Jenkins container definition
│   ├── docker-compose.yml          # Jenkins service configuration
│   ├── runJenkins.sh               # Jenkins deployment script
│   └── data/                        # Jenkins runtime data (gitignored)
├── Mysql/                           # MySQL database integration
│   ├── docker-compose.yml          # MySQL service configuration
│   ├── runMe.sh                     # MySQL deployment script
│   ├── DBeaver-Connection-Guide.md  # Database connection guide
│   └── DBeaver-Setup-Instructions.md # DBeaver setup documentation
├── Tomcat/                          # Tomcat web server
│   ├── .claude/                     # Claude configuration for Tomcat
│   ├── Dockerfile                   # Tomcat container definition
│   ├── README.md                    # Tomcat-specific documentation
│   ├── docker-compose.yml          # Tomcat service configuration
│   ├── runTomcat.sh                # Tomcat management script
│   ├── conf/                        # Tomcat configuration files
│   ├── logs/                        # Tomcat logs (gitignored)
│   └── webapps/                     # Tomcat web applications
└── WeChatRobot/                     # WeChat bot integration (gitignored)
    ├── config.json                  # WeChat bot configuration
    ├── docker-compose.yml          # WeChat service configuration
    └── runMe.sh                     # WeChat bot deployment script
```

---

## Getting Help

For support, please open an issue on GitHub.
