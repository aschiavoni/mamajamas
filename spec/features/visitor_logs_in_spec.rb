require 'spec_helper'

feature "Visitor logs in", js: true do

  before(:each) do
    # this expects this user to already existing in the test db
    @password = Features::SessionHelpers::TEST_USER_PASSWORD
    @testuser = test_user_with_list
  end

  scenario "with valid username and password" do
    VCR.use_cassette('login/valid') do
      sign_in_with @testuser.username, @testuser.email, @password, :username

      expect(page).to have_content("Signed in")
      expect(page).to have_content("Registry")
      expect(current_path).to eq(list_path)
    end
  end

  scenario "with valid email and password" do
    VCR.use_cassette('login/valid') do
      sign_in_with @testuser.username, @testuser.email, @password, :email

      expect(page).to have_content("Signed in")
      expect(page).to have_content("Registry")
      expect(current_path).to eq(list_path)
    end
  end

  scenario "with invalid email" do
    VCR.use_cassette('login/invalid_email') do
      sign_in_with @testuser.username, nil, @password, :email

      sleep_maybe
      expect(page).to have_selector(".instruction.error", text: "login")
    end
  end

  scenario "with invalid password" do
    VCR.use_cassette('login/invalid_password') do
      sign_in_with @testuser.username, nil, nil, :email

      sleep_maybe
      expect(page).to have_selector(".instruction.error", text: "login")
    end
  end

  describe "with facebook" do

    scenario "existing user" do
      VCR.use_cassette('login/facebook') do
        # mock omniauth and pre-create a user so we simulate logging
        # in an already exiting mamajamas user
        mock_facebook_omniauth('99999', @testuser.email)

        visit root_path
        sleep_maybe
        click_link "login-link"
        page.has_css?("#login-window", visible: true)

        # simulate login
        page.execute_script("Mamajamas.Context.LoginSession.saveSession(true);")

        # should be on the list page
        expect(page).to have_content("Registry")
      end
    end

  end

end
