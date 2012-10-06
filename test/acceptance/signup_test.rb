require "minitest_helper"

class SignUpTest < MiniTest::Rails::ActionDispatch::IntegrationTest
  test "successful sign up" do
    visit '/users/signup'

    fill_in "Username", with: "testuser"
    fill_in "Email", with: "testuser@domain.com"
    fill_in "Password", with: "really good password"
    fill_in "Password confirmation", with: "really good password"

    click_button "Sign up"
    assert page.has_content?("A message with a confirmation link has been sent to your email address.")
  end
end

