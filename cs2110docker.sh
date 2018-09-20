#!/bin/bash

docker -v >/dev/null

imageName="dbecker1/cs2110docker"

dockerExists=$?

if  [ $dockerExists != 0 ]; then
	echo ERROR: Please install Docker before running this script. Refer to the CS 2110 Docker Guide.
	exit
fi

echo Found Docker Installation. Checking for existing containers.

existingContainers=$(docker ps -a | grep $imageName | awk '{print $1}')

if [ $existingContainers ]; then
	echo Found CS 2110 containers. Stopping and removing them.
	docker stop $existingContainers >/dev/null
	docker rm $existingContainers >/dev/null
else 
	echo No existing CS 2110 containers.
fi

echo Pulling down most recent image of $imageName
docker pull $imageName

successfulPull=$?

if [ $successfulPull != 0 ]; then
	echo ERROR: Unable to pull down the most recent image of $imageName
	exit
fi 

echo Starting up new CS 2110 Docker Container:

docker run -d -p 6901:6901 -v "$(pwd)":/cs2110/host/ dbecker1/cs2110docker 

successfulRun=$?

if [ $successfulRun == 0 ]; then
	echo Successfully launched CS 2110 Docker container. Please go to http://localhost:6901/vnc.html to access it.
else 
	echo ERROR: Unable to launch CS 2110 Docker container.
fi 