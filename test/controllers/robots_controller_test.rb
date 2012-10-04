require "minitest_helper"

class RobotsControllerTest < MiniTest::Rails::ActionController::TestCase
  test "should get robots.txt" do
    get :show
    assert_response :success
  end
end
