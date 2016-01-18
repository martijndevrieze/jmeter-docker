FROM ubuntu:14.04

MAINTAINER Martijn de Vrieze <martijndevrieze@qa-rocks.com>

ENV JMVERS 2.13
ENV JMPLUGINVERS 1.3.1
ENV JMETERURL http://apache.cs.uu.nl//jmeter/binaries/apache-jmeter-${JMVERS}.tgz
ENV PLUGINURL http://jmeter-plugins.org/downloads/file/
ENV SERVERPORT 60000
ENV CLIENTPORT 7000

EXPOSE ${SERVERPORT} ${CLIENTPORT}

RUN apt-get update
RUN apt-get upgrade -y
RUN sudo apt-get update && \
 sudo apt-get install -y software-properties-common && \ 
 add-apt-repository ppa:webupd8team/java && \
 sudo apt-get update && \
 sudo apt-get install -y wget unzip

RUN add-apt-repository ppa:webupd8team/java 
RUN apt-get update && apt-get -y upgrade
RUN echo debconf shared/accepted-oracle-license-v1-1 select true | debconf-set-selections
RUN echo debconf shared/accepted-oracle-license-v1-1 seen true | debconf-set-selections
RUN apt-get -y install oracle-java8-installer


RUN sudo apt-get install openssh-server ; sed -i '/#Port 22/ a \Port 2222' /etc/ssh/sshd_config
RUN wget ${JMETERURL} && \
 tar xzf apache-jmeter-${JMVERS}.tgz

RUN wget ${PLUGINURL}JMeterPlugins-Standard-${JMPLUGINVERS}.zip && \ 
 unzip -o JMeterPlugins-Standard-${JMPLUGINVERS}.zip -d /apache-jmeter-${JMVERS}/

RUN wget ${PLUGINURL}JMeterPlugins-ExtrasLibs-${JMPLUGINVERS}.zip && \
 unzip -o JMeterPlugins-ExtrasLibs-${JMPLUGINVERS}.zip -d /apache-jmeter-${JMVERS}/

RUN wget ${PLUGINURL}JMeterPlugins-WebDriver-${JMPLUGINVERS}.zip && \
 unzip -o JMeterPlugins-WebDriver-${JMPLUGINVERS}.zip -d /apache-jmeter-${JMVERS}/

CMD /apache-jmeter-${JMVERS}/bin/jmeter-server \
 -Dclient.rmi.localport=${SERVERPORT} \
 -Dserver.rmi.localport=${SERVERPORT}
