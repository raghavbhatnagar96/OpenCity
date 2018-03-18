# openCity

Initialization instruction
Change Password of database in .env, docker-compose.yml, config/database.yml.
Run docker-compose build
Run docker-compose run app rake db:create
docker-compose run app rake db:migrate
Run init.sh and enter the same password.