# Tomcat Docker Setup

This directory contains a complete Docker setup for Apache Tomcat with OpenJDK 21 on Ubuntu 25.10, including interactive demo web applications.

## 📋 Features

- **Base Image**: Ubuntu 25.10
- **Java Version**: OpenJDK 21
- **Tomcat Version**: 9.0.108
- **Maintainer**: tobecrazy@qq.com
- **Configuration Mapping**: Local config files mapped to container
- **Volume Mapping**: webapps, logs, and conf directories
- **Health Check**: Built-in health monitoring
- **Security**: Runs as non-root tomcat user
- **Demo Applications**: Pre-loaded with interactive HTML demos and scientific visualizations

## 📁 Directory Structure

```
Tomcat/
├── Dockerfile              # Main Docker image definition
├── docker-compose.yml      # Docker Compose configuration
├── runTomcat.sh            # Management script
├── README.md               # This file
├── webapps/                # Web applications (auto-created)
│   ├── ROOT/               # Root application with demos
│   │   ├── index.html      # Main demo index
│   │   ├── bernoulli-principle-animation-claude.html
│   │   ├── bernoulli-principle-animation-gpt5.html
│   │   ├── deepseekr10528.html
│   │   ├── kimi-dev.html
│   │   └── qwen3-coder.html
│   ├── manager/            # Tomcat Manager application
│   └── host-manager/       # Tomcat Host Manager application
├── logs/                   # Tomcat logs (auto-created)
└── conf/                   # Configuration files (auto-created)
```

## 🚀 Quick Start

### 1. Build and Start Tomcat

```bash
# Make the script executable (if not already)
chmod +x runTomcat.sh

# Start Tomcat (builds image, copies config, starts container)
./runTomcat.sh start
```

### 2. Access Tomcat

- **Main Application**: http://localhost:8090
- **Manager App**: http://localhost:8090/manager
- **Host Manager**: http://localhost:8090/host-manager

**Default Credentials**: admin/admin

## 🛠️ Management Commands

The `runTomcat.sh` script provides several management options:

```bash
./runTomcat.sh [COMMAND]

Commands:
  start     Build and start Tomcat container (default)
  build     Build Docker image only
  stop      Stop Tomcat container
  restart   Restart Tomcat container
  logs      Show container logs
  status    Show container status
  clean     Stop container and clean up
  help      Show help message
```

### Examples

```bash
# Start Tomcat
./runTomcat.sh start

# View logs
./runTomcat.sh logs

# Restart Tomcat
./runTomcat.sh restart

# Stop Tomcat
./runTomcat.sh stop

# Clean up everything
./runTomcat.sh clean
```

## 📂 Volume Mappings

The following directories are mapped between host and container:

| Host Directory | Container Directory | Purpose |
|----------------|-------------------|---------|
| `./webapps` | `/opt/tomcat/webapps` | Web applications |
| `./logs` | `/opt/tomcat/logs` | Tomcat logs |
| `./conf` | `/opt/tomcat/conf` | Configuration files |

## ⚙️ Configuration

### Initial Setup

When you first run the container, the script will:

1. Create necessary directories (`webapps`, `logs`, `conf`)
2. Copy initial Tomcat configuration files to `./conf/`
3. Start the container with volume mappings

### Customizing Configuration

After the initial run, you can modify configuration files in the `./conf/` directory:

- `server.xml` - Main server configuration
- `web.xml` - Default web application configuration
- `tomcat-users.xml` - User authentication
- `context.xml` - Default context configuration
- `logging.properties` - Logging configuration

Changes will be reflected when you restart the container.

### Environment Variables

The container uses the following environment variables:

- `JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64`
- `CATALINA_HOME=/opt/tomcat`
- `CATALINA_BASE=/opt/tomcat`
- `CATALINA_TMPDIR=/opt/tomcat/temp`
- `JAVA_OPTS=-Xmx512m -Xms256m` (configurable in docker-compose.yml)

## 🔧 Troubleshooting

### Container Won't Start

1. Check if port 8090 is already in use:
   ```bash
   lsof -i :8090
   ```

2. View container logs:
   ```bash
   ./runTomcat.sh logs
   ```

3. Check container status:
   ```bash
   ./runTomcat.sh status
   ```

### Permission Issues

If you encounter permission issues with mounted volumes:

```bash
# Fix permissions
sudo chown -R $USER:$USER webapps logs conf
```

### Configuration Issues

If configuration files are corrupted:

1. Stop the container:
   ```bash
   ./runTomcat.sh stop
   ```

2. Remove the conf directory:
   ```bash
   rm -rf conf
   ```

3. Restart to get fresh config files:
   ```bash
   ./runTomcat.sh start
   ```

## 🔒 Security Notes

- The container runs as a non-root `tomcat` user for security
- Default admin credentials should be changed in production (edit `conf/tomcat-users.xml`)
- Consider using environment variables for sensitive configuration
- The manager applications are enabled by default - disable in production if not needed
- Demo applications are for development/testing - remove in production environments
- Ensure proper file permissions when deploying custom applications

## 🌐 Integration with workflow-n8n

This Tomcat server is part of the larger workflow-n8n ecosystem and can be used for:
- **Web Application Hosting**: Deploy Java web applications that integrate with n8n workflows
- **API Endpoints**: Create REST APIs that can be called from n8n HTTP Request nodes
- **Webhook Receivers**: Set up webhook endpoints to receive data from external systems
- **Static Content Hosting**: Serve HTML dashboards and reports generated by n8n workflows
- **Development Testing**: Use the demo applications as testing endpoints for n8n workflows

**Port Configuration Note**: Tomcat uses port 8090 by default. If running alongside Jenkins (which also uses port 8090), modify the port mapping in `docker-compose.yml`:
```yaml
ports:
  - "8091:8080"  # Use 8091 instead of 8090
```

## 📝 Deployment

## 🎯 Demo Applications

The Tomcat server comes with pre-installed demo applications in the `ROOT` context:

### Interactive Scientific Demonstrations
- **Bernoulli Principle Animations**: 
  - `bernoulli-principle-animation-claude.html` - Claude-generated visualization
  - `bernoulli-principle-animation-gpt5.html` - GPT-5 generated visualization
- **AI Model Comparison Pages**:
  - `deepseekr10528.html` - DeepSeek model demonstration
  - `kimi-dev.html` - Kimi development interface
  - `qwen3-coder.html` - Qwen3 coding assistant demo

### Accessing Demo Applications
- **Main Demo Index**: http://localhost:8090/
- **Specific Demos**: http://localhost:8090/bernoulli-principle-animation-claude.html

## 🚀 Deploying Applications

### Deploying WAR Files
1. Copy your WAR files to the `webapps` directory:
   ```bash
   cp myapp.war webapps/
   ```

2. Tomcat will automatically deploy the application

3. Access your application at: http://localhost:8090/myapp

### Deploying Static Content
1. Copy your static files to the `webapps/ROOT/` directory:
   ```bash
   cp -r my-static-site/* webapps/ROOT/
   ```

2. Access your content at: http://localhost:8090/

### Deploying Web Applications
1. Create a new directory in `webapps/`:
   ```bash
   mkdir webapps/myapp
   cp -r myapp-files/* webapps/myapp/
   ```

2. Access your application at: http://localhost:8090/myapp/

### Production Considerations

- Change default passwords in `conf/tomcat-users.xml`
- Configure proper logging levels in `conf/logging.properties`
- Adjust JVM memory settings in `docker-compose.yml`
- Use proper SSL certificates for HTTPS
- Consider using a reverse proxy (nginx/Apache) in front of Tomcat

## 🐳 Docker Commands

If you prefer using Docker commands directly:

```bash
# Build image
docker-compose build

# Start container
docker-compose up -d

# Stop container
docker-compose down

# View logs
docker-compose logs -f

# Execute commands in container
docker-compose exec tomcat bash
```

## 📊 Health Check

The container includes a health check that:
- Runs every 30 seconds
- Times out after 10 seconds
- Allows 40 seconds for startup
- Retries 3 times before marking as unhealthy

Check health status:
```bash
docker ps
# Look for "healthy" status
```

## 🤝 Support

For issues or questions:
- Check the logs: `./runTomcat.sh logs`
- Review Tomcat documentation: https://tomcat.apache.org/
- Check the main project documentation: [../README.md](../README.md)
- Contact: tobecrazy@qq.com

## 📝 Additional Resources

- **Apache Tomcat Documentation**: https://tomcat.apache.org/tomcat-9.0-doc/
- **OpenJDK 21 Documentation**: https://openjdk.org/projects/jdk/21/
- **Docker Best Practices**: https://docs.docker.com/develop/dev-best-practices/
- **workflow-n8n Project**: https://github.com/tobecrazy/workflow-n8n
