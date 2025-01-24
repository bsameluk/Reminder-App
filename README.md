# README

A simple Reminder App for payments in Ruby on Rails that allows users to create, view,
edit, and delete reminders. The app should function without user authentication, meaning that
anyone can access and manage their reminders without logging in or registering.

* Ruby version
3.3.0

--------------- LOCAL SETUP (WITH DOCKER) -------------------

Development setup (docker):
  docker-compose build
  docker-compose run app ./bin/rails db:create db:migrate
  docker-compose up

  --stop
  docker-compose down

--------------- LOCAL SETUP -------------------

Development setup (manual):
  --rails
    bundle install
    ./bin/rails db:create db:migrate
    ./bin/rails server
  --sidekiq
    ./bin/sidekiq
  --redis
    redis-server

--------------- PRODUCTION SETUP -------------------

Production setup (docker):
  docker-compose -f docker-compose.prod.yml build
  docker-compose -f docker-compose.prod.yml run app ./bin/rails db:create db:migrate
  docker-compose -f docker-compose.prod.yml up -d

  --stop
  docker-compose -f docker-compose.prod.yml down


--------------- TESTS -------------------
bundle exec rspec
