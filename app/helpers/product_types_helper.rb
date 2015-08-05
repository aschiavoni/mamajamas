module ProductTypesHelper
  def recommended_product_tag_label(tag)
    t = tag.to_sym
    t == :cost ? "Cost Conscious" : t.to_s.titleize
  end
end
