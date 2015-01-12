require 'spec_helper'

feature "Visitor signs up", js: true do

  scenario "with valid name, email and password" do
    VCR.use_cassette('signup/email') do
      @tempuser = build(:user)
      sign_up_with @tempuser.email, "really!good$password"

      sleep_maybe
      expect(page).to have_selector("#logout")
      expect(page).to have_content(@tempuser.username)
      expect(page).to have_content("Tell us a little")
      expect(current_path).to eq(quiz_path)
    end
  end

  scenario "with invalid email" do
    VCR.use_cassette('signup/invalid_email') do
      @tempuser = build(:user)
      sign_up_with nil, "really!good$password"
      sleep_maybe
      expect(page).to have_selector(".status-msg.error", text: "email")
    end
  end

  scenario "with invalid password" do
    VCR.use_cassette('signup/invalid_password') do
      @tempuser = build(:user)
      sign_up_with @tempuser.email, nil
      sleep_maybe
      expect(page).to have_selector(".status-msg.error", text: "password")
    end
  end

  scenario "with invalid name" do
    VCR.use_cassette('signup/invalid_name') do
      @tempuser = build(:user)
      sign_up_with @tempuser.email, "really!good$password", nil
      sleep_maybe
      expect(page).to have_selector(".status-msg.error", text: "name")
    end
  end

  scenario "with valid facebook account" do
    VCR.use_cassette('signup/facebook') do
      mock_facebook_omniauth('54321')
      visit root_path
      click_link "signup-link"
      sleep_maybe
      page.has_selector?('#create-account-email', visible: true)

      # simulate login
      page.execute_script("Mamajamas.Context.LoginSession.saveSession(true);")
      sleep_maybe

      # should be on the quiz
      sleep_maybe
      expect(page).to have_content("Tell us a little")
    end
  end

end
