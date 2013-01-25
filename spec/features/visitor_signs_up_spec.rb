require 'spec_helper'

feature "Visitor signs up", js: true do

  scenario "with valid email and password" do
    @tempuser = build(:user)
    sign_up_with @tempuser.email, "really!good$password"

    expect(page).to have_selector("#logout")
    expect(page).to have_content("Hello, #{@tempuser.username}")
    expect(page).to have_content("Follow Mom Friends")
    current_path.should == friends_path
  end

  scenario "with invalid email" do
    @tempuser = build(:user)
    sign_up_with nil, "really!good$password"
    expect(page).to have_selector(".status-msg.error", text: "email")
  end

  scenario "with invalid password" do
    @tempuser = build(:user)
    sign_up_with @tempuser.email, nil
    expect(page).to have_selector(".status-msg.error", text: "password")
  end

  scenario "with valid facebook account" do
    mock_omniauth('54321')
    visit root_path
    click_link "signup-link"
    page.has_selector?('#create-account-email', visible: true)

    # simulate login
    page.execute_script("Mamajamas.Context.LoginSession.saveSession();")

    # should be on the friends page
    expect(page).to have_content("Follow Mom Friends")
  end

end
