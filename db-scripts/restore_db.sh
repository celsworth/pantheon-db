#! /bin/sh

docker-compose run app rails db:drop db:create
docker-compose run -e PGPASSWORD=pantheon app psql -h postgres -U pantheon -f pg.dump
