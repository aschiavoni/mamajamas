class PageContext
  def initialize
    @show_header = true
    @show_mainnav = true
  end

  attr_accessor :page_id
  attr_accessor :body_class
  attr_accessor :body_id
  attr_accessor :tertiary_class
  attr_accessor :subheader
  attr_accessor :preheader
  attr_accessor :show_header
  attr_accessor :show_mainnav
  attr_accessor :skip_secondary_content

  def skip_secondary_content?
    skip_secondary_content == true
  end
end
