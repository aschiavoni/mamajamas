function AffiliateLink(url) {
  var that = {};

  var AFFILIATE_URL = "http://go.redirectingat.com/?";
  var AFFILIATE_PUBLISHER_ID = "123X456"

  that.url = url;

  this.generateUrl = function(url) {
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
