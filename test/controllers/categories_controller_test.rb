require "minitest_helper"

class CategoriesControllerTest < MiniTest::Rails::ActionController::TestCase
  test "should get index" do
    sign_in create(:user)
    get :index, format: :json
    assert_response :success
  end
end
