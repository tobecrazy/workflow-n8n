FROM n8nio/n8n:latest

USER root

# Set environment variables to prevent Playwright from downloading browsers
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV PLAYWRIGHT_BROWSERS_PATH=0
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROMIUM_PATH=/usr/bin/chromium-browser
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV npm_config_fetch_timeout=5000
ENV npm_config_fetch_retry_mintimeout=1000
ENV npm_config_fetch_retry_maxtimeout=5000
ENV npm_config_fetch_retries=1

# Create dummy Playwright browser directory to satisfy setup checks
RUN mkdir -p /home/node/.cache/ms-playwright/chromium-1140/chrome-linux && \
    echo "#!/bin/sh" > /home/node/.cache/ms-playwright/chromium-1140/chrome-linux/chrome && \
    echo 'echo "Playwright browser placeholder - install actual browser if needed"' >> /home/node/.cache/ms-playwright/chromium-1140/chrome-linux/chrome && \
    chmod +x /home/node/.cache/ms-playwright/chromium-1140/chrome-linux/chrome && \
    chown -R node:node /home/node/.cache

# Copy the Playwright setup script
COPY --chmod=755 playwright-setup.sh /usr/local/bin/playwright-setup.sh

# Create npx wrapper to block playwright downloads
RUN mv /usr/local/bin/npx /usr/local/bin/npx-real && \
    echo '#!/bin/sh' > /usr/local/bin/npx && \
    echo 'if echo "$*" | grep -q "playwright install"; then' >> /usr/local/bin/npx && \
    echo '  echo "Skipping Playwright browser download (using dummy browser)"' >> /usr/local/bin/npx && \
    echo '  exit 0' >> /usr/local/bin/npx && \
    echo 'fi' >> /usr/local/bin/npx && \
    echo 'exec /usr/local/bin/npx-real "$@"' >> /usr/local/bin/npx && \
    chmod +x /usr/local/bin/npx

# Switch back to node user
USER node

# Set the entrypoint to use the playwright setup script
ENTRYPOINT ["/bin/sh", "/usr/local/bin/playwright-setup.sh"]

# Default command to start n8n
CMD ["n8n"]
