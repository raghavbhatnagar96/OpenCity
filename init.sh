#!/bin/bash
if docker-compose up -d; then
	echo "Docker is UP"
else
	echo "Error in setting up docker"
	exit 1
fi
read -p "Enter Name of World: "  world
read -p "Enter Password for database: "  dbPassword
if docker exec -i opencity_mysql_1 mysql -u root -p$dbPassword  <<< "USE openCity;INSERT INTO worlds (Title, created_at, updated_at) VALUES ('$world', NOW(), NOW());"; then
	echo "World Created"
else
	echo "Error in world creation"
	exit 1
fi
docker container stop opencity_mysql_1
docker container stop phpmyadmin_container
docker container stop opencity_app_1
echo "Initialization successful"