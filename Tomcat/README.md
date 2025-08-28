# Tomcat Docker Setup

This directory contains a complete Docker setup for Apache Tomcat with OpenJDK 21 on Ubuntu 25.10.

## 📋 Features

- **Base Image**: Ubuntu 25.10
- **Java Version**: OpenJDK 21
- **Tomcat Version**: 9.0.108
- **Maintainer**: tobecrazy@qq.com
- **Configuration Mapping**: Local config files mapped to container
- **Volume Mapping**: webapps, logs, and conf directories
- **Health Check**: Built-in health monitoring
- **Security**: Runs as non-root tomcat user

## 📁 Directory Structure

```
Tomcat/
├── Dockerfile              # Main Docker image definition
├── docker-compose.yml      # Docker Compose configuration
├── runTomcat.sh            # Management script
├── README.md               # This file
├── webapps/                # Web applications (auto-created)
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
- Default admin credentials should be changed in production
- Consider using environment variables for sensitive configuration
- The manager applications are enabled by default - disable in production if not needed

## 📝 Deployment

### Deploying Applications

1. Copy your WAR files to the `webapps` directory:
   ```bash
   cp myapp.war webapps/
   ```

2. Tomcat will automatically deploy the application

3. Access your application at: http://localhost:8090/myapp

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
- Contact: tobecrazy@qq.com
