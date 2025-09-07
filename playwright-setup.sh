#!/bin/bash

# Playwright setup script for n8n container
echo "Setting up Playwright environment..."

# Ensure Chromium is available and working
if [ ! -f "/usr/bin/chromium-browser" ]; then
    echo "Error: Chromium browser not found at /usr/bin/chromium-browser"
    exit 1
fi

# Test Chromium launch
echo "Testing Chromium browser..."
/usr/bin/chromium-browser --version

# Set up environment variables for Playwright
export PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
export PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser
export PLAYWRIGHT_BROWSERS_PATH=/usr/bin
export CHROME_BIN=/usr/bin/chromium-browser
export CHROMIUM_PATH=/usr/bin/chromium-browser

# Create symlinks for common browser names that Playwright might look for
if [ ! -f "/usr/local/bin/google-chrome" ]; then
    ln -sf /usr/bin/chromium-browser /usr/local/bin/google-chrome
fi

if [ ! -f "/usr/local/bin/google-chrome-stable" ]; then
    ln -sf /usr/bin/chromium-browser /usr/local/bin/google-chrome-stable
fi

# Fix any potential permission issues (ignore errors if we can't change permissions)
chmod +x /usr/bin/chromium-browser 2>/dev/null || true
chmod +x /usr/local/bin/chrome 2>/dev/null || true

# Create a fake npx command that skips playwright install
mkdir -p /tmp/fake-bin
cat > /tmp/fake-bin/npx << 'EOF'
#!/bin/bash
if [[ "$*" == *"playwright install"* ]]; then
    echo "Skipping Playwright browser installation - using system Chromium"
    exit 0
fi
exec /usr/bin/npx "$@"
EOF
chmod +x /tmp/fake-bin/npx
export PATH="/tmp/fake-bin:$PATH"

# Function to continuously monitor and create browser symlinks
monitor_and_create_browser_links() {
    echo "Starting browser link monitor..."
    
    while true; do
        # Look for any n8n-nodes-playwright installations
        find /home/node/.n8n -name "n8n-nodes-playwright" -type d 2>/dev/null | while read -r PLAYWRIGHT_NODE_DIR; do
            if [ -n "$PLAYWRIGHT_NODE_DIR" ]; then
                echo "Found n8n-nodes-playwright at: $PLAYWRIGHT_NODE_DIR"
                
                # Create the browsers directory structure
                BROWSERS_DIR="$PLAYWRIGHT_NODE_DIR/dist/nodes/browsers"
                mkdir -p "$BROWSERS_DIR"
                
                # Create the exact directory structure that Playwright expects
                CHROMIUM_CHROME_DIR="$BROWSERS_DIR/chromium/chrome-linux"
                mkdir -p "$CHROMIUM_CHROME_DIR"
                
                # Create symlink to system chromium in the expected location
                if [ ! -f "$CHROMIUM_CHROME_DIR/chrome" ]; then
                    ln -sf /usr/bin/chromium-browser "$CHROMIUM_CHROME_DIR/chrome"
                    echo "Created chrome symlink in $CHROMIUM_CHROME_DIR"
                fi
                
                # Create multiple browser directory structures that Playwright might expect for different versions
                for version in "1129" "1130" "1131" "1132" "1133" "1134" "1135"; do
                    CHROMIUM_DIR="$BROWSERS_DIR/chromium-$version/chrome-linux"
                    mkdir -p "$CHROMIUM_DIR"
                    
                    # Create symlink to system chromium if it doesn't exist
                    if [ ! -f "$CHROMIUM_DIR/chrome" ]; then
                        ln -sf /usr/bin/chromium-browser "$CHROMIUM_DIR/chrome"
                        echo "Created chrome symlink in $CHROMIUM_DIR"
                    fi
                done
                
                # Also create direct browser links
                if [ ! -f "$BROWSERS_DIR/chromium" ]; then
                    ln -sf /usr/bin/chromium-browser "$BROWSERS_DIR/chromium"
                    echo "Created direct chromium symlink in $BROWSERS_DIR"
                fi
                
                # Create chrome executable
                if [ ! -f "$BROWSERS_DIR/chrome" ]; then
                    ln -sf /usr/bin/chromium-browser "$BROWSERS_DIR/chrome"
                    echo "Created direct chrome symlink in $BROWSERS_DIR"
                fi
                
                # Create a chrome wrapper script
                CHROME_WRAPPER="$BROWSERS_DIR/chrome-wrapper"
                if [ ! -f "$CHROME_WRAPPER" ]; then
                    cat > "$CHROME_WRAPPER" << 'WRAPPER_EOF'
#!/bin/bash
exec /usr/bin/chromium-browser --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugging-port=9222 "$@"
WRAPPER_EOF
                    chmod +x "$CHROME_WRAPPER"
                    echo "Created chrome wrapper script in $BROWSERS_DIR"
                fi
            fi
        done
        
        # Check every 10 seconds
        sleep 10
    done
}

# Start the monitor in background
monitor_and_create_browser_links &
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
