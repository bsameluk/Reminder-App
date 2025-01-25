# Reminder App

A simple **Reminder App** built with **Ruby on Rails** that allows users to create, view, edit, and delete reminders without requiring authentication. Anyone can access and manage reminders without logging in or registering.

## Ruby version
- 3.3.0

## Local Setup (With Docker)
1. Build the containers:
   ```bash
   docker-compose build
   ```
2. Create and migrate the database:
   ```bash
   docker-compose run app ./bin/rails db:create db:migrate
   ```
3. Start the application:
   ```bash
   docker-compose up
   ```
4. Stop the application:
   ```bash
   docker-compose down
   ```

## Local Setup (Manual)
1. Install dependencies:
   ```bash
   bundle install
   ```
2. Create and migrate the database:
   ```bash
   ./bin/rails db:create db:migrate
   ```
3. Start the Rails server:
   ```bash
   ./bin/rails server
   ```
4. Start Sidekiq for background jobs:
   ```bash
   ./bin/sidekiq
   ```
5. Start Redis:
   ```bash
   redis-server
   ```

## Production Setup (With Docker)
1. Build the containers:
   ```bash
   docker-compose -f docker-compose.prod.yml build
   ```
2. Create and migrate the database:
   ```bash
   docker-compose -f docker-compose.prod.yml run app ./bin/rails db:create db:migrate
   ```
3. Start the application:
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```
4. Stop the application:
   ```bash
   docker-compose -f docker-compose.prod.yml down
   ```

## Tests
Run tests with:
```bash
bundle exec rspec
```

## Clean Up
1. Remove all containers, volumes, and orphaned resources:
   ```bash
   docker-compose down --volumes --remove-orphans
   docker system prune -a --volumes
   ```
2. Force rebuild and recreate the production environment:
   ```bash
   docker-compose -f docker-compose.prod.yml build --no-cache
   docker-compose -f docker-compose.prod.yml up --force-recreate
   ```
