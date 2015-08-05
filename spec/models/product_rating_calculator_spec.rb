describe ProductRatingCalculator, :type => :model do

  let(:vendor_id) { "B002PLU912" }
  let(:vendor) { "amazon" }

  it "calculates a rating for an amazon product" do
    expect(ListItemRatingFinder).to receive(:find).
      with(vendor_id, vendor).
      and_return([ 3, 4 ])

    calc = ProductRatingCalculator.new vendor_id, vendor
    expect(calc.calculate[:average]).to eq(3.5)
  end

  it "rounds a rating up to the nearest half rating" do
    map = {
      [3, 3, 4] => 3.5, # 3.333
      [3, 3, 5] => 3.5, # 3.666
      [3, 3, 5] => 3.5, # 3.666
      [2, 2, 4, 5] => 3.5, # 3.25
      [4, 4, 4, 4, 5] => 4.0, # 4.2
    }
    map.each do |ratings, result|
      expect(ListItemRatingFinder).to receive(:find).
        with(vendor_id, vendor).
        and_return(ratings)

      calc = ProductRatingCalculator.new vendor_id, vendor
      expect(calc.calculate[:average]).to eq(result)
    end
  end

  it "includes the number of ratings in the result" do
    expect(ListItemRatingFinder).to receive(:find).
      with(vendor_id, vendor).
      and_return([ 3, 4 ])

    calc = ProductRatingCalculator.new vendor_id, vendor
    expect(calc.calculate[:count]).to eq(2)
  end

  it "indicates there is no rating for a product that has not been rated" do
    calc = ProductRatingCalculator.new "jdksdjksdf", vendor
    expect(calc.calculate).to eq(ProductRatingCalculator::NoRating)
  end

end
