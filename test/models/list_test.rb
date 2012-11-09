require "minitest_helper"

class ListTest < MiniTest::Rails::ActiveSupport::TestCase
  def setup
    @list = nil
    @product_types = nil
  end

  test "list should have many product types" do
    add_product_types_to_list

    assert_equal product_types.size, list.product_types.size
    product_types.each do |product_type|
      assert list.product_types.include?(product_type)
    end
  end

  test "it should have many categories" do
    add_product_types_to_list
    assert_equal 2, list.categories.size
  end

  private

  def list
    @list ||= create(:list)
  end

  def product_types
    @product_types ||= [
      create(:product_type),
      create(:product_type)
    ]
  end

  def add_product_types_to_list
    product_types.each do |product_type|
      list.list_product_types << ListProductType.new({
        product_type: product_type,
        category: product_type.category
      })
    end

    assert list.save
  end
end
