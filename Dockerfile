FROM ubuntu:14.04

MAINTAINER hxj "8936270@qq.com"
USER root

RUN apt-get update
RUN apt-get install -y iptables
RUN apt-get install -y pptpd
RUN apt-get install -y ifstat

ADD pptpd.conf /etc/
ADD pptpd-options /etc/ppp/
ADD chap-secrets /etc/ppp/
ADD startup.sh /root/

EXPOSE 1723
ENTRYPOINT ["sh","/root/startup.sh"]







