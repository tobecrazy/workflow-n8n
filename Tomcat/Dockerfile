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

# Verify Java installation and set correct paths
RUN java -version && \
    update-alternatives --list java && \
    JAVA_HOME_PATH=$(update-alternatives --query java | grep 'Value:' | grep -o '/.*jdk[^/]*') && \
    echo "Detected JAVA_HOME: $JAVA_HOME_PATH"

# Set environment variables with dynamically detected paths
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV JRE_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV CATALINA_HOME=/opt/tomcat
ENV CATALINA_BASE=/opt/tomcat
ENV CATALINA_TMPDIR=/opt/tomcat/temp
ENV PATH=$PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin

# Verify the Java paths exist
RUN ls -la /usr/lib/jvm/ && \
    ls -la $JAVA_HOME && \
    echo "JAVA_HOME=$JAVA_HOME" && \
    echo "JRE_HOME=$JRE_HOME"

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

# Start Tomcat
CMD ["/opt/tomcat/bin/catalina.sh", "run"]
