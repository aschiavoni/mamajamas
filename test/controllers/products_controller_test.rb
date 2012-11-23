require "minitest_helper"

class ProductsControllerTest < MiniTest::Rails::ActionController::TestCase
  test "should get index" do
    category = create(:category)
    product_type = create(:product_type, category: category)

    sign_in create(:user)
    get :index, category_id: category.id, product_type_id: product_type.id, format: :json
    assert_response :success
  end
end
