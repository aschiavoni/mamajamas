require 'spec_helper'

describe ListRecommendationService, :type => :model do
  before(:all) {
    @user = create(:user)
    @user.build_list!
  }

  it "removes a placeholder and replaces it with a recommended product" do
    pt = @user.list.list_items.first.product_type
    create(:recommended_product, product_type: pt, tag: "eco")

    expect do
      ListRecommendationService.new(@user).update!
    end.to change(@user.list.list_items.placeholders, :count).by(-1)
  end

  it "replaces a placeholder with a list item" do
    pt = @user.list.list_items.first.product_type
    create(:recommended_product, product_type: pt, tag: "eco")

    expect do
      ListRecommendationService.new(@user).update!
    end.to change(@user.list.list_items.user_items, :count).by(1)
  end

  it "prefers a twin recommendation if the user has multiples" do
    expect(@user).to receive(:has_multiples?) { true }

    pt = @user.list.list_items.first.product_type
    create(:recommended_product, name: "eco rec",
           product_type: pt, tag: "eco")
    create(:recommended_product, name: "twins rec",
           product_type: pt, tag: "twins")

    ListRecommendationService.new(@user).update!
    expect(@user.list.reload.list_items.user_items.pluck(:name)).
      to include("twins rec")
  end

  it "replaces a placeholder with a recommended list item" do
    pt = @user.list.list_items.first.product_type
    create(:recommended_product, product_type: pt, tag: "eco")

    expect do
      ListRecommendationService.new(@user).update!
    end.to change(@user.list.list_items.user_items.recommended, :count).by(1)
  end

  context 'clear_recommendations!' do
    before(:each) {
      @c1 = create(:category)
      @c2 = create(:category)
      create(:list_item, recommended: true, list: @user.list, category_id: @c1.id)
      create(:list_item, recommended: true, list: @user.list, category_id: @c2.id)
    }

    it "clears all recommendations from a list" do
      ListRecommendationService.new(@user).clear_recommendations!
      expect(@user.list.reload.list_items.recommended.count).to eq(0)
    end

    it "restores placeholders to a list" do
      rc = @user.list.list_items.recommended.count
      expect do
        ListRecommendationService.new(@user).clear_recommendations!
      end.to change(@user.list.list_items.placeholders, :count).by(rc)
    end

    it "clears all recommendations from a category" do
      ListRecommendationService.new(@user, @c1).clear_recommendations!
      expect(@user.list.reload.list_items.recommended.count).to eq(1)
    end

    it "restores placeholders to a category" do
      rc = @user.list.list_items.recommended.where(category_id: @c1.id).count
      expect do
        ListRecommendationService.new(@user, @c1).clear_recommendations!
      end.to change(@user.list.list_items.placeholders, :count).by(rc)
    end

  end
end
