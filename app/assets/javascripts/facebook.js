// have to rescue nil on FACEBOOK_CONFIG so that heroku can precompile assets
jQuery(function() {
  // load fb sdk async
  $("body").prepend('<div id="fb-root"></div>');
  return $.ajax({
    url: "" + window.location.protocol + "//connect.facebook.net/en_US/all.js",
    dataType: 'script',
    cache: true
  });
});

window.fbAsyncInit = function() {
  FB.init({
    appId: Mamajamas.Context.Facebook.appId,
    channelUrl: '//' + window.location.host + '/channel.html',
    status: true,
    cookie: true,
    xfbml: true
  });

  Mamajamas.Context.LoginSession = new Mamajamas.Models.LoginSession({
    scope: Mamajamas.Context.Facebook.scope
  });

  Mamajamas.Context.AppAuth = new Mamajamas.Views.AppAuth({
    model: Mamajamas.Context.LoginSession,
    el: 'body'
  });
};
