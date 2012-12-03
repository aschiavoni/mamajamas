require 'spec_helper'

describe ProductType do

  let(:bathing_category) { create(:category, name: "bathing") }
  let(:changing_category) { create(:category, name: "changing") }
  let(:categories) { [ bathing_category, changing_category ] }

  describe "by category" do

    before(:each) do
      @b1 = create(:product_type, category_id: bathing_category.id)
      @b2 = create(:product_type, category_id: bathing_category.id)
      @c1 = create(:product_type, category_id: changing_category.id)
      @c2 = create(:product_type, category_id: changing_category.id)
      @all_product_types = [ @b1, @b2, @c1, @c2 ]
    end

    describe "filtered by category" do

      before(:each) do
        @results = subject.class.by_category(bathing_category)
      end

      it "should only include product types in the bathing category" do
        @results.should include(@b1)
      end

      it "should include all bathing product types" do
        @results.size.should == 2 # @b1 and @b2
      end

      it "should not include product types in the changing category" do
        @results.should_not include(@c1)
      end

    end

    describe "filtered by nil category" do

      before(:each) do
        @results = subject.class.by_category(nil)
      end

      it "should include all product types" do
        @results.size.should == @all_product_types.size
      end

    end

  end

  describe "image name" do

    it "should return image name" do
      pt = create(:product_type, image_name: "test.png")
      pt.image_name.should == "test.png"
    end

    it "should return unknown image name when image name is blank" do
      pt = create(:product_type, image_name: nil)
      pt.image_name.should == "unknown.png"
    end

  end

end
