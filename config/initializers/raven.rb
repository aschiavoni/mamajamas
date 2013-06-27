require 'raven'

if Rails.env.staging?
  Raven.configure do |config|
    config.dsn = 'https://6eb791d810cd4282a27b316e4f0ff42e:b5a3271cf7a749b2be2999fad585a20e@app.getsentry.com/9536'
  end
end
