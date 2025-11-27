FROM n8nio/n8n:latest

USER root

# Configure pip to use Tsinghua University mirror source
RUN mkdir -p ~/.pip && \
    echo '[global]' > ~/.pip/pip.conf && \
    echo 'index-url = https://pypi.tuna.tsinghua.edu.cn/simple' >> ~/.pip/pip.conf && \
    echo 'trusted-host = pypi.tuna.tsinghua.edu.cn' >> ~/.pip/pip.conf

# Configure npm to use Taobao mirror source
RUN npm config set registry https://registry.npmmirror.com

# Install system dependencies for Playwright and Chromium
# Split into multiple steps for better error handling and caching
RUN apk update && apk upgrade

# Install packages in smaller groups to avoid timeout issues
RUN apk add --no-cache openssl openssl-dev python3 py3-pip py3-setuptools py3-wheel gcc musl-dev libffi-dev curl ca-certificates

RUN apk add --no-cache chromium chromium-chromedriver nss freetype freetype-dev harfbuzz ttf-freefont gcompat

RUN apk add --no-cache bash dbus fontconfig mesa-gl udev xvfb && rm -rf /var/cache/apk/*

# Update pip to latest version (compatible with PEP 668) using China mirror source
RUN pip install --upgrade pip --break-system-packages -i https://pypi.tuna.tsinghua.edu.cn/simple

# Install latest version of uv (using pre-compiled version from China mirror source)
RUN pip install uv --break-system-packages -i https://pypi.tuna.tsinghua.edu.cn/simple

# Create common command aliases
RUN ln -sf python3 /usr/bin/python && ln -sf pip3 /usr/bin/pip

RUN pip install --upgrade uv --break-system-packages -i https://pypi.tuna.tsinghua.edu.cn/simple

# Ensure node user can also use uv and China mirror sources
ENV PATH="/usr/local/bin:$PATH"

# Configure pip and npm China mirror sources for node user
RUN mkdir -p /home/node/.pip && \
    echo '[global]' > /home/node/.pip/pip.conf && \
    echo 'index-url = https://pypi.tuna.tsinghua.edu.cn/simple' >> /home/node/.pip/pip.conf && \
    echo 'trusted-host = pypi.tuna.tsinghua.edu.cn' >> /home/node/.pip/pip.conf && \
    chown -R node:node /home/node/.pip

# Switch to node user to configure npm
USER node
RUN npm config set registry https://registry.npmmirror.com

# Switch back to root user to continue configuration
USER root

# Set Playwright environment variables to use system Chromium
ENV PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD=1
ENV PLAYWRIGHT_CHROMIUM_EXECUTABLE_PATH=/usr/bin/chromium-browser
ENV PLAYWRIGHT_BROWSERS_PATH=/usr/bin
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROMIUM_PATH=/usr/bin/chromium-browser
ENV PLAYWRIGHT_SKIP_BROWSER_GC=1
ENV PLAYWRIGHT_DISABLE_BROWSER_DOWNLOAD=1
ENV PUPPETEER_SKIP_CHROMIUM_DOWNLOAD=1
ENV PUPPETEER_EXECUTABLE_PATH=/usr/bin/chromium-browser

# Create a script to handle Playwright browser detection
RUN mkdir -p /usr/local/bin && \
    echo '#!/bin/sh' > /usr/local/bin/chrome && \
    echo 'exec /usr/bin/chromium-browser --no-sandbox --disable-dev-shm-usage --disable-gpu --remote-debugging-port=9222 "$@"' >> /usr/local/bin/chrome && \
    chmod +x /usr/local/bin/chrome

# Copy and setup the Playwright configuration script
COPY playwright-setup.sh /usr/local/bin/playwright-setup.sh
RUN chmod +x /usr/local/bin/playwright-setup.sh

# Fix permissions and create necessary directories
RUN mkdir -p /tmp/.X11-unix && \
    chmod 1777 /tmp/.X11-unix && \
    mkdir -p /home/node/.cache && \
    mkdir -p /home/node/.cache/ms-playwright && \
    chown -R node:node /home/node/.cache

# Create browser symlinks for Playwright compatibility
RUN ln -sf /usr/bin/chromium-browser /usr/local/bin/google-chrome && \
    ln -sf /usr/bin/chromium-browser /usr/local/bin/google-chrome-stable && \
    ln -sf /usr/bin/chromium-browser /usr/local/bin/chromium

USER node

# Set additional environment variables for the node user
ENV DISPLAY=:99
ENV CHROME_DEVEL_SANDBOX=/usr/local/sbin/chrome-devel-sandbox

# Use the setup script as entrypoint but ensure n8n starts properly
ENTRYPOINT ["/usr/local/bin/playwright-setup.sh"]
CMD ["n8n", "start"]