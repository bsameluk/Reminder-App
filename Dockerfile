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

# Копируем только файлы для установки гемов
COPY Gemfile Gemfile.lock ./

# Устанавливаем гемы (принудительное очищение кеша)
RUN bundle install --clean

# Копируем всё приложение
COPY . .

# Компилируем ассеты для production
RUN RAILS_ENV=production SECRET_KEY_BASE=dummy_key bundle exec rails assets:precompile

# Expose для development
EXPOSE 3000

# Основная команда
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0", "-p", "3000"]
