describe ProductRatingCalculator do

  let(:vendor_id) { "B002PLU912" }
  let(:vendor) { "amazon" }

  it "calculates a rating for an amazon product" do
    ListItemRatingFinder.should_receive(:find).
      with(vendor_id, vendor).
      and_return([ 3, 4 ])

    calc = ProductRatingCalculator.new vendor_id, vendor
    calc.calculate[:average].should == 3.5
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
      ListItemRatingFinder.should_receive(:find).
        with(vendor_id, vendor).
        and_return(ratings)

      calc = ProductRatingCalculator.new vendor_id, vendor
      calc.calculate[:average].should == result
    end
  end

  it "includes the number of ratings in the result" do
    ListItemRatingFinder.should_receive(:find).
      with(vendor_id, vendor).
      and_return([ 3, 4 ])

    calc = ProductRatingCalculator.new vendor_id, vendor
    calc.calculate[:count].should == 2
  end

  it "indicates there is no rating for a product that has not been rated" do
    calc = ProductRatingCalculator.new "jdksdjksdf", vendor
    calc.calculate.should == ProductRatingCalculator::NoRating
  end

end
