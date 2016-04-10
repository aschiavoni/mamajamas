FROM ruby:2.1.3

RUN \
  apt-get update -qq && \
  apt-get install -y build-essential && \
  apt-get install -y curl vim git wget libfreetype6 libfontconfig bzip2 && \
  apt-get install -y libpq-dev postgresql-client && \
  apt-get install -y nodejs && \
  apt-get install -y imagemagick && \
  apt-get autoremove -y && \
  apt-get clean all

ENV PHANTOMJS_VERSION 1.9.7

RUN \
  mkdir -p /srv/var && \
  curl -s -L -o /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 https://bitbucket.org/ariya/phantomjs/downloads/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  tar -xjf /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 -C /tmp && \
  rm -f /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64.tar.bz2 && \
  mv /tmp/phantomjs-$PHANTOMJS_VERSION-linux-x86_64/ /srv/var/phantomjs && \
  ln -s /srv/var/phantomjs/bin/phantomjs /usr/bin/phantomjs && \
  git clone https://github.com/n1k0/casperjs.git /srv/var/casperjs && \
  ln -s /srv/var/casperjs/bin/casperjs /usr/bin/casperjs

ENV RAILS_ENV development
RUN mkdir /myapp
WORKDIR /myapp
RUN gem update bundler
ADD Gemfile /myapp/Gemfile
ADD Gemfile.lock /myapp/Gemfile.lock
RUN bundle install
ADD . /myapp
