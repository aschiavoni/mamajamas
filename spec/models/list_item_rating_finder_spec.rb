describe ListItemRatingFinder, :type => :model do

  let(:vendor_id) { "B002PLU912" }
  let(:vendor) { "amazon" }

  def list_items(include_nil_rating = false)
    items = [
      build(:list_item, vendor: vendor, vendor_id: vendor_id, rating: 3),
      build(:list_item, vendor: vendor, vendor_id: vendor_id, rating: 2)
    ]
    if include_nil_rating
      items << build(:list_item, vendor: vendor, vendor_id: vendor_id, rating: nil)
    end
    items
  end

  it "queries the database by the vendor and vendor id" do
    expect(ListItem).to receive(:where).
      with(hash_including(vendor_id: vendor_id, vendor: vendor))
    ListItemRatingFinder.find(vendor_id, vendor)
  end

  it "returns a list of ratings for a vendor and vendor id combo" do
    expect(ListItem).to receive(:where).
      with(hash_including(vendor_id: vendor_id, vendor: vendor)).
      and_return(list_items)
    expect(ListItemRatingFinder.find(vendor_id, vendor)).to eq([ 3, 2 ])
  end

  it "excludes nil ratings" do
    expect(ListItem).to receive(:where).
      with(hash_including(vendor_id: vendor_id, vendor: vendor)).
      and_return(list_items(true))
    expect(ListItemRatingFinder.find(vendor_id, vendor)).to eq([ 3, 2 ])
  end

end
