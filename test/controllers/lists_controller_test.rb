require "minitest_helper"

class ListsControllerTest < MiniTest::Rails::ActionController::TestCase
  def setup
    # create a few product types and categories
    3.times do 
      create(:product_type)
    end
  end

  test "should get show" do
    sign_in create(:user)
    get :show
    assert_response :success
  end
end
