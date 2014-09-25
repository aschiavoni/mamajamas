//= require application

describe("AffiliateLink", function() {
  it("generates an affiliate link from a regular link", function() {
    var url = "http://google.com/";
    var affUrl =
      "http://go.redirectingat.com/?id=123X456&url=http%3A%2F%2Fgoogle.com%2F";

    var al = new AffiliateLink(url);
    expect(al.affiliateUrl).toEqual(affUrl)
  });

  it("does not generate an affiliate url for amzn affiliate urls", function() {
    var url =
      "http://www.amazon.com/Keekaroo-Peanut-Diaper-Changer-Solid/dp/B009A7VTYA%3FSubscriptionId%3DAKIAIXAEIBVZBZEU56MQ%26tag%3Dmamajamas-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB009A7VTYA";

    var al = new AffiliateLink(url);
    expect(al.affiliateUrl).toEqual(url);
  });

  it("does generate an affiliate url for amzn non-affiliate urls", function() {
    var url = "http://www.amazon.com/Keekaroo-Peanut-Diaper-Changer-Solid/dp/B009A7VTYA%3FSubscriptionId%3DAKIAIXAEIBVZBZEU56MQ%26tag%3Dsommaff-20%26linkCode%3Dxm2%26camp%3D2025%26creative%3D165953%26creativeASIN%3DB009A7VTYA";
    var affUrl = "http://go.redirectingat.com/?id=123X456&url=http%3A%2F%2Fwww.amazon.com%2FKeekaroo-Peanut-Diaper-Changer-Solid%2Fdp%2FB009A7VTYA%253FSubscriptionId%253DAKIAIXAEIBVZBZEU56MQ%2526tag%253Dsommaff-20%2526linkCode%253Dxm2%2526camp%253D2025%2526creative%253D165953%2526creativeASIN%253DB009A7VTYA";

    var al = new AffiliateLink(url);
    expect(al.affiliateUrl).toEqual(affUrl);
  });
});
