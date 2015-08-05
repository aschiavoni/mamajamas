require 'spec_helper'

describe Category, :type => :model do

  describe "slugs" do

    it "should have slugged value" do
      category = create(:category, name: "Test Category 1")
      expect(category.slug).to eq("test-category-1")
    end

  end

end
