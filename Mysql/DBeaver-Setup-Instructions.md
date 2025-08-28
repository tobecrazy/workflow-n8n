# DBeaver Setup Instructions for MySQL Latest (9.4.0)

## Quick Solution Summary
The "Public Key Retrieval is not allowed" error occurs because MySQL 9.4+ uses `caching_sha2_password` authentication by default, and DBeaver blocks public key retrieval for security. The solution is to configure DBeaver to allow this.

## Step-by-Step DBeaver Configuration

### 1. Create New Connection
1. Open DBeaver
2. Click **"New Database Connection"** (or press `Ctrl+Shift+N`)
3. Select **"MySQL"** from the list
4. Click **"Next"**

### 2. Basic Connection Settings
Fill in the **"Main"** tab:
- **Server Host:** `localhost`
- **Port:** `3308`
- **Database:** `mysql`
- **Username:** `study`
- **Password:** `5tgb3edc1qaz`

### 3. Configure Driver Properties (CRITICAL STEP)
1. Click on the **"Driver properties"** tab
2. Click **"Add property"** button (or look for existing properties)
3. Add these two properties:

   **Property 1:**
   - Name: `allowPublicKeyRetrieval`
   - Value: `true`

   **Property 2:**
   - Name: `useSSL`
   - Value: `false`

### 4. Test and Save
1. Click **"Test Connection"** - it should now succeed
2. If successful, click **"Finish"** to save the connection

## Alternative: Root User Connection
If you need root access:
- **Username:** `root`
- **Password:** `9ol.6yhn3edc`
- Use the same driver properties as above

## Alternative: Connection URL Method
Instead of using driver properties, you can use a connection URL:

1. In the **"Main"** tab, check **"Edit Driver Settings"**
2. Use this URL template:
   ```
   jdbc:mysql://localhost:3308/mysql?allowPublicKeyRetrieval=true&useSSL=false
   ```

## Why This Works
- `allowPublicKeyRetrieval=true`: Allows DBeaver to retrieve MySQL's public key for secure authentication
- `useSSL=false`: Disables SSL for local development (optional but recommended for local setups)

## Container Status
Your MySQL container is running:
- **Version:** MySQL 9.4.0 (latest)
- **Container:** mysql
- **Port:** 3308 → 3306
- **Status:** Ready for connections

## Troubleshooting

### If connection still fails:
1. Verify container is running: `docker ps | grep mysql`
2. Check MySQL logs: `docker logs mysql`
3. Ensure port 3308 is not blocked
4. Try root user first if study user fails

### Common Issues:
- **"Communications link failure"**: Container not running or wrong port
- **"Access denied"**: Wrong username/password
- **"Public Key Retrieval"**: Missing driver properties (follow step 3 above)

## Container Management Commands
```bash
# Start container
docker-compose -f Mysql/docker-compose.yml up -d

# Stop container
docker-compose -f Mysql/docker-compose.yml down

# Restart container
./Mysql/restart-mysql.sh

# View logs
docker logs mysql

# Check status
docker ps | grep mysql
```

## Success Confirmation
Once connected, you should see:
- Database schemas in the left panel
- Ability to run queries
- No authentication errors

Your MySQL latest version setup is now complete and ready for use with DBeaver!
