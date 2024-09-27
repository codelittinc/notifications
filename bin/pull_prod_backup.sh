rm latest.dump
docker-compose up -d
docker stop notifications-api
docker stop notifications-sidekiq
heroku pg:backups:capture --app prod-notifications
heroku pg:backups:download --app prod-notifications
docker exec -it notifications-db psql -U postgres -c 'DROP DATABASE IF EXISTS notifications_development'
docker exec -it notifications-db psql -U postgres -c "CREATE DATABASE notifications_development"
docker exec -it notifications-db psql -U postgres notifications_development -c "CREATE SCHEMA IF NOT EXISTS heroku_ext AUTHORIZATION postgres"
docker exec -it notifications-db pg_restore --no-owner  -U postgres -d notifications_development -1 ./app/latest.dump
sh bin/dev