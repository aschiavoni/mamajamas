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

  scenario "with invalid email" do
    sign_up_with_and_logout @tempuser.username, @tempuser.email, @password
    sign_in_with @tempuser.username, nil, @password, :email, true

    expect(page).to have_selector(".instruction.error", text: "login")
  end

  scenario "with invalid password" do
    sign_up_with_and_logout @tempuser.username, @tempuser.email, @password
    sign_in_with @tempuser.username, nil, nil, :email, true

    expect(page).to have_selector(".instruction.error", text: "login")
  end

  describe "with facebook" do

    scenario "existing user" do
      # mock omniauth and pre-create a user so we simulate logging
      # in an already exiting mamajamas user
      mock_omniauth

      user = build(:user,
                   email: OmniAuth.config.mock_auth[:facebook]["info"]["email"])
      sign_up_with_and_logout user.username, user.email, "realgood!password"

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
