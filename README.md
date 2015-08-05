# mamajamas

## Welcome to Mama Jamas!

### Development Environment

#### Initial Setup

1. Add a working *database.yml* file

    `cp config/database.yml.example config/database.yml`

2. Adjust the parameters to work with your local database installation

3. Add a *.env* file

    `cp .env .env.example`

4. At minimum, set the following variables in *.env*

    * SECRET_TOKEN
    * SECRET_KEY_BASE

You can use `rake secret` to generate secure keys for those values.

#### Thin

We are using the thin web server in development and production.

#### Foreman

To launch both the web and background processes in development, use

    `bundle exec foreman start -f ./Procfile.development `

#### Redis

A local Redis server is required. The default settings should be fine (`apt-get install redis-server`).

#### Postgresql

1. Install the postgresql database on your development machine.
2. Create the role for the development and test environments.

        $ psql -d postgres
        postgres=# create role mamajamas login superuser;
        postgres=# CREATE EXTENSION IF NOT EXISTS hstore;
        postgres=# \q

3. Create the databases.

        rake db:create
        rake RAILS_ENV=test db:create
        rake db:migrate
        rake db:test:prepare
        rake db:seed

#### Bundler

On linux, you may have to install some dependencies before you can
successfully run 'bundle install'.

##### nokogiri requirements

    sudo apt-get install libxslt-dev libxml2-dev

##### Mailers

##### mailcatcher

In development, we can use the [mailcatcher](http://mailcatcher.me/)
gem to test email. First, you need to make sure you have the
mailcatcher gem installed. Run:

    gem install mailcatcher

Then, you need to make sure email delivery is enabled in
config/environments/development.rb:

    config.action_mailer.perform_deliveries = true

Next, run the mailcatcher command to start the mailcatcher server:

    mailcatcher

You can view the delivered emails in the mailcatcher web server which is
accessible (by default) at http://localhost:1080.

##### Mandrill

We are currently using the [Mandrill Heroku
add-on](https://addons.heroku.com/mandrill) to send email in production.
To use the same add-on in development mode, you need to configure two
environment variables. In the .env file at the root of the project, update
the following two environment variables:

    MANDRILL_APIKEY
    MANDRILL_USERNAME

To retrieve the above values from the staging instance, you can use the
following two heroku commands:

    heroku config:get MANDRILL_APIKEY
    heroku config:get MANDRILL_USERNAME

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

    config.action_mailer.perform_deliveries = true

Be aware that that making the above changes will result in real email
being sent so make sure you are working with appropriate test data.

Remember, making any of the changes described above requires a restart
of the rails server before they will take effect.

##### Mailchimp

We integrate with Mailchimp to keep an accurate and configurable mailing list. At minimum, you must configure a valid Mailchimp API key in your environment:

  MAILCHIMP_API_KEY

This will assume you have a list called  "Mamajamas Development". You can change this by setting

  MAILCHIMP_MAILING_LIST_NAME

in your environment. You can also change the interest grouping name (default: "Preferences") by setting:

  MAILCHIMP_MAILING_LIST_GROUPING

When deploying, use heroku config:set to configure the environment variables. For example:

    heroku config:set MAILCHIMP_API_KEY="XXXX" --app mamajamas

### Vagrant Development Environment (experimental)

You can also use a vagrant virtual machine for running the application in development.

#### Dependencies

* VirtualBox (https://www.virtualbox.org/)
* ChefDK (http://getchef.com/downloads/chef-dk)
* Vagrant (http://www.vagrantup.com/)

#### Instructions

1. Install dependencies
2. Install vagrant plugins:

    vagrant plugin install vagrant-berkshelf
    vagrant plugin install vagrant-omnibus

### Testing Environment

#### Stack

* [Rspec](https://github.com/rspec/rspec-rails)
* [Factory Girl](https://github.com/thoughtbot/factory_girl)
* [Capybara](https://github.com/jnicklas/capybara)
* [Poltergeist](https://github.com/jonleighton/poltergeist)

#### External Dependencies

##### PhantomJS

##### memcached

    brew install memcached

###### Mac

    brew install phantomjs


### Amazon Searching and Uploads

Amazon API options are set via environment variables. The following
environment variables need to be set in your environment:

  AMAZON_ASSOCIATE_TAG
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  FOG_DIRECTORY
  FOG_PROVIDER

FOG_PROVIDER will always be "AWS" but the other variables can differ
in each environment.

When deploying, use heroku config:set to configure the environment
variables. For example:

    heroku config:set AMAZON_ASSOCIATE_TAG="XXXX" --app mamajamas
    heroku config:set AWS_ACCESS_KEY_ID="XXXX" --app mamajamas
    heroku config:set AWS_SECRET_ACCESS_KEY="XXXX" --app mamajamas
    heroku config:set FOG_DIRECTORY="mamajamas" --app mamajamas
    heroku config:set FOG_PROVIDER="AWS" --app mamajamas

---
