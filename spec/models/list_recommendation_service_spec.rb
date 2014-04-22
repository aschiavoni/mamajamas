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

  it "prefers a twin recommendation if the user has multiples" do
    user.should_receive(:has_multiples?) { true }

    pt = user.list.list_items.first.product_type
    create(:recommended_product, name: "eco rec",
           product_type: pt, tag: "eco")
    create(:recommended_product, name: "twins rec",
           product_type: pt, tag: "twins")

    ListRecommendationService.new(user).update!
    user.list.reload.list_items.user_items.pluck(:name).
      should include("twins rec")
  end

end
