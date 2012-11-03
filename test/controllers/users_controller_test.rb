require "minitest_helper"

class UsersControllerTest < MiniTest::Rails::ActionController::TestCase
  test "should get edit" do
    get :edit, id: create(:user)
    assert_response :success
  end
end
