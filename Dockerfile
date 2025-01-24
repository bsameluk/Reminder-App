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

CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
