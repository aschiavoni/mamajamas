require "minitest_helper"

class FriendsControllerTest < MiniTest::Rails::ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
