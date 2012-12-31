class ListProductType < ActiveRecord::Base
  belongs_to :list
  belongs_to :product_type
  belongs_to :category

  attr_accessible :product_type, :category, :hidden

  def hide!
    update_attributes!(hidden: true)
  end
end
