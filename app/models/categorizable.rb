module Categorizable
  extend ActiveSupport::Concern

  included do
    attr_accessible :category_id
    belongs_to :category
  end

  module ClassMethods
    def by_category(category)
      category.blank? ? scoped : where(category_id: category.id)
    end
  end
end
