require 'spec_helper'

feature "Visitor signs up", js: true do

  scenario "with valid name, email and password" do
    VCR.use_cassette('signup/email') do
      @tempuser = build(:user)
      sign_up_with @tempuser.email, "really!good$password"

      sleep 0.5
      expect(page).to have_selector("#logout")
      expect(page).to have_content(@tempuser.username)
      expect(page).to have_content("Take the quiz")
      current_path.should == friends_path
    end
  end

  scenario "with invalid email" do
    @tempuser = build(:user)
    sign_up_with nil, "really!good$password"
    sleep 0.5
    expect(page).to have_selector(".status-msg.error", text: "email")
  end

  scenario "with invalid password" do
    @tempuser = build(:user)
    sign_up_with @tempuser.email, nil
    sleep 0.5
    expect(page).to have_selector(".status-msg.error", text: "password")
  end

  scenario "with invalid name" do
    @tempuser = build(:user)
    sign_up_with @tempuser.email, "really!good$password", nil
    sleep 0.5
    expect(page).to have_selector(".status-msg.error", text: "name")
  end

  scenario "with valid facebook account" do
    VCR.use_cassette('signup/facebook') do
      mock_omniauth('54321')
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
