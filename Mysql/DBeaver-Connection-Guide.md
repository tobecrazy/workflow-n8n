# DBeaver MySQL Connection Guide

## Problem Solved
The "Public Key Retrieval is not allowed" error has been fixed by configuring DBeaver to work with MySQL latest version's modern `caching_sha2_password` authentication method.

## Connection Settings for DBeaver

### Primary User Connection
- **Host:** localhost
- **Port:** 3308
- **Database:** mysql
- **Username:** study
- **Password:** 5tgb3edc1qaz

### Root User Connection (if needed)
- **Host:** localhost
- **Port:** 3308
- **Database:** mysql
- **Username:** root
- **Password:** 9ol.6yhn3edc

## Steps to Connect in DBeaver

1. Open DBeaver
2. Click "New Database Connection" (or Ctrl+Shift+N)
3. Select "MySQL" and click "Next"
4. Enter the connection details above
5. **IMPORTANT:** Click on "Driver properties" tab
6. Add these properties:
   - `allowPublicKeyRetrieval` = `true`
   - `useSSL` = `false` (for local development)
7. Click "Test Connection" to verify
8. Click "Finish" to save the connection

## What Was Changed

Since you're using MySQL latest version (9.4+), we're using the modern authentication method and configuring DBeaver to work with it properly by:

1. Enabling public key retrieval in DBeaver
2. Disabling SSL for local development (optional but recommended for local setups)

## Alternative: Connection URL Method

You can also use a connection URL with the parameters included:
```
jdbc:mysql://localhost:3308/mysql?allowPublicKeyRetrieval=true&useSSL=false
```

## Container Management

- **Start:** `docker-compose -f Mysql/docker-compose.yml up -d`
- **Stop:** `docker-compose -f Mysql/docker-compose.yml down`
- **Restart:** `./Mysql/restart-mysql.sh`
- **View logs:** `docker logs mysql`

## Troubleshooting

If you still encounter connection issues:

1. Ensure the container is running: `docker ps`
2. Check container logs: `docker logs mysql`
3. Verify port 3308 is not blocked by firewall
4. Try connecting with the root user first
