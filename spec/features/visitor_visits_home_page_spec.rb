require 'spec_helper'


feature "guest visitor" do

  scenario "visits home page" do
    visit root_path
    expect(page).to have_content("Mamajamas")
  end

end

feature "logged in visitor", js: true do

  before(:each) do
    @password = "test12345!"
    @tempuser = build(:user, password: @password)
  end

  scenario "visits home page" do
    sign_in_with @tempuser.username, @tempuser.email, @password, :username

    expect(page).to have_content("Signed in")
    expect(page).to have_content("Your baby gear list")
  end

end
