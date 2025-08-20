# workflow-n8n / 工作流自动化平台

![n8n Logo](https://user-images.githubusercontent.com/10284570/173569848-c624317f-42b1-45a6-ab09-f0ea3c247648.png)

## English Version

### Overview
This project provides a customized n8n workflow automation platform with additional Python integration capabilities. n8n is an extendable workflow automation tool that enables you to connect any app with an API.

### Features
- 🚀 Pre-configured Docker setup
- 🐍 Python integration for custom nodes
- 🔄 Easy workflow management
- 🔒 Secure credential handling

### Installation
```bash
docker pull tobecrazy/n8n-python:latest
docker-compose up -d
```

### Configuration
Environment variables can be set in `.env` file:
```
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=password
DB_TYPE=postgresdb
DB_POSTGRESDB_DATABASE=n8n_Database
DB_POSTGRESDB_HOST=db
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_USER=n8n_user
DB_POSTGRESDB_SCHEMA=public
DB_POSTGRESDB_PASSWORD=dbn8n@2025
N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true
```

### Screenshot
![Workflow Example](https://raw.githubusercontent.com/n8n-io/n8n/master/assets/n8n-screenshot-readme.png)

---

## 中文版本

### 概述
本项目提供了一个定制化的n8n工作流自动化平台，具有额外的Python集成功能。n8n是一个可扩展的工作流自动化工具，可以连接任何具有API的应用程序。

### 功能特点
- 🚀 预配置的Docker环境
- 🐍 支持Python自定义节点
- 🔄 简便的工作流管理
- 🔒 安全的凭证处理

### 安装
```bash
docker pull tobecrazy/n8n-python:latest
docker-compose up -d
```

### 配置
环境变量可在`.env`文件中设置：
```
N8N_BASIC_AUTH_USER=admin
N8N_BASIC_AUTH_PASSWORD=password
DB_TYPE=postgresdb
DB_POSTGRESDB_DATABASE=n8n_Database
DB_POSTGRESDB_HOST=db
DB_POSTGRESDB_PORT=5432
DB_POSTGRESDB_USER=n8n_user
DB_POSTGRESDB_SCHEMA=public
DB_POSTGRESDB_PASSWORD=dbn8n@2025
N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true
```

### 截图
![工作流示例](n8n_mcp_demo.gif)

### Troubleshooting Docker Build Issues

If you encounter dependency conflicts during the Docker image build, especially related to `openssl-dev` on Alpine Linux, it's likely due to inconsistencies between Alpine's stable and `edge` repositories. The `Dockerfile` has been updated to address this by:

1.  Ensuring both `main` and `community` `edge` repositories are used.
2.  Performing `apk update` and `apk upgrade` to update existing packages.
3.  Explicitly installing `openssl` and `openssl-dev` early in the `apk add` command to prioritize their dependency resolution.

If you still face issues, ensure your Docker cache is cleared and try rebuilding with `docker-compose up --build --force-recreate`.

---

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
