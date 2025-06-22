FROM n8nio/n8n:latest

USER root

# 使用 edge 仓库获取更新包（如 py3-pip）
RUN echo "https://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories && \
    apk update && \
    apk add --no-cache \
      python3 \
      py3-pip \
      py3-setuptools \
      py3-wheel \
      gcc \
      musl-dev \
      libffi-dev \
      openssl-dev \
      curl \
      ca-certificates

# 更新 pip 到最新版（兼容 PEP 668）
RUN pip install --upgrade pip --break-system-packages


# 安装最新版 uv（官方推荐方式）
RUN curl -LsSf https://astral.sh/uv/install.sh | sh && \
    mv /root/.local/bin/uv /usr/local/bin/uv && \
    mv /root/.local/bin/uvx /usr/local/bin/uvx && \
    chmod +x /usr/local/bin/uv /usr/local/bin/uvx

# 建立常用命令别名
RUN ln -sf python3 /usr/bin/python && ln -sf pip3 /usr/bin/pip

RUN pip install --upgrade uv --break-system-packages

# 确保 node 用户也能使用 uv
ENV PATH="/usr/local/bin:$PATH"

USER node
