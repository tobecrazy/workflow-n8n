# Dockerfile for Tomcat with OpenJDK 21 on Ubuntu 25.10
FROM ubuntu:25.10

# Maintainer information
LABEL maintainer="tobecrazy@qq.com"

# Set environment variables
ENV JAVA_HOME=/usr/lib/jvm/java-21-openjdk-amd64
ENV CATALINA_HOME=/opt/tomcat
ENV CATALINA_BASE=/opt/tomcat
ENV CATALINA_TMPDIR=/opt/tomcat/temp
ENV JRE_HOME=$JAVA_HOME
ENV PATH=$PATH:$JAVA_HOME/bin:$CATALINA_HOME/bin

# Update package list and install required packages
RUN apt-get update && \
    apt-get install -y \
    openjdk-21-jdk \
    wget \
    curl \
    tar \
    && rm -rf /var/lib/apt/lists/*

# Verify Java installation
RUN java -version

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

# Configure Tomcat users (optional - for management interface)
RUN echo '<?xml version="1.0" encoding="UTF-8"?>' > /opt/tomcat/conf/tomcat-users.xml && \
    echo '<tomcat-users xmlns="http://tomcat.apache.org/xml"' >> /opt/tomcat/conf/tomcat-users.xml && \
    echo '              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"' >> /opt/tomcat/conf/tomcat-users.xml && \
    echo '              xsi:schemaLocation="http://tomcat.apache.org/xml tomcat-users.xsd"' >> /opt/tomcat/conf/tomcat-users.xml && \
    echo '              version="1.0">' >> /opt/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="manager-gui"/>' >> /opt/tomcat/conf/tomcat-users.xml && \
    echo '  <role rolename="admin-gui"/>' >> /opt/tomcat/conf/tomcat-users.xml && \
    echo '  <user username="admin" password="admin" roles="manager-gui,admin-gui"/>' >> /opt/tomcat/conf/tomcat-users.xml && \
    echo '</tomcat-users>' >> /opt/tomcat/conf/tomcat-users.xml

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
