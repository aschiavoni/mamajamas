require 'spec_helper'

feature "Visitor logs in", js: true do

  before(:each) do
    @password = "test12345!"
    @tempuser = build(:user, password: @password)
  end

  scenario "with valid username and password" do
    sign_in_with @tempuser.username, @tempuser.email, @password, :username

    expect(page).to have_content("Signed in")
    expect(page).to have_content("Your baby gear list")
    current_path.should == list_path
  end

  scenario "with valid email and password" do
    sign_in_with @tempuser.username, @tempuser.email, @password, :email

    expect(page).to have_content("Signed in")
    expect(page).to have_content("Your baby gear list")
    current_path.should == list_path
  end

end
