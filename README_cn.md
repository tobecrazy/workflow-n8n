# workflow-n8n / 工作流自动化平台

![n8n Logo](https://user-images.githubusercontent.com/10284570/173569848-c624317f-42b1-45a6-ab09-f0ea3c247648.png)

### 概述
本项目提供了一个定制化的n8n工作流自动化平台，具有额外的Python集成功能和Playwright浏览器自动化支持。n8n是一个可扩展的工作流自动化工具，可以连接任何具有API的应用程序。

### 功能特点
- 🚀 预配置的Docker环境
- 🐍 支持Python自定义节点（包含uv包管理器）
- 🌐 Playwright浏览器自动化支持
- 🔄 简便的工作流管理
- 🔒 安全的凭证处理
- 🐳 Tomcat服务器用于Web应用程序
- 🛠️ 内置支持模型上下文协议（MCP）服务器

### 快速开始

#### 选项 1: 使用 Docker Compose (默认 SQLite)
```bash
docker-compose up -d
```

#### 选项 2: 使用 PostgreSQL
```bash
docker-compose -f docker-compose-postgre.yml up -d
```

#### 选项 3: 构建并运行全新安装
```bash
# 使用自动构建和强制重建运行
./runMe.sh
# 或手动运行：
docker-compose up --build -d --force-recreate
```

#### 选项 4: 运行 PostgreSQL 配置
```bash
./runNewN8n.sh
# 或手动运行：
docker-compose -f docker-compose-postgre.yml up -d --force-recreate
```

### 安装
```bash
# 克隆仓库
git clone https://github.com/tobecrazy/workflow-n8n.git
cd workflow-n8n

# 拉取最新的预构建镜像（本地构建的替代方案）
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

### Python 和包管理

此设置包含最新的 uv 包管理器，用于更快的 Python 包安装。容器包括：
- Python 3 和 pip
- uv (快速 Python 包安装程序和解析器)
- Python 扩展的必要构建工具
```
# 在容器中安装 Python 包的示例
pip install package-name
# 或使用 uv (更快)
uv pip install package-name
```

### 截图
![工作流示例](n8n_mcp_demo.gif)

### Playwright浏览器自动化
此n8n设置包含Playwright用于浏览器自动化，具有以下功能：

- **系统依赖**: Docker镜像包含Playwright和Chromium所需的所有系统依赖，包括nss、freetype、harfbuzz、ttf-freefont、gcompat、bash、dbus、fontconfig、mesa-gl、udev和xvfb。
- **Chromium浏览器**: 使用系统自带的Chromium浏览器以获得更好的性能和兼容性。包含chromium-chromedriver。
- **设置脚本**: 容器启动时会运行`playwright-setup.sh`脚本来配置环境，确保Playwright可以找到并使用系统的Chromium实例。
- **环境变量**: 正确配置的环境变量，包括`PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1`、`PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser`等，以防止Playwright下载自己的浏览器二进制文件并确保无缝集成。
- **n8n节点支持**: 完全支持n8n的Playwright节点，用于构建基于浏览器的自动化工作流。
- **持续监控**: 设置包含一个后台进程，监控n8n-nodes-playwright安装，并为Playwright正确工作创建必要的目录结构和符号链接。
- **浏览器符号链接**: 为Playwright节点期望找到的不同浏览器版本创建多个符号链接和目录结构。

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

获取这些API密钥的方法：
- **Brave API密钥**: 在 https://brave.com/search/api/ 注册
- **OpenAI API密钥**: 在 https://platform.openai.com/api-keys 创建一个
- **Serper API密钥**: 从 https://serper.dev/ 获取
- **Weather API密钥**: 可用多种提供商（如OpenWeatherMap、WeatherAPI）

MCP（Model Context Protocol）使n8n工作流能够通过标准化接口访问外部工具和服务，扩展了自动化可能性的范围。

### 故障排除

#### Docker 构建问题
如果在 Docker 镜像构建过程中遇到依赖冲突，特别是在 Alpine Linux 上与 `openssl-dev` 相关的问题，这很可能是由于 Alpine 稳定版和 `edge` 仓库之间的不一致造成的。`Dockerfile` 已更新以解决此问题，具体措施如下：

1.  确保同时使用 `main` 和 `community` `edge` 仓库。
2.  执行 `apk update` 和 `apk upgrade` 以更新现有软件包。
3.  在 `apk add` 命令中，将 `openssl` 和 `openssl-dev` 明确放在前面，以优先解决它们的依赖关系。

如果仍然遇到问题，请确保清除 Docker 缓存，并尝试使用 `docker-compose up --build --force-recreate` 重新构建。

#### Playwright 问题
如果 Playwright 节点无法正常工作：
1. 确保容器已完全启动（设置脚本在后台运行）
2. 检查必要的符号链接是否已创建（应自动完成）
3. 验证环境变量是否正确设置
4. 后台监控器会根据需要创建符号链接，但如果容器启动后安装了 Playwright 节点，可能需要重新启动容器

#### 运行脚本
我们提供几种脚本用于不同场景：
- `runMe.sh`: 构建并运行强制重建（适用于全新安装）
- `runNewN8n.sh`: 使用 PostgreSQL 配置运行
- `docker-compose.yml`: 使用 SQLite 的默认设置
- `docker-compose-postgre.yml`: PostgreSQL 设置

---

## 获取帮助
如需支持，请在GitHub上提交issue。