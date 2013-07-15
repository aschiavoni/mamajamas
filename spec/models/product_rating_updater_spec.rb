describe ProductRatingUpdater do

  class MockCalculator
    class NoRating; end
    def initialize(*args); end
    def calculate; 3.0; end
  end

  class MockNoRatingCalculator
    class NoRating; end
    def initialize(*args); end
    def calculate; NoRating; end
  end

  it "creates new product ratings" do
    ListItem.should_receive(:unique_products) {
      [
        [ "12345", "amazon" ],
        [ "54321", "soap.com" ],
      ]
    }

    ProductRating.should_receive(:create).twice

    ProductRatingUpdater.new(MockCalculator).update
  end

  it "updates product ratings" do
    product_rating = create(:product_rating)

    ListItem.should_receive(:unique_products) {
      [
        [ product_rating.vendor_id, product_rating.vendor ]
      ]
    }
    ProductRating.any_instance.should_receive(:update_attributes!).with(rating: 3.0)

    ProductRatingUpdater.new(MockCalculator).update
  end

  it "removes a product rating if the calculator finds no rating" do
    product_rating = create(:product_rating)

    ListItem.should_receive(:unique_products) {
      [
        [ product_rating.vendor_id, product_rating.vendor ]
      ]
    }
    ProductRating.any_instance.should_receive(:destroy)

    ProductRatingUpdater.new(MockNoRatingCalculator).update
  end

end
