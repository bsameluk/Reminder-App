# README

A simple Reminder App for payments in Ruby on Rails that allows users to create, view,
edit, and delete reminders. The app should function without user authentication, meaning that
anyone can access and manage their reminders without logging in or registering.

* Ruby version
3.3.0

* System dependencies
  - docker
  - docker-compose

* Configuration
  - docker-compose build
  - docker-compose up
* Database creation
  - docker-compose run app rails db:create
* Database initialization
  - docker-compose run app rails db:migrate
* Services (job queues, cache servers, search engines, etc.)
  - docker-compose run app rails sidekiq

* Deployment instructions

* ...
