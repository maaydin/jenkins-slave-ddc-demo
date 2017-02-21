FROM centos:7
MAINTAINER maaydin
ENV container docker

ARG ORACLE_JDK_VERSION
ARG ORACLE_JDK_BUILD_NUMBER

# Clean up systemd
RUN (cd /lib/systemd/system/sysinit.target.wants/; for i in *; do [ $i == systemd-tmpfiles-setup.service ] || rm -f $i; done); \
rm -f /lib/systemd/system/multi-user.target.wants/*; \
rm -f /etc/systemd/system/*.wants/*; \
rm -f /lib/systemd/system/local-fs.target.wants/*; \
rm -f /lib/systemd/system/sockets.target.wants/*udev*; \
rm -f /lib/systemd/system/sockets.target.wants/*initctl*; \
rm -f /lib/systemd/system/basic.target.wants/*; \
rm -f /lib/systemd/system/anaconda.target.wants/*;

# Install Oracle JDK
RUN curl -vfL -H "Cookie: oraclelicense=accept-securebackup-cookie" -o /tmp/jdk-${ORACLE_JDK_VERSION}-linux-x64.rpm http://download.oracle.com/otn-pub/java/jdk/${ORACLE_JDK_VERSION}-${ORACLE_JDK_BUILD_NUMBER}/e9e7ea248e2c4826b92b3f075a80e441/jdk-${ORACLE_JDK_VERSION}-linux-x64.rpm && \
rpm -ivh /tmp/jdk-${ORACLE_JDK_VERSION}-linux-x64.rpm && \
rm -f /tmp/*;

RUN yum clean all && \
yum -y install epel-release && \
yum -y install git unzip python-pip;

# Install Docker
RUN curl -sSL get.docker.com https://get.docker.com/ | sh;

RUN pip install docker-compose;

ADD start.sh /opt/jenkins/start.sh
RUN chmod +x /opt/jenkins/start.sh

WORKDIR /opt/jenkins
ENTRYPOINT ["/opt/jenkins/start.sh"]