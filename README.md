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

##### mailcatcher

In development, we can use the [mailcatcher](http://mailcatcher.me/) gem
to test email. First you need to make sure email delivery is enabled in
config/environments/development.rb:

> config.action_mailer.perform_deliveries = true

Next, run the mailcatcher command to start the mailcatcher server:

> mailcatcher

You can view the delivered emails in the mailcatcher web server which is
accessible (by default) at http://localhost:1080.

##### Mandrill

We are currently using the [Mandrill Heroku
add-on](https://addons.heroku.com/mandrill) to send email in production.
To use the same add-on in development mode, you need to configure two
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
  config.action_mailer.smtp_settings = {
    :address              => "smtp.mandrillapp.com",
    :port                 => 587,
    :domain               => "heroku.com",
    :user_name            => ENV['MANDRILL_USERNAME'],
    :password             => ENV['MANDRILL_APIKEY'],
    :authentication       => "plain"
  }
```

You also need to make sure email delivery is enabled:

> config.action_mailer.perform_deliveries = true

Be aware that that making the above changes will result in real email
being sent so make sure you are working with appropriate test data.

Remember, making any of the changes described above requires a restart
of the rails server before they will take effect.
