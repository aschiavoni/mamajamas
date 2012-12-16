require 'spec_helper'

feature "Visitor signs up" do

  scenario "with valid username, email and password", js: true do
    @tempuser = build(:user)
    sign_up_with @tempuser.username, @tempuser.email, "really!good$password"

    expect(page).to have_content("confirmation link")
    expect(page).to have_content("Hello, #{@tempuser.username}")
    expect(page).to have_content("Follow Mom Friends")
    current_path.should == friends_path
  end

end

feature "Facebook visitor signs up" do

  scenario "with valid facebook account", js: true do
    mock_omniauth
    visit root_path
    click_link "login-link"
    page.has_selector?('#login-window', visible: true)

    # simulate login
    page.execute_script("Mamajamas.Context.LoginSession.saveSession();");

    # set username
    page.has_selector?("#post-signup", visible: true)
    fill_in "Username", with: "username"
    click_button "Continue"

    # should be on the friends page
    expect(page).to have_content("Follow Mom Friends")
  end

end
