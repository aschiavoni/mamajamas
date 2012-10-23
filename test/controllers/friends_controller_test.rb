require "minitest_helper"

class FriendsControllerTest < MiniTest::Rails::ActionController::TestCase
  test "should get index" do
    sign_in create(:user)
    get :index
    assert_response :success
  end
end
