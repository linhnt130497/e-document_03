source "https://rubygems.org"

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?("/")
  "https://github.com/#{repo_name}.git"
end

gem "kristin"
gem "rails", "~> 5.1.4"
gem "puma", "~> 3.7"
gem "sass-rails", "~> 5.0"
gem "uglifier", ">= 1.3.0"
gem "coffee-rails", "~> 4.2"
gem "turbolinks", "~> 5"
gem "jbuilder", "~> 2.5"
gem "bootstrap-sass"
gem "jquery-rails"
gem "bcrypt", "~> 3.1", ">= 3.1.11"
gem "config"
gem "carrierwave", "1.1.0"
gem "mini_magick", "4.7.0"
gem "fog", "1.40.0"
gem "jquery-rails"
gem "bootstrap-will_paginate"
gem "faker"
gem "paranoia", "~> 2.2"
gem "i18n-js"
gem "jquery-turbolinks"
gem "figaro"
gem "whenever", require: false
gem "cancancan", "~> 1.10"
gem "devise"
gem "social-share-button"
gem "omniauth-facebook"
gem "omniauth-google-oauth2"
gem "kaminari"
gem "bootstrap-kaminari-views"
gem "friendly_id"

group :development, :test do
  gem "byebug", platforms: [:mri, :mingw, :x64_mingw]
  gem "capybara", "~> 2.13"
  gem "selenium-webdriver"
  gem "mysql2", "~> 0.4.10"
end

group :production do
  gem "pg"
end

group :development do
  gem "web-console", ">= 3.3.0"
  gem "listen", ">= 3.0.5", "< 3.2"
  gem "spring"
  gem "spring-watcher-listen", "~> 2.0.0"
end

gem "tzinfo-data", platforms: [:mingw, :mswin, :x64_mingw, :jruby]
