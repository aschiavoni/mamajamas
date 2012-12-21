require 'spec_helper'


feature "guest visitor" do

  scenario "visits home page" do
    visit root_path
    expect(page).to have_content("Mamajamas")
  end

end

feature "logged in visitor", js: true do

  before(:each) do
    # this expects this user to already existing in the test db
    @password = "test12345!"
    @testuser = User.find_by_username!("test12345")
  end

  scenario "visits home page" do
    sign_in_with @testuser.username, @testuser.email, @password, :username

    expect(page).to have_content("Signed in")
    expect(page).to have_content("Your baby gear list")
  end

end
