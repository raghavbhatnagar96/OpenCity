# openCity
# Docker Installation

If you don't have docker installed already then :

```sh
curl -sSL https://get.docker.com/ | sh

# Replace <your_user> with your username 
sudo usermod -aG docker <your_user>
```
NOTE: Docker installation is done. You have to log out and in log to start using docker. 

After logging back in check if the following command is running successfully or not
```sh
docker run hello-world
```
If it does then your docker installation is done. 

# Starting your rails app. 

Please note that this is very basic documentation and it might not work for you.
```
git clone https://github.com/raghavbhatnagar96/openCity.git
```
Change Password of database in .env, docker-compose.yml, config/database.yml.

```
sudo apt-get install python-pip
sudo pip install docker-compose
docker-compose build
docker-compose run web bundle install
# This will take a while
# create database and run migration
docker-compose run app rake db:create
docker-compose run app rake db:migrate
```

Now your OpenCity applicatio installation is complete 

Please note that you don't have to use 'rails s' command to run the server. Once your db has been intitialized, simply run
```sh
docker-compose up 
```
To visit your development web server. GO to localhost:3000. You will be asked to create a UOD. 

To close the server, simple press Ctrl + c
