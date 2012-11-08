require "minitest_helper"

class ListsControllerTest < MiniTest::Rails::ActionController::TestCase
  test "should get show" do
    sign_in create(:user)
    get :show
    assert_response :success
  end
end
