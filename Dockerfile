FROM tomcat:jre8
MAINTAINER Jeff Harwell <jharwell@fuller.edu>

## Enables the management interface
ADD ./files/tomcat-users.xml /usr/local/tomcat/conf/

## Our self-signed keystore
ADD ./files/keystore.jks.selfsigned /usr/local/tomcat/conf/keystore.jks

## Our custom server.xml to enable SSL
ADD ./files/server.xml /usr/local/tomcat/conf/
