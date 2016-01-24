
FROM ubuntu:wily

ENV JAVA_HOME=/usr/lib/jvm/java-8-oracle \
    JENKINS_HOME=/var/jenkins
VOLUME $JENKINS_HOME

# Install Java.
RUN \
  DEBIAN_FRONTEND=noninteractive && apt-get install -y wget && \
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886 && \
  echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu wily main" | tee -a /etc/apt/sources.list && \
  echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu wily main" | tee -a /etc/apt/sources.list && \
  echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  apt-get update && \
  apt-get install -y --force-yes oracle-java8-installer git && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk8-installer && \
  mkdir -p /usr/bin/jenkins && \
  wget --directory-prefix=/usr/bin/jenkins http://mirrors.jenkins-ci.org/war-stable/latest/jenkins.war && \
  chmod ug+x /usr/bin/jenkins/jenkins.war


# Define working directory.
WORKDIR $JENKINS_HOME
EXPOSE 8080 50000

# Define default command.
CMD java -Dfile.encoding=UTF-8 -Xmx1024M -jar /usr/bin/jenkins/jenkins.war
