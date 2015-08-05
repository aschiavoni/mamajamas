require 'spec_helper'
require 'csv'

describe MagicBeansProductImporterRow do
  def row_csv(name = "Infant Bearhands", product_type_name = "Gloves & Mittens")
    r = "471374289|Infant Bearhands|27456|Magic Beans|http://www.shareasale.com/m-pr.cfm?merchantID=27456&userID=YOURUSERID&productID=471374289|http://mbeans.com/images/items/auto/000/020/99/thumb_s7573.jpg|http://mbeans.com/images/items/main/bearhands/BEARHANDS-camel-infant-bearhands-IF1000-CA.jpg|12.99|12.99|Gifts/Specialty|Baby/Infant|Keeping little hands warm when the weather gets cold can be quite a struggle. One minute the mittens are on, and the next, one is off. Or both. We're sure there's a place where all the small, lost mittens congregate, not too far from where all the lost Laundromat socks gather, but until we find that place, we'll stick with Bearhands.  Bearhands are oversized, aww-inspiring bear \"paws\" that keep kids' hands toasty warm even in the bitter cold. These fleece mittens are lined with Thinsulate for extra protection and the child sizes have a secret opening that allows kids to access their hands without removing their mittens - perfect for putting the finishing touches on a snowman or that speedy trip inside for a chug of hot cocoa between sledding adventures. Bear Hands are available in infant, toddler, and child sizes.  Spilling the beans : There's no secret or great design innovation to explain why Bearhands stay on better than other mittens - kids just love to wear them. If you want to be absolutely sure you don't lose your mittens, we recommend finding a set of mitten clips.  Features :  Thinsulate-lined fleece mittens  Sizes: baby (approximately 6-18 months), toddler (approximately 18-36 months), and youth small (approximately 3-7 years)  Quality fleece keeps hands dry and warm  Textured pads for easy gripping  Drawstring at the wrist keeps snow and cold out (Child size only)  Youth size has a \"secret opening\" so kids can access their hands without removing their mittens||||||2014-08-25 15:40:46.933|instock|Bearhands||Clothing & Accessories|Accessories|Camel|||10419||Gloves & Mittens|||||0|http://www.shareasale.com/m-pr.cfm?merchantID=27456&userID=YOURUSERID&atc=1&productID=471374289|||||||http://www.shareasale.com/m-pr.cfm?merchantID=27456&userID=YOURUSERID&mobile=1&productID=471374289|||||||||"
    CSV.parse(r, col_sep: "|", quote_char: "\x00").flatten
  end

  def product_row
    MagicBeansProductImporterRow.new(row_csv)
  end

  it "finds vendor id" do
    expect(product_row.vendor_id).to eq("471374289")
  end

  it "finds vendor name" do
    expect(product_row.vendor_name).to eq("Magic Beans")
  end

  it "finds url" do
    expect(product_row.url).to eq("http://www.shareasale.com/m-pr.cfm?merchantID=27456&userID=984701&productID=471374289")
  end

  it "finds image url" do
    img = "http://mbeans.com/images/items/auto/000/020/99/thumb_s7573.jpg"
    expect(product_row.image_url).to eq(img)
  end

  it "finds medium image url" do
    img = "http://mbeans.com/images/items/main/bearhands/BEARHANDS-camel-infant-bearhands-IF1000-CA.jpg"
    expect(product_row.medium_image_url).to eq(img)
  end

  it "finds large image url" do
    img = "http://mbeans.com/images/items/main/bearhands/BEARHANDS-camel-infant-bearhands-IF1000-CA.jpg"
    expect(product_row.large_image_url).to eq(img)
  end

  it "finds product name" do
    expect(product_row.name).to eq("Infant Bearhands")
  end

  it "finds vendor product type name" do
    expect(product_row.vendor_product_type_name).to eq("Gloves & Mittens")
  end

  it "finds main category" do
    expect(product_row.main_category).to eq("Clothing & Accessories")
  end

  it "finds subcategory" do
    expect(product_row.sub_category).to eq("Accessories")
  end

  it "finds the price" do
    expect(product_row.price).to eq("12.99")
  end

  it "finds the brand" do
    expect(product_row.brand).to eq("Bearhands")
  end

  it "finds the manufacturer" do
    expect(product_row.manufacturer).to eq("Bearhands")
  end

  it "finds the description" do
    expect(product_row.description).to match(/^Keeping little hands warm/)
  end

  it "finds the short description" do
    expect(product_row.short_description).to eq("Camel")
  end

  it "finds the matching product type id" do
    pt = create(:product_type, aliases: ["Gloves & Mittens", "Gloves"])
    expect(product_row.product_type_id).to eq(pt.id)
  end

  it "finds the matching product type name" do
    pt = create(:product_type, aliases: ["Gloves & Mittens", "Gloves"])
    expect(product_row.product_type_name).to eq(pt.name)
  end

  it "saves row to the database" do
    create(:product_type, aliases: ["Gloves & Mittens", "Gloves"])
    expect { product_row.save! }.to change { Product.count }.by(1)
  end

end
