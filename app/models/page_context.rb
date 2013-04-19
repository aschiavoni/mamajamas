class PageContext
  def initialize
    @show_progress = true
    @show_header = true
  end

  attr_accessor :page_id
  attr_accessor :body_class
  attr_accessor :subheader
  attr_accessor :progress_id
  attr_accessor :show_progress
  attr_accessor :show_header
end
