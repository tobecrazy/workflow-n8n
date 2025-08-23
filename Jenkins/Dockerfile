FROM jenkins/jenkins:latest
MAINTAINER Young <dbyl@dbyl.cn>
USER root
RUN apt-get update && apt-get install -y vim python3 python3-pip wget unzip
RUN ln -s /usr/bin/python3 /usr/bin/python
RUN wget https://services.gradle.org/distributions/gradle-9.0.0-bin.zip -P /tmp
RUN unzip -d /opt/gradle /tmp/gradle-9.0.0-bin.zip
ENV PATH=$PATH:/opt/gradle/gradle-9.0.0/bin
RUN pip3 install qrcode[pil] --break-system-packages
USER jenkins
