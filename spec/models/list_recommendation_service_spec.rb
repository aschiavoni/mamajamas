require 'spec_helper'

describe ListRecommendationService do
  let(:user) { create(:user) }

  before(:all) { user.build_list! }

  it "removes a placeholder and replaces it with a recommended product" do
    pt = user.list.list_items.first.product_type
    create(:recommended_product, product_type: pt, tag: "eco")

    lambda do
      ListRecommendationService.new(user).update!
    end.should change(user.list.list_items.placeholders, :count).by(-1)
  end

  it "replaces a placeholder with a list item" do
    pt = user.list.list_items.first.product_type
    create(:recommended_product, product_type: pt, tag: "eco")

    lambda do
      ListRecommendationService.new(user).update!
    end.should change(user.list.list_items.user_items, :count).by(1)
  end

end
