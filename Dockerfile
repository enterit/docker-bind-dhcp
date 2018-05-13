FROM sameersbn/ubuntu:16.04.20180124
MAINTAINER sameer@damagehead.com

ENV BIND_USER=bind \
    DHCP_USER=dhcpd \
    DHCP_INTERFACES=" " \
    BIND_VERSION=1:9.10.3 \
    WEBMIN_VERSION=1.8 \
    DATA_DIR=/data

RUN rm -rf /etc/apt/apt.conf.d/docker-gzip-indexes \
 && wget http://www.webmin.com/jcameron-key.asc -qO - | apt-key add - \
 && echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list \
 && apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor bind9=${BIND_VERSION}* bind9-host=${BIND_VERSION}* webmin=${WEBMIN_VERSION}* dnsutils curl isc-dhcp-server \
 && rm -rf /var/lib/apt/lists/*

COPY supervisord.conf /etc/supervisord.conf
COPY entrypoint.sh /sbin/entrypoint.sh
RUN chmod 755 /sbin/entrypoint.sh

EXPOSE 53/udp 53/tcp 10000/tcp
ENTRYPOINT ["/sbin/entrypoint.sh"]
CMD ["/usr/sbin/named"]
