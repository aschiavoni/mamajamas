require 'csv'

class Admin::ProductTypesCsvReport
  def initialize(product_types)
    @product_types = product_types
  end

  def generate
    CSV.generate do |csv|
      csv << attributes
      product_types.each do |product_type|
        product_type.class.send(:include, ProductTypeDecorator)
        csv << values(product_type)
      end
    end
  end

  private

  def product_types
    @product_types
  end

  def attributes
    @attrs ||= [
                :id,
                :category_name,
                :name,
                :plural_name,
                :priority,
                :slug,
                :image_name,
                :age,
                :search_index,
                :search_query,
                :recommended_quantity,
                :updated_at,
               ]
  end

  def values(product_type)
    attributes.map do |attr|
      product_type.public_send(attr)
    end
  end
end
