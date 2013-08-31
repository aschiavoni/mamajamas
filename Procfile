web: bundle exec thin start -R config.ru -e $RAILS_ENV -p $PORT
worker: env DB_POOL=25 bundle exec sidekiq -c 5 -v -q default,2 -q mailer
