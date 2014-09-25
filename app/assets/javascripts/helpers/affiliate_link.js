function AffiliateLink(url) {
  var that = {};

  var AFFILIATE_URL = "http://go.mamajamas.com/?";
  var AFFILIATE_PUBLISHER_ID = "71653X1520441";
  var AFFILIATE_AMAZON_ID = "mamajamas-20";
  var AFFILIATE_SHAREASALE_ID = "984701";

  that.url = url;

  var uid = 0;
  if (Mamajamas && Mamajamas.Context && Mamajamas.Context.User)
    uid = Mamajamas.Context.User.get('id');

  this.generateUrl = function(url, uid) {
    // don't rewrite existing affiliate urls
    // naive checks
    if (/amazon\.com/i.test(url) && new RegExp(AFFILIATE_AMAZON_ID, "i").test(url))
      return url;

    if (/shareasale.com/i.test(url) && new RegExp(AFFILIATE_SHAREASALE_ID, "i").test(url))
      return url;

    var params = {
      id: AFFILIATE_PUBLISHER_ID,
      url: url,
      xs: 1,
      xcust: uid,
      sref: window.location.toString()
    };
    var qs = jQuery.param(params);
    return AFFILIATE_URL + qs;
  };

  that.affiliateUrl = this.generateUrl(that.url, uid);

  return that;
}

Handlebars.registerHelper('affiliateLink', function(url) {
  return new AffiliateLink(url).affiliateUrl;
});

Handlebars.registerHelper('buyLink', function(listItem) {
  var url = new AffiliateLink(listItem.link).affiliateUrl;

  var link = "<a target=\"_blank\" href=\"" + url + "\">Buy</a> "

  if (listItem.age == "Pre-birth") {
    link += " " + listItem.age;
  } else {
    link += "at " + listItem.age;
  }

  return new Handlebars.SafeString(link);
});
