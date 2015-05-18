describe ProductRatingUpdater, :type => :model do

  class MockCalculator
    class NoRating; end
    def initialize(*args); end
    def calculate
      { average: 3.0, count: 3 }
    end
  end

  class MockNoRatingCalculator
    class NoRating; end
    def initialize(*args); end
    def calculate; NoRating; end
  end

  it "creates new product ratings" do
    expect(ListItem).to receive(:unique_products) {
      [
        [ "12345", "amazon" ],
        [ "54321", "soap.com" ],
      ]
    }

    expect {
      ProductRatingUpdater.new(MockCalculator).update
    }.to change(ProductRating, :count).by(2)
  end

  it "updates product ratings" do
    product_rating = create(:product_rating, rating: 5.0)
    expect(ListItem).to receive(:unique_products) {
      [
        [ product_rating.vendor_id, product_rating.vendor ]
      ]
    }

    ProductRatingUpdater.new(MockCalculator).update
    product_rating.reload
    expect(product_rating.rating).to eq(3.0)
  end

  it "includes the number of ratings" do
    product_rating = create(:product_rating, rating: 5.0)
    expect(ListItem).to receive(:unique_products) {
      [
        [ product_rating.vendor_id, product_rating.vendor ]
      ]
    }

    ProductRatingUpdater.new(MockCalculator).update
    product_rating.reload
    expect(product_rating.rating_count).to eq(3)

  end

  it "removes a product rating if the calculator finds no rating" do
    product_rating = create(:product_rating)

    expect(ListItem).to receive(:unique_products) {
      [
        [ product_rating.vendor_id, product_rating.vendor ]
      ]
    }

    expect {
      ProductRatingUpdater.new(MockNoRatingCalculator).update
    }.to change(ProductRating, :count).by(-1)
  end

end
