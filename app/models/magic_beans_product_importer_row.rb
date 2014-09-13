class MagicBeansProductImporterRow
  SHAREASALE_USERID = '984701'
  VENDOR = "magic_beans"

  def initialize(csv_row)
    @row = csv_row
  end

  def vendor_id
    row[0]
  end

  def vendor
    VENDOR
  end

  def name
    row[1]
  end

  def url
    row[4].gsub('YOURUSERID', SHAREASALE_USERID)
  end

  def image_url
    row[5] || large_image_url
  end

  def large_image_url
    @large_image_url ||= row[6]
  end

  def medium_image_url
    large_image_url
  end

  def main_category
    row[21]
  end

  def sub_category
    row[22]
  end

  def specific_category
    row[28]
  end

  def price
    row[7]
  end

  def manufacturer
    @manufacturer ||= row[19]
  end

  def brand
    manufacturer
  end

  def description
    row[11]
  end

  def short_description
    row[23]
  end

  def product_type_name
    specific_category || sub_category || main_category
  end

  def details
    row
  end

  def save!
    product.save! if valid?
  end

  def valid?
    [ :name, :vendor, :vendor_id, :url, :image_url ].each do |attr|
      return false if public_send(attr).blank?
    end
    true
  end

  def product
    @product ||= build_product
  end

  private

  def row
    @row
  end

  def build_product
    product = Product.find_by(vendor_id: vendor_id, vendor: vendor)
    if product.blank?
      product = Product.new(product_attributes)
    else
      product.assign_attributes(product_attributes)
    end
    product
  end

  def product_attributes
    {
     name: name,
     rating: nil,
     rating_count: 0,
     url: url,
     image_url: image_url,
     medium_image_url: medium_image_url,
     large_image_url: large_image_url,
     vendor: vendor,
     vendor_id: vendor_id,
     sales_rank: nil,
     brand: brand,
     manufacturer: manufacturer,
     model: nil,
     department: nil,
     categories: nil,
     price: price,
     mamajamas_rating: nil,
     mamajamas_rating_count: 0,
     description: description,
     short_description: short_description,
     product_type_name: product_type_name
    }
  end
end
