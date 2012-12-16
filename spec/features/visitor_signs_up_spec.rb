require 'spec_helper'

feature "Visitor signs up", js: true do

  scenario "with valid username, email and password" do
    @tempuser = build(:user)
    sign_up_with @tempuser.username, @tempuser.email, "really!good$password"

    expect(page).to have_content("confirmation link")
    expect(page).to have_content("Hello, #{@tempuser.username}")
    expect(page).to have_content("Follow Mom Friends")
    current_path.should == friends_path
  end

  scenario "with invalid username" do
    @tempuser = build(:user)
    sign_up_with nil, @tempuser.email, "really!good$password"
    expect(page).to have_selector(".status-msg.error", text: "username")
  end

  scenario "with invalid email" do
    @tempuser = build(:user)
    sign_up_with @tempuser.username, nil, "really!good$password"
    expect(page).to have_selector(".status-msg.error", text: "email")
  end

  scenario "with invalid password" do
    @tempuser = build(:user)
    sign_up_with @tempuser.username, @tempuser.email, nil
    expect(page).to have_selector(".status-msg.error", text: "password")
  end

  scenario "with valid facebook account" do
    mock_omniauth
    visit root_path
    click_link "signup-link"
    page.has_selector?('#create-account', visible: true)

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
