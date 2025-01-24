# README

A simple Reminder App for payments in Ruby on Rails that allows users to create, view,
edit, and delete reminders. The app should function without user authentication, meaning that
anyone can access and manage their reminders without logging in or registering.

* Ruby version
3.3.0

Development setup (docker):
  docker-compose build
  docker-compose run app ./bin/rails db:create db:migrate
  docker-compose up

Development setup (manual):
  --rails
    bundle install
    ./bin/rails db:create db:migrate
    ./bin/rails server
  --sidekiq
    ./bin/sidekiq
  --redis
    redis-server


