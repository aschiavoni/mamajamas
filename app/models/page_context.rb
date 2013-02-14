class PageContext
  def initialize
    @show_progress = true
  end

  attr_accessor :page_id
  attr_accessor :subheader
  attr_accessor :progress_id
  attr_accessor :show_progress
end
