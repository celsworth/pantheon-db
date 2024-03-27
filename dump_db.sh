#! /bin/sh
#
docker-compose run -e PGPASSWORD=pantheon app pg_dump -h postgres -U pantheon pantheon >pg.dump
