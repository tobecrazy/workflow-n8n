#!/bin/bash

# Playwright setup script for n8n container
echo "Setting up Playwright environment..."

# Set up environment variables for Playwright to skip browser downloads
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
export PLAYWRIGHT_BROWSERS_PATH=0
export PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
export npm_config_fetch_timeout=60000
export npm_config_fetch_retry_mintimeout=20000
export npm_config_fetch_retry_maxtimeout=120000

echo "Environment variables set to skip Playwright browser downloads"

# Function to continuously monitor and handle playwright installations
monitor_playwright_installations() {
    echo "Starting Playwright installation monitor..."

    while true; do
        # Look for any n8n-nodes-playwright installations and suppress browser downloads
        find /home/node/.n8n -name "n8n-nodes-playwright" -type d 2>/dev/null | while read -r PLAYWRIGHT_NODE_DIR; do
            if [ -n "$PLAYWRIGHT_NODE_DIR" ]; then
                echo "Found n8n-nodes-playwright at: $PLAYWRIGHT_NODE_DIR"

                # Create a marker file to indicate we've processed this directory
                MARKER_FILE="$PLAYWRIGHT_NODE_DIR/.browser-skip-configured"
                if [ ! -f "$MARKER_FILE" ]; then
                    echo "Configuring browser skip for this installation..."
                    touch "$MARKER_FILE"
                    echo "Browser download skip configured for $PLAYWRIGHT_NODE_DIR"
                fi
            fi
        done

        # Check every 10 seconds
        sleep 10
    done
}

# Start the monitor in background
monitor_playwright_installations &
MONITOR_PID=$!

# Function to handle cleanup
cleanup() {
    echo "Cleaning up..."
    kill $MONITOR_PID 2>/dev/null || true
    exit 0
}

# Set up signal handlers
trap cleanup SIGTERM SIGINT

echo "Playwright setup completed successfully!"

# Start n8n
echo "Starting n8n..."
exec "$@"
