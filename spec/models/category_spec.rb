require 'spec_helper'

describe Category do

  describe "slugs" do

    it "should have slugged value" do
      category = create(:category, name: "Test Category 1")
      category.slug.should == "test-category-1"
    end

  end

end
