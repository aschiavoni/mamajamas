# mamajamas
=========

## Welcome to Mama Jamas!

### Development Environment

#### Thin

We are using the thin web server in development and production.

#### Postgresql

1. Install the postgresql database on your development machine.
2. Create the role for the development and test environments.

  > $ psql -d postgres
  > postgres=# create role mamajamas login createdb;
  > postgres=# \q

3. Create the databases.

  > rake db:create
  > rake RAILS_ENV=test db:create

#### Bundler

On linux, you may have to install some dependencies before you can
successfully run 'bundle install'.

##### nokogiri requirements

  > sudo apt-get install libxslt-dev libxml2-dev

##### Mailers

We are currently using the Mandrill heroku add-on to send email. To use
the same add-on in development mode, you need to configure two
environment variables:

  > export MANDRILL_APIKEY=value
  > export MANDRILL_USERNAME=value

To retrieve the above values, you can use the following two heroku
commands:

  > heroku config:get MANDRILL_APIKEY
  > heroku config:get MANDRILL_USERNAME

Note that these environment variables must be available in the
environment of the process you are running the rails server in.

Then uncomment the following lines in
config/environments/development.rb:

```ruby
  config.action_mailer.delivery_method = :smtp
  config.action_mailer.perform_deliveries = true
  config.action_mailer.smtp_settings = {
    :address              => "smtp.mandrillapp.com",
    :port                 => 587,
    :domain               => "heroku.com",
    :user_name            => ENV['MANDRILL_USERNAME'],
    :password             => ENV['MANDRILL_APIKEY'],
    :authentication       => "plain"
  }
```

Be aware that that making the above changes will result in real email
being sent so make sure you are working with appropriate test data.
