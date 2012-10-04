require "minitest_helper"

class CanAccessHomeTest < MiniTest::Rails::ActionDispatch::IntegrationTest
  test "home page has content" do
    visit root_path
    assert page.has_content?("Mamajamas")
  end
end
