require 'spec_helper'

describe Category do

  describe "slugs" do

    it "should have slugged value" do
      category = create(:category, name: "Category 1")
      category.slug.should == "category-1"
    end

  end

end
