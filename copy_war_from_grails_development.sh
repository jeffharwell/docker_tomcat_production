#!/bin/bash

CONTAINER_NAME='grails_dev'
USER=`whoami`

sudo docker cp $CONTAINER_NAME:/home/grails_user/GrailsRestfulAPIService/apiservice/build/libs/apiservice-0.1.war .
sudo chown $USER:$USER ./apiservice-0.1.war
