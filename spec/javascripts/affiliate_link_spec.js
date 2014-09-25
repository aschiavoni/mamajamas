//= require application

describe("AffiliateLink", function() {
  it("generates an affiliate link from a regular link", function() {
    var url = "http://google.com/";
    var affUrl =
      "http://go.redirectingat.com/?id=123X456&url=http%3A%2F%2Fgoogle.com%2F";

    var al = new AffiliateLink(url);
    expect(al.affiliateUrl).toEqual(affUrl)
  });
});
