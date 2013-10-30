class PageContext
  def initialize
    @show_header = true
    @show_mainnav = true
  end

  attr_accessor :page_id
  attr_accessor :body_class
  attr_accessor :subheader
  attr_accessor :preheader
  attr_accessor :show_header
  attr_accessor :show_mainnav
end
