describe ProductSearcher do

  it "searches catalog for items" do
    product = create(:product, name: 'A GloboChem Product')
    ProductSearcher.search('globochem').should include(product)
  end

  it "does not find matching item in catalog" do
    ProductSearcher.search('globochem').should be_empty
  end

  it "limits the number of items returned" do
    2.times do |i|
      create(:product, name: "A GloboChem Product #{i+1}")
    end
    ProductSearcher.search('globochem', 1).should have(1).products
  end

end
