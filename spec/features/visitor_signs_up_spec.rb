require 'spec_helper'

feature "Visitor signs up", js: true do

  scenario "with valid name, email and password" do
    VCR.use_cassette('signup/email') do
      @tempuser = build(:user)
      sign_up_with @tempuser.email, "really!good$password"

      sleep 0.5
      expect(page).to have_selector("#logout")
      expect(page).to have_content(@tempuser.username)
      expect(page).to have_content("Follow Friends")
      current_path.should == friends_path
    end
  end

  scenario "with invalid email" do
    VCR.use_cassette('signup/invalid_email') do
      @tempuser = build(:user)
      sign_up_with nil, "really!good$password"
      sleep 0.5
      expect(page).to have_selector(".status-msg.error", text: "email")
    end
  end

  scenario "with invalid password" do
    VCR.use_cassette('signup/invalid_password') do
      @tempuser = build(:user)
      sign_up_with @tempuser.email, nil
      sleep 0.5
      expect(page).to have_selector(".status-msg.error", text: "password")
    end
  end

  scenario "with invalid name" do
    VCR.use_cassette('signup/invalid_name') do
      @tempuser = build(:user)
      sign_up_with @tempuser.email, "really!good$password", nil
      sleep 0.5
      expect(page).to have_selector(".status-msg.error", text: "name")
    end
  end

  scenario "with valid facebook account" do
    VCR.use_cassette('signup/facebook') do
      mock_facebook_omniauth('54321')
      visit root_path
      click_link "signup-link"
      page.has_selector?('#create-account-email', visible: true)

      # simulate login
      page.execute_script("Mamajamas.Context.LoginSession.saveSession(true);")

      # should be on the friends page
      expect(page).to have_content("Follow Friends")
    end
  end

end
