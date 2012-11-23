require "minitest_helper"

class ProductTypesControllerTest < MiniTest::Rails::ActionController::TestCase
  test "should get index" do
    sign_in create(:user)
    get :index, category_id: create(:category).id, format: :json
    assert_response :success
  end
end
