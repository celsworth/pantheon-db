#! /bin/sh

docker-compose run app bundle exec rails db:drop db:create db:migrate db:seed
