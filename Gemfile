source 'https://rubygems.org'
ruby '2.1.2'

gem 'rails', '~>4.0.0'
gem 'rails4_upgrade'

# gem 'actionpack-action_caching', '~>1.0.0'
# gem 'actionpack-page_caching', '~>1.0.0'
# gem 'actionpack-xml_parser', '~>1.0.0'
# gem 'actionview-encoded_mail_to', '~>1.0.4'
# gem 'activerecord-session_store', '~>0.0.1'
# gem 'activeresource', '~>4.0.0'
# gem 'protected_attributes', '~>1.0.1'
# gem 'rails-observers', '~>0.1.1'
# gem 'rails-perftest', '~>0.0.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'pg'
gem 'activerecord-postgres-hstore'
gem 'redis'
gem 'redis-rails'

gem 'sass-rails',   '~>4.0.0'
# going to stick with javascript in this app
# gem 'coffee-rails', '~> 3.2.1'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', :platforms => :ruby

gem 'uglifier', '>= 1.3.0'
# and handlebars
gem 'handlebars_assets'
gem 'asset_sync'

gem 'jquery-rails'
gem 'jquery-ui-rails'

# authentication
gem 'devise'
gem 'devise-async'

# for facebook auth
gem 'omniauth'
gem 'oauth2'
gem 'omniauth-facebook', '1.4.0'
gem 'omniauth-google-oauth2'

# facebook
gem 'koala'

# amazon
gem 'amazon-ecs'

# google
gem 'google_contacts_api'

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
gem 'jquery-fileupload-rails'
gem 'carrierwave'
gem 'fog'
gem 'mini_magick'

# lists
gem 'acts_as_list'

# full text search
gem 'pg_search'

# handy things
gem 'possessive'
gem 'active_decorator'
gem 'countries'
gem 'going_postal'
gem 'meta-tags', :require => 'meta_tags'

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
gem 'rack-mini-profiler'
gem 'memcachier'
gem 'dalli'
gem 'dalli-delete-matched'
gem 'sentry-raven', :git => "https://github.com/getsentry/raven-ruby.git"
gem 'newrelic_rpm'
# mailchimp api wrapper
gem 'gibbon', :git => "https://github.com/ryane/gibbon.git"

# background processing
gem 'sidekiq'
gem 'sidekiq-middleware'
gem 'slim', '>= 1.1.0'
gem 'sinatra', '>= 1.3.0', :require => nil

group :development do
  gem 'guard'
  gem 'foreman'
  gem 'zeus'
  gem 'rb-inotify', :require => false
  gem 'rb-fsevent', :require => false # if RUBY_PLATFORM =~ /darwin/i
  gem 'terminal-notifier-guard', :require => false # if RUBY_PLATFORM =~ /darwin/i
  gem 'quiet_assets'

  # use pry in development
  gem 'pry-rails'
  gem 'pry-byebug'
  gem 'interactive_editor'

  # better errors
  gem 'better_errors'
  gem 'binding_of_caller'
end

group :test, :development do
  gem 'dotenv-rails'
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
  gem 'capybara-screenshot'

  # vcr
  gem 'vcr'
  gem 'webmock'
end
