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

  var session = new Mamajamas.Models.LoginSession({
    scope: Mamajamas.Context.Facebook.scope
  });

  var appAuth = new Mamajamas.Views.AppAuth({
    model: session,
    el: 'body'
  });
};
