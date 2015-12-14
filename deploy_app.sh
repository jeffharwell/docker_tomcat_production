#!/bin/bash

CONTAINER_NAME="tomcat"
WAR_FILE="apiservice-0.1.war"
IMAGE_VERSION="1"

echo -n "Deploy against production banner or ban8test (prod|ban8test): " 
read banner_sid

if [ $banner_sid = 'prod' ]; then
    ENV_FILE="launch_environment"
elif [ $banner_sid = 'ban8test' ]; then
    ENV_FILE="launch_environment_test"
else
    echo "${banner_sid} is not a valid choice"
    exit 1
fi

if [ 'root' != `whoami` ]; then
    echo "You must run this as root"
    exit 1
fi

echo "Initial Cleaning"
docker stop $CONTAINER_NAME && sudo docker rm -v $CONTAINER_NAME

## create the container
echo "Create the container"
if [ ! -f ./${ENV_FILE} ]; then
  echo "Copy ${ENV_FILE}.example to ${ENV_FILE} and set the proper values and try again"
  exit 1;
fi

echo "Deploying contain \"${CONTAINER_NAME}\" version ${IMAGE_VERSION} using environment file \"${ENV_FILE}\""

docker create --name tomcat --link rabbit:rabbit -p 192.168.27.23:8443:8443 --env-file=./${ENV_FILE} harwell/tomcat_production:$IMAGE_VERSION

## until cp command work must run the container instead to copy in the WAR file
echo "Starting the container"
docker start tomcat

## Push in the real certificate for this docker host
echo "Copying the keystore.jks for this docker host"
cat ~/thisdockerhost_keystore.jks | docker exec -i $CONTAINER_NAME sh -c 'cat > /usr/local/tomcat/conf/keystore.jks'

## Push up the war file
## this should work in the next version of docker
#docker cp ./$WAR_FILE $CONTAINER_NAME:/usr/local/tomcat/webapps
echo "Copying the WAR file $WAR_FILE to apiservice.war"
cat ./$WAR_FILE | docker exec -i $CONTAINER_NAME sh -c 'cat > /usr/local/tomcat/webapps/apiservice.war'

echo -e "\n\n****Type Ctrl-c to detach****\n\n"
echo -e "\n** If the application must gather entropy to create the random key for the JWT it can take as much as 2 or 3 minutes to fully load.**\n\n"
sleep 3
docker attach --sig-proxy=false $CONTAINER_NAME
