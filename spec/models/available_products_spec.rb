describe AvailableProducts do

  let(:active) { stub }

  def stubbed_product_type(results)
    stub(:products => stub(:active => results))
  end

  it "should return products for product type" do
    product_type = stubbed_product_type([ active ])
    AvailableProducts.new.find(product_type).should == [ active ]
  end

  it "should return all active products when no product type" do
    product = stub(:active => [ active ])
    AvailableProducts.new(product).find.should == [ active ]
  end

  it "should return all active products when there are no products for product type" do
    product_type = stubbed_product_type([])
    product = stub(:active => [ active ])
    AvailableProducts.new(product).find(product_type).should == [ active ]
  end

  it "should filter products by name" do
    asdf = stub(:name => "asdf")
    zyxw = stub(:name => "zyxw")
    product_type = stubbed_product_type([ asdf, zyxw ])

    ap = AvailableProducts.new
    ap.should_receive(:filter_by).with([ asdf, zyxw ], "sd").and_return([ asdf ])
    ap.find(product_type, "sd").should == [ asdf ]
  end

  it "should limit the number of products returned" do
    results = [ stub, stub ]
    product_type = stubbed_product_type(results)
    ap = AvailableProducts.new
    ap.should_receive(:limit_by).with(results, 1).and_return([ results.first ])
    ap.find(product_type, nil, 1).size.should == 1
  end

end
