class Admin::ProductTypesView
  def initialize(category)
    @category = category
  end

  def category_slug
    category.slug
  end

  def categories
    @categories ||= Category.all.order(:name)
  end

  def category
    @category
  end

  def product_types
    category.product_types.order(:name)
  end

  def amazon_search_indexes
    @search_index = [
      "All",
      "Apparel",
      "Appliances",
      "ArtsAndCrafts",
      "Automotive",
      "Baby",
      "Beauty",
      "Blended",
      "Books",
      "Classical",
      "Collectibles",
      "DigitalMusic",
      "DVD",
      "Electronics",
      "ForeignBooks",
      "Garden",
      "GourmetFood",
      "Grocery",
      "HealthPersonalCare",
      "Hobbies",
      "Home",
      "HomeGarden",
      "HomeImprovement",
      "Industrial",
      "Jewelry",
      "KindleStore",
      "Kitchen",
      "LawnAndGarden",
      "Lighting",
      "Magazines",
      "Marketplace",
      "Miscellaneous",
      "MobileApps",
      "MP3Downloads",
      "Music",
      "MusicalInstruments",
      "MusicTracks",
      "OfficeProducts",
      "OutdoorLiving",
      "Outlet",
      "PCHardware",
      "PetSupplies",
      "Photo",
      "Shoes",
      "Software",
      "SoftwareVideoGames",
      "SportingGoods",
      "Tools",
      "Toys",
      "UnboxVideo",
      "VHS",
      "Video",
      "VideoGames",
      "Watches",
      "Wireless",
      "WirelessAccessories"
    ]
  end

  def csv
    product_types = ProductType.all.order(:category_id)
    Admin::ProductTypesCsvReport.new(product_types).generate
  end
end
