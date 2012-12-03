require 'spec_helper'

feature "Visitor signs up" do

  scenario "with valid username, email and password" do
    sign_up_with "testuser", "testuser@domain.com", "really good password"
    expect(page).to have_content("Welcome to Mamajamas!")
  end

end
