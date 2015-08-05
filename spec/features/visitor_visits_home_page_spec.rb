require 'spec_helper'


feature "guest visitor" do

  scenario "visits home page" do
    VCR.use_cassette('visit/guest_home') do
      visit root_path
      expect(page).to have_content("Mamajamas")
    end
  end

end

feature "logged in visitor", js: true do

  before(:each) do
    VCR.use_cassette('visit/setup') do
      # this expects this user to already existing in the test db
      @password = Features::SessionHelpers::TEST_USER_PASSWORD
      @testuser = test_user_with_list
    end
  end

  scenario "visits home page" do
    VCR.use_cassette('visit/home') do
      sign_in_with @testuser.username, @testuser.email, @password, :username

      expect(page).to have_content("test_user_list")
    end
  end

end
