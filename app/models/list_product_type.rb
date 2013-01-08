class ListProductType < ActiveRecord::Base
  belongs_to :list
  belongs_to :product_type
  belongs_to :category

  attr_accessible :product_type, :category, :hidden

  scope :visible, where(hidden: false)
  scope :hidden, where(hidden: true)

  def hide!
    update_attributes!(hidden: true)
  end

  def unhide!
    update_attributes!(hidden: false)
  end
end
