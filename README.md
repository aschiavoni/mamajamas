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
