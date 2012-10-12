require "minitest_helper"

class SignUpTest < MiniTest::Rails::ActionDispatch::IntegrationTest
  test "successful sign up" do
    visit '/users/signup'

    fill_in "Username", with: "testuser"
    fill_in "Email", with: "testuser@domain.com"
    fill_in "Password", with: "really good password"
    fill_in "Confirm password", with: "really good password"

    click_button "Create Account"
    assert page.has_content?("Welcome to Mamajamas!")
  end
end
