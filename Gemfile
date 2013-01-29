source 'https://rubygems.org'
ruby '1.9.3'

gem 'rails', '3.2.11'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'activerecord-postgres-hstore'
gem 'redis'
gem 'redis-rails'

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails',   '~> 3.2.3'
  # going to stick with javascript in this app
  # gem 'coffee-rails', '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  # gem 'therubyracer', :platforms => :ruby

  gem 'uglifier', '>= 1.0.3'
  # and handlebars
  gem 'handlebars_assets'
end

gem 'jquery-rails'
gem 'jquery-ui-rails'

# authentication
gem 'devise'
# for facebook auth
gem 'omniauth'
gem 'oauth2'
gem 'omniauth-facebook', '1.4.0'

# facebook
gem 'koala'

# amazon
gem 'amazon-ecs'

# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# let's use backbone
gem 'backbone-on-rails'

# To use Jbuilder templates for JSON
gem 'jbuilder'

# url slugs
gem 'friendly_id'

# html encoding/decoding
gem 'htmlentities'

# file attachments
gem 'carrierwave'
gem 'fog'

# lists
gem 'acts_as_list'

# handy things
gem 'possessive'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

gem 'memoist'

# infrastructure
gem 'thin'
gem 'heroku'

group :development do
  gem 'guard'
  gem 'guard-spork'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false # if RUBY_PLATFORM =~ /darwin/i
  gem 'terminal-notifier-guard', :require => false # if RUBY_PLATFORM =~ /darwin/i
  gem 'therubyracer'
  gem 'mailcatcher'
  gem 'quiet_assets'

  # use pry in development
  gem 'pry-rails'
  gem 'pry-debugger'
  gem 'interactive_editor'
end

group :test, :development do
  gem 'rspec-rails'
  gem 'capybara'
  gem 'factory_girl_rails'
end

group :test do
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'guard-rspec'
  gem 'timecop'
  gem 'rack-contrib'
  gem 'simplecov', require: false
end
