#! /bin/sh

docker-compose run app rails db:dump || true
docker-compose run app rails db:drop db:create db:migrate db:restore
