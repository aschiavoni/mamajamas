require 'spec_helper'

feature "Visitor signs up" do

  scenario "with valid username, email and password", js: true do
    tempuser = build(:user)
    sign_up_with tempuser.username, tempuser.email, "really!good$password"
    expect(page).to have_content("confirmation link")
  end

end
