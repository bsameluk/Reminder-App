source "https://rubygems.org"

ruby "3.3.0"

gem "rails", "~> 7.1.3", ">= 7.1.3.3"     # Bundle edge Rails instead: gem "rails", github: "rails/rails", branch: "main"
gem "sprockets-rails"                     # The original asset pipeline for Rails [https://github.com/rails/sprockets-rails]
gem "pg", "~> 1.1"                        # Use postgresql as the database for Active Record
gem "puma", ">= 5.0"                      # Use the Puma web server [https://github.com/puma/puma]
gem "importmap-rails"                     # Use JavaScript with ESM import maps [https://github.com/rails/importmap-rails]
gem "turbo-rails"                         # Hotwire's SPA-like page accelerator [https://turbo.hotwired.dev]
gem "stimulus-rails"                      # Hotwire's modest JavaScript framework [https://stimulus.hotwired.dev]
gem "jbuilder"                            # Build JSON APIs with ease [https://github.com/rails/jbuilder]
gem "tzinfo-data", platforms: %i[ windows jruby ] # Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem "bootsnap", require: false            # Reduces boot times through caching; required in config/boot.rb

gem 'redis', '~> 4.8.1'
gem 'sidekiq'

group :development, :test do
  gem "debug", platforms: %i[ mri windows ]
  gem 'rspec-rails'
  gem 'shoulda-matchers'
  gem 'pry-byebug'
  gem 'pry-rails'
  gem 'rspec-sidekiq'
  gem 'rails-controller-testing'
end

group :development do
  gem "web-console"
  gem 'annotate'
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
end
