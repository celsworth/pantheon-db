#! /bin/sh

docker-compose run app rails db:drop db:create db:migrate db:seed
