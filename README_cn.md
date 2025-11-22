# workflow-n8n / 工作流自动化平台

![n8n Logo](https://user-images.githubusercontent.com/10284570/173569848-c624317f-42b1-45a6-ab09-f0ea3c247648.png)

**English** | [中文](README_cn.md)

## 概述

本项目提供了一个基于n8n的综合工作流自动化平台，具有广泛的增强功能，包括Python集成、Playwright浏览器自动化、微信机器人集成和多种部署选项。该平台扩展了标准n8n功能，增加了额外的基础设施组件，包括Jenkins CI/CD、带有演示应用程序的Tomcat Web服务器、多种数据库选项（SQLite、PostgreSQL、MySQL），以及支持AI驱动工作流的模型上下文协议（MCP）服务器。

## 功能特点

- 🚀 预配置的Docker设置，包含定制n8n镜像
- 🐍 Python 3集成支持自定义节点（包含uv包管理器）
- 🌐 Playwright浏览器自动化，使用系统Chromium
- 🔄 简便的工作流管理，提供多种部署脚本
- 🔒 安全的凭证处理和环境配置
- 🐳 Tomcat 9.0.108服务器，配备OpenJDK 21和演示Web应用程序
- 🛠️ 内置支持模型上下文协议（MCP）服务器
- 💬 使用zhayujie/chatgpt-on-wechat的微信机器人ChatGPT集成
- 🔧 Jenkins CI/CD集成，配备可定制构建环境
- 🗄️ 多种数据库选项（默认SQLite、PostgreSQL、MySQL）
- 📦 使用uv进行高级包管理，实现更快的Python安装
- 🎭 持续Playwright监控和自动符号链接创建
- 🌏 中国地区优化的镜像源，提供更快的下载速度

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
# MCP服务器环境变量
MCP_BRAVE_API_KEY=your-brave-api-key
MCP_OPENAI_API_KEY=your-openai-key
MCP_SERPER_API_KEY=your-serper-key
MCP_WEATHER_API_KEY=your-weather-api-key

# 时区配置
GENERIC_TIMEZONE=Asia/Shanghai
TZ=Asia/Shanghai

# 安全设置
N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

# 启用/禁用执行器 (设置为 true 以使用)
N8N_RUNNERS_ENABLED=true

# SQLite 连接池大小
DB_SQLITE_POOL_SIZE=10

# 允许社区包使用工具
N8N_COMMUNITY_PACKAGES_ALLOW_TOOL_USAGE=true

# 基本认证（可选）
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

## 中国镜像源配置

此 Docker 镜像针对中国地区用户进行了优化，预配置了镜像源以确保快速可靠的下载：

### 已配置的镜像源：

- **Alpine Linux**: 使用阿里云镜像 (`mirrors.aliyun.com`) 实现快速包安装
- **Python pip**: 使用清华大学镜像 (`pypi.tuna.tsinghua.edu.cn/simple`) 安装 Python 包
- **Node.js npm**: 使用淘宝 npm 镜像 (`registry.npmmirror.com`) 安装 Node.js 包
- **uv 包管理器**: 使用清华大学镜像实现快速 Python 包管理

### 优势：

- 🚀 **更快下载**: 在中国地区显著加快包下载速度
- 🔒 **可靠连接**: 减少连接失败和超时
- 📦 **全面覆盖**: 所有包管理器 (apk, pip, npm, uv) 都已优化
- 🛡️ **自动回退**: 使用高可用的可信镜像

### 镜像源验证：

您可以验证镜像源是否正常工作：

```bash
# 检查 Alpine 包源
docker exec <container> cat /etc/apk/repositories

# 检查 pip 配置
docker exec -u node <container> cat /home/node/.pip/pip.conf

# 检查 npm 配置
docker exec -u node <container> npm config get registry
```

## Python 和包管理

此设置包含最新的 uv 包管理器，用于更快的 Python 包安装。容器包括：
- Python 3 和 pip（升级到最新版本，兼容PEP 668）
- uv 和 uvx（快速Python包安装程序和解析器，通过官方方法安装）
- Python 扩展的必要构建工具（gcc、musl-dev、libffi-dev）
- 系统命令别名（python3→python、pip3→pip）提供便利

```
# 在容器中安装 Python 包的示例
pip install package-name
# 或使用 uv (更快，推荐)
uv pip install package-name
# 或使用 uvx 直接运行工具
uvx tool-name
```

### 截图
![工作流示例](n8n_mcp_demo.gif)

## Playwright浏览器自动化

此n8n设置包含具有高级功能的综合Playwright浏览器自动化：

- **系统依赖**: 预装所有必要的系统依赖，包括nss、freetype、harfbuzz、ttf-freefont、gcompat、bash、dbus、fontconfig、mesa-gl、udev和xvfb。
- **Chromium浏览器**: 使用Alpine Linux系统Chromium和chromium-chromedriver以获得最佳性能和兼容性。
- **高级设置脚本**: `playwright-setup.sh`在容器启动时运行，提供全面的环境配置和浏览器检测。
- **环境变量**: 完整的Playwright环境设置，包括`PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1`、`PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser`和Puppeteer兼容变量。
- **n8n节点支持**: 完全支持n8n的Playwright节点，具有自动浏览器检测和配置。
- **持续监控**: 后台进程监控n8n-nodes-playwright安装，动态创建必要的目录结构和符号链接。
- **多版本支持**: 为多个Playwright版本（1129-1135）创建浏览器符号链接以确保兼容性。
- **智能浏览器检测**: 实现假npx命令以跳过不必要的浏览器下载，直接使用系统Chromium。
- **Chrome包装脚本**: 创建具有适当沙盒设置的包装脚本，用于无头操作。

### 带演示应用程序的Tomcat服务器

本项目包含带有演示Web应用程序的完整Tomcat服务器设置：
- **基础**: Ubuntu 25.10上的OpenJDK 21，配备Tomcat 9.0.108
- **管理脚本**: 全面的`runTomcat.sh`脚本，支持启动/停止/日志/清理命令
- **卷映射**: webapps、日志和配置的持久存储
- **健康监控**: 内置健康检查和非root用户安全
- **演示应用程序**: 预装交互式HTML演示，包括：
  - 伯努利原理动画（Claude和GPT-5版本）
  - AI模型比较页面（DeepSeek、Kimi-dev、Qwen3-coder）
  - 交互式科学可视化

**访问点**：
- 主应用程序: http://localhost:8090
- 管理器应用: http://localhost:8090/manager (admin/admin)
- 主机管理器: http://localhost:8090/host-manager

有关详细的设置和管理说明，请参见[Tomcat/README.md](Tomcat/README.md)。

## MCP服务器配置

此n8n设置包含对模型上下文协议（MCP）服务器的内置支持。要配置MCP服务器，请在`docker-compose.yml`中设置以下环境变量：

```
MCP_BRAVE_API_KEY=your-brave-api-key
MCP_OPENAI_API_KEY=your-openai-key
MCP_SERPER_API_KEY=your-serper-key
MCP_WEATHER_API_KEY=your-weather-api-key
```

**获取API密钥**：
- **Brave API密钥**: 在 https://brave.com/search/api/ 注册
- **OpenAI API密钥**: 在 https://platform.openai.com/api-keys 创建一个
- **Serper API密钥**: 从 https://serper.dev/ 获取
- **Weather API密钥**: 可用多种提供商（如OpenWeatherMap、WeatherAPI）

MCP（Model Context Protocol）使n8n工作流能够通过标准化接口访问外部工具和服务，扩展了自动化可能性的范围。

## 微信机器人集成

项目通过`WeChatRobot`目录包含微信机器人集成，功能包括：
- **ChatGPT集成**: 使用`zhayujie/chatgpt-on-wechat`镜像进行微信自动化
- **增强安全性**: 配置了`seccomp:unconfined`安全选项以实现最佳兼容性
- **灵活配置**: 支持各种AI模型和自定义API端点
- **聊天模式**: 单聊前缀（`["bot", "@bot"]`）和群聊支持
- **创意功能**: 使用前缀`["画", "看", "找"]`进行图像创建（画、看、找）
- **内存管理**: 可配置的对话最大令牌数（默认1000）
- **多语言**: 内置多语言支持和可定制的角色描述
- **插件系统**: 全局插件配置支持和LinkAI集成选项

**快速开始**：
```bash
cd WeChatRobot
# 编辑docker-compose.yml设置您的OPEN_AI_API_KEY和其他设置
docker-compose up -d
```

**关键配置**：
- 设置`OPEN_AI_API_KEY`为您的OpenAI API密钥
- 配置`MODEL`以指定特定AI模型（留空使用默认）
- 调整`GROUP_NAME_WHITE_LIST`以允许群聊
- 自定义`CHARACTER_DESC`以设置机器人个性

## Jenkins CI/CD集成

项目包含Jenkins集成，用于持续集成和部署工作流：
- **自定义构建环境**: 基于Docker的Jenkins，配备可定制构建上下文
- **端口配置**: 在端口8090可访问，代理端口50000
- **持久存储**: Jenkins数据和作业配置的卷映射
- **简单设置**: 简单的docker-compose配置，便于快速部署

**快速开始**：
```bash
cd Jenkins
docker-compose up -d
# 在 http://localhost:8090 访问Jenkins
```

## MySQL数据库集成

通过MySQL集成为需要MySQL的工作流提供替代数据库选项：
- **最新MySQL**: 使用mysql:latest镜像，配备优化配置
- **安全性**: 配置安全密码和用户权限
- **端口映射**: 在端口3308可访问，避免冲突
- **持久存储**: MySQL数据持久化的专用卷
- **预配置数据库**: 包含示例数据库和用户设置

**配置**：
- Root密码: `9ol.6yhn3edc`
- 用户: `study`，密码: `5tgb3edc1qaz`
- 数据库: `mysql`
- 端口: `3308`（主机）→ `3306`（容器）

**快速开始**：
```bash
cd Mysql
docker-compose up -d
# 在 localhost:3308 连接MySQL
```

## 访问点

服务运行后，您可以在以下地址访问：

- **N8N界面**: http://localhost:5678
- **Tomcat服务器**: http://localhost:8090（当Tomcat服务运行时）
  - 管理器应用: http://localhost:8090/manager (admin/admin)
- **Jenkins CI/CD**: http://localhost:8090（当Jenkins服务运行时）
- **MySQL数据库**: localhost:3308（当MySQL服务运行时）
- **微信机器人**: 设置后通过微信应用程序配置

**注意**: Tomcat和Jenkins默认都使用端口8090。一次只运行一个服务或修改端口配置以避免冲突。

## 故障排除

### Docker 构建问题
此 Docker 镜像包含了中国优化的镜像源，可解决大部分网络相关的构建问题。但如果在构建过程中仍遇到依赖冲突：

1. **仓库管理**: 使用阿里云镜像实现更快、更可靠的 Alpine 包下载
2. **包更新**: 在安装依赖前使用中国镜像执行 `apk update` 和 `apk upgrade`
3. **依赖优先级**: 早期显式安装 `openssl` 和 `openssl-dev` 以优先解决其依赖关系
4. **PEP 668兼容性**: 使用清华大学镜像和 `--break-system-packages` 标志升级 pip
5. **UV安装**: 使用官方 uv 安装方法配合中国镜像确保可靠的包管理

**中国镜像解决的常见问题**：
- ❌ 从默认国际镜像下载时的连接超时
- ❌ 中国地区包下载速度慢
- ❌ 构建过程中间歇性网络故障
- ❌ npm 包安装失败
- ❌ pip 包下载超时

**解决方案**：
- **网络问题**: 中国镜像源应能解决大部分网络问题
- **强制重建**: `docker-compose up --build --force-recreate`
- **清除缓存**: `docker system prune -a`（仅在必要时）
- **验证镜像**: 检查镜像配置，参考[中国镜像源配置](#中国镜像源配置)章节

### Playwright 问题
如果Playwright节点无法正常工作：
1. **容器启动**: 确保容器已完全启动（设置脚本在后台运行）
2. **符号链接创建**: 检查浏览器符号链接是否自动创建（监控器每10秒运行一次）
3. **环境变量**: 验证所有Playwright环境变量是否正确设置
4. **节点安装**: 如果在容器启动后安装Playwright节点，重启容器以触发符号链接创建
5. **浏览器检测**: 检查`/usr/bin/chromium-browser`是否存在且可执行
6. **监控进程**: 后台监控器应自动为版本1129-1135创建符号链接

**调试命令**：
```bash
# 检查Chromium是否工作
docker exec <container> /usr/bin/chromium-browser --version
# 检查符号链接
docker exec <container> find /home/node/.n8n -name "chrome" -type l
# 查看监控器日志
docker logs <container> | grep -i playwright
```

### 运行脚本
我们提供几种脚本用于不同场景：
- `runMe.sh`: 构建并运行强制重建（适用于全新安装）
- `runNewN8n.sh`: 使用PostgreSQL配置运行
- `docker-compose.yml`: 使用SQLite的默认设置
- `docker-compose-postgre.yml`: PostgreSQL设置

---

## 获取帮助

如需支持，请在GitHub上提交issue。