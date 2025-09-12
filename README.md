# workflow-n8n / 工作流自动化平台

![n8n Logo](https://user-images.githubusercontent.com/10284570/173569848-c624317f-42b1-45a6-ab09-f0ea3c247648.png)

## English Version

### Overview
This project provides a customized n8n workflow automation platform with additional Python integration capabilities and Playwright browser automation support. n8n is an extendable workflow automation tool that enables you to connect any app with an API.

### Features
- 🚀 Pre-configured Docker setup
- 🐍 Python integration for custom nodes
- 🌐 Playwright browser automation support
- 🔄 Easy workflow management
- 🔒 Secure credential handling
- 🐳 Tomcat server for web applications

### Installation
```bash
docker pull tobecrazy/n8n-python:latest
docker-compose up -d
```

### Configuration
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

### Screenshot
![Workflow Example](n8n_mcp_demo.gif)

### Playwright Browser Automation
This n8n setup includes Playwright for browser automation, with the following features:

- **System Dependencies**: The Docker image includes all necessary system dependencies for Playwright and Chromium.
- **Chromium Browser**: Uses the system's own Chromium browser for better performance and compatibility.
- **Setup Script**: A `playwright-setup.sh` script runs on container startup to configure the environment, ensuring Playwright can locate and use the system's Chromium instance.
- **Environment Variables**: The `PLAYWRIGHT_BROWSERS_PATH` is set to `0` to prevent Playwright from downloading its own browser binaries, and other variables are configured for seamless integration.
- **n8n Node Support**: Fully supports n8n's Playwright nodes for building browser-based automation workflows.

### Tomcat Server
This project also includes a complete Tomcat server setup with:
- OpenJDK 21 on Ubuntu 25.10
- Tomcat 9.0.108
- Docker container management script
- Volume mapping for webapps, logs, and configuration
- Health check monitoring
- Non-root user security

See [Tomcat/README.md](Tomcat/README.md) for detailed Tomcat setup and management instructions.

### MCP Server Configuration
This n8n setup includes built-in support for Model Context Protocol (MCP) servers. To configure MCP servers, set the following environment variables in `docker-compose.yml`:
```
MCP_BRAVE_API_KEY=your-brave-api-key
MCP_OPENAI_API_KEY=your-openai-key
MCP_SERPER_API_KEY=your-serper-key
MCP_WEATHER_API_KEY=your-weather-api-key
```

### Troubleshooting Docker Build Issues

If you encounter dependency conflicts during the Docker image build, especially related to `openssl-dev` on Alpine Linux, it's likely due to inconsistencies between Alpine's stable and `edge` repositories. The `Dockerfile` has been updated to address this by:

1.  Ensuring both `main` and `community` `edge` repositories are used.
2.  Performing `apk update` and `apk upgrade` to update existing packages.
3.  Explicitly installing `openssl` and `openssl-dev` early in the `apk add` command to prioritize their dependency resolution.

If you still face issues, ensure your Docker cache is cleared and try rebuilding with `docker-compose up --build --force-recreate`.

---

## 中文版本

### 概述
本项目提供了一个定制化的n8n工作流自动化平台，具有额外的Python集成功能和Playwright浏览器自动化支持。n8n是一个可扩展的工作流自动化工具，可以连接任何具有API的应用程序。

### 功能特点
- 🚀 预配置的Docker环境
- 🐍 支持Python自定义节点
- 🌐 Playwright浏览器自动化支持
- 🔄 简便的工作流管理
- 🔒 安全的凭证处理
- 🐳 Tomcat服务器用于Web应用程序

### 安装
```bash
docker pull tobecrazy/n8n-python:latest
docker-compose up -d
```

### 配置
环境变量可在`docker-compose.yml`或`.env`文件中设置：
```
# 启用/禁用执行器 (设置为 true 以使用)
N8N_RUNNERS_ENABLED=true

# SQLite 连接池大小
DB_SQLITE_POOL_SIZE=10

# 基本认证
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=password

# PostgreSQL (可选)
DB_TYPE=postgresdb
DB_POSTGRESDB_DATABASE=n8n_Database
DB_POSTGRESDB_HOST=db
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_USER=n8n_user
DB_POSTGRESDB_SCHEMA=public
DB_POSTGRESDB_PASSWORD=dbn8n@2025

# 允许社区包使用工具
N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true
```

### 截图
![工作流示例](n8n_mcp_demo.gif)

### Playwright浏览器自动化
此n8n设置包含Playwright用于浏览器自动化，具有以下功能：

- **系统依赖**: Docker镜像包含Playwright和Chromium所需的所有系统依赖。
- **Chromium浏览器**: 使用系统自带的Chromium浏览器以获得更好的性能和兼容性。
- **设置脚本**: 容器启动时会运行`playwright-setup.sh`脚本来配置环境，确保Playwright可以找到并使用系统的Chromium实例。
- **环境变量**: `PLAYWRIGHT_BROWSERS_PATH`设置为`0`以防止Playwright下载自己的浏览器二进制文件，并配置了其他变量以实现无缝集成。
- **n8n节点支持**: 完全支持n8n的Playwright节点，用于构建基于浏览器的自动化工作流。

### Tomcat服务器
本项目还包括一个完整的Tomcat服务器设置，包括：
- Ubuntu 25.10上的OpenJDK 21
- Tomcat 9.0.108
- Docker容器管理脚本
- webapps、日志和配置的卷映射
- 健康检查监控
- 非root用户安全

有关详细的Tomcat设置和管理说明，请参见[Tomcat/README.md](Tomcat/README.md)。

### MCP服务器配置
此n8n设置包含对模型上下文协议（MCP）服务器的内置支持。要配置MCP服务器，请在`docker-compose.yml`中设置以下环境变量：
```
MCP_BRAVE_API_KEY=your-brave-api-key
MCP_OPENAI_API_KEY=your-openai-key
MCP_SERPER_API_KEY=your-serper-key
MCP_WEATHER_API_KEY=your-weather-api-key
```

### Docker 构建问题排查

如果在 Docker 镜像构建过程中遇到依赖冲突，特别是在 Alpine Linux 上与 `openssl-dev` 相关的问题，这很可能是由于 Alpine 稳定版和 `edge` 仓库之间的不一致造成的。`Dockerfile` 已更新以解决此问题，具体措施如下：

1.  确保同时使用 `main` 和 `community` `edge` 仓库。
2.  执行 `apk update` 和 `apk upgrade` 以更新现有软件包。
3.  在 `apk add` 命令中，将 `openssl` 和 `openssl-dev` 明确放在前面，以优先解决它们的依赖关系。

如果仍然遇到问题，请确保清除 Docker 缓存，并尝试使用 `docker-compose up --build --force-recreate` 重新构建。

---

## Getting Help / 获取帮助
For support, please open an issue on GitHub.  
如需支持，请在GitHub上提交issue。
