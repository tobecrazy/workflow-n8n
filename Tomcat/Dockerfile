# Dockerfile for Tomcat with OpenJDK 21 on Ubuntu 25.10
FROM ubuntu:25.10

# Maintainer information
LABEL maintainer="tobecrazy@qq.com"

# Update package list and install required packages
RUN apt-get update && \
    apt-get install -y \
    openjdk-21-jdk \
    wget \
    curl \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Find the actual Java installation path and create a script to set environment variables
RUN JAVA_HOME_PATH=$(find /usr/lib/jvm -name "java-21-openjdk-*" -type d | head -1) && \
    echo "Found Java at: $JAVA_HOME_PATH" && \
    ls -la $JAVA_HOME_PATH && \
    echo "#!/bin/bash" > /usr/local/bin/set-java-env.sh && \
    echo "export JAVA_HOME=$JAVA_HOME_PATH" >> /usr/local/bin/set-java-env.sh && \
    echo "export JRE_HOME=$JAVA_HOME_PATH" >> /usr/local/bin/set-java-env.sh && \
    echo "export PATH=\$PATH:\$JAVA_HOME/bin" >> /usr/local/bin/set-java-env.sh && \
    chmod +x /usr/local/bin/set-java-env.sh && \
    cat /usr/local/bin/set-java-env.sh

# Set environment variables dynamically
RUN JAVA_HOME_PATH=$(find /usr/lib/jvm -name "java-21-openjdk-*" -type d | head -1) && \
    echo "JAVA_HOME=$JAVA_HOME_PATH" && \
    echo "JRE_HOME=$JAVA_HOME_PATH"

ENV CATALINA_HOME=/opt/tomcat
ENV CATALINA_BASE=/opt/tomcat
ENV CATALINA_TMPDIR=/opt/tomcat/temp

# Verify Java installation
RUN java -version && ls -la /usr/lib/jvm/

# Create tomcat user and group
RUN groupadd -r tomcat && \
    useradd -r -g tomcat -d /opt/tomcat -s /bin/false tomcat

# Download and install Tomcat (version 9.0.108)
RUN cd /tmp && \
    wget https://downloads.apache.org/tomcat/tomcat-9/v9.0.108/bin/apache-tomcat-9.0.108.tar.gz && \
    tar -xzf apache-tomcat-9.0.108.tar.gz && \
    mv apache-tomcat-9.0.108 /opt/tomcat && \
    rm apache-tomcat-9.0.108.tar.gz

# Set proper permissions
RUN chown -R tomcat:tomcat /opt/tomcat && \
    chmod +x /opt/tomcat/bin/*.sh

# Create necessary directories
RUN mkdir -p /opt/tomcat/temp && \
    chown -R tomcat:tomcat /opt/tomcat/temp

# Configuration files will be mounted from host via docker-compose volumes

# Expose Tomcat port
EXPOSE 8080

# Switch to tomcat user
USER tomcat

# Set working directory
WORKDIR /opt/tomcat

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
    CMD curl -f http://localhost:8080/ || exit 1

# Start Tomcat with proper environment variables
CMD ["/bin/bash", "-c", "source /usr/local/bin/set-java-env.sh && /opt/tomcat/bin/catalina.sh run"]
