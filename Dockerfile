# syntax = docker/dockerfile:1

FROM ruby:3.3.0-slim

WORKDIR /app

# Устанавливаем переменные окружения
ENV RAILS_ENV=development \
    BUNDLE_PATH=/gems \
    BUNDLE_JOBS=4 \
    BUNDLE_RETRY=3

# Устанавливаем зависимости
RUN apt-get update -qq && apt-get install --no-install-recommends -y \
    build-essential \
    libpq-dev \
    curl \
    git && \
    rm -rf /var/lib/apt/lists/*

# Копируем Gemfile
COPY Gemfile Gemfile.lock ./

# Устанавливаем гемы
RUN bundle install

# Копируем приложение
COPY . .

# Expose для development
EXPOSE 3000

RUN RAILS_ENV=production SECRET_KEY_BASE=e0937c9d29d52b22e0ac9c70d0170d1e370c3172a217efab5a6f2a0e9a0e2908df09c8f5e708d7c2e8d8a1a1c0a0a1 bundle exec rails assets:precompile

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
