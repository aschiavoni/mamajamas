require 'spec_helper'

feature "Visitor logs in", js: true do

  before(:each) do
    # this expects this user to already existing in the test db
    @password = "test12345!"
    @testuser = User.find_by_username!("test12345")
  end

  scenario "with valid username and password" do
    sign_in_with @testuser.username, @testuser.email, @password, :username

    expect(page).to have_content("Signed in")
    expect(page).to have_content("Your baby gear list")
    current_path.should == list_path
  end

  scenario "with valid email and password" do
    sign_in_with @testuser.username, @testuser.email, @password, :email

    expect(page).to have_content("Signed in")
    expect(page).to have_content("Your baby gear list")
    current_path.should == list_path
  end

  scenario "with invalid email" do
    sign_in_with @testuser.username, nil, @password, :email

    expect(page).to have_selector(".instruction.error", text: "login")
  end

  scenario "with invalid password" do
    sign_in_with @testuser.username, nil, nil, :email

    expect(page).to have_selector(".instruction.error", text: "login")
  end

  describe "with facebook" do

    scenario "existing user" do
      # mock omniauth and pre-create a user so we simulate logging
      # in an already exiting mamajamas user
      mock_omniauth('99999', @testuser.email)

      # user = build(:user,
      #              email: OmniAuth.config.mock_auth[:facebook]["info"]["email"])
      # sign_up_with_and_logout user.username, user.email, "realgood!password"

      visit root_path
      click_link "login-link"
      page.has_css?("#login-window", visible: true)

      # simulate login
      page.execute_script("Mamajamas.Context.LoginSession.saveSession();");

      # should be on the list page
      expect(page).to have_content("Your baby gear list")
      current_path.should == list_path
    end

  end

end
