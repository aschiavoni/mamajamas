function AffiliateLink(url) {
  var that = {};

  var AFFILIATE_URL = "http://go.redirectingat.com/?";
  var AFFILIATE_PUBLISHER_ID = "123X456"
  var AFFILIATE_AMAZON_ID = "mamajamas-20"

  that.url = url;

  this.generateUrl = function(url) {
    // don't rewrite amazon urls that include our
    // naive check
    if (/amazon\.com/i.test(url) && new RegExp(AFFILIATE_AMAZON_ID, "i").test(url))
      return url;

    var params = {
      id: AFFILIATE_PUBLISHER_ID,
      url: url
    };
    var qs = jQuery.param(params);
    return AFFILIATE_URL + qs;
  };

  that.affiliateUrl = this.generateUrl(that.url);

  return that;
}
