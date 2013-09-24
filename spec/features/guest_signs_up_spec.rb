require 'spec_helper'

feature "guest visitor", js: true do

  scenario "takes quiz and signs up with email" do
    visit root_path
    expect(page).to have_content("Mamajamas")

    take_quiz

    click_link "Done"

    add_manual_item "Bath Tub", "http://google.com"

    click_link "Share your list"
    page.should have_selector("#signup-modal", visible: true)

    find("#signup-collapsible").click
    page.should have_selector("#user_email", visible: true)

    # fill out signup form
    fill_in "First and last name", with: "Guest UserSignup"
    fill_in "Email", with: "guestsignup@example.com"
    fill_in "Password", with: "test12345!"
    fill_in "Confirm password", with: "test12345!"

    page.should have_selector("#bt-create-account", visible: true)
    click_button "bt-create-account"

    expect(page).to have_content("Create my profile")
    current_path.should == profile_path
  end

  scenario "takes quiz and signs up with facebook" do
    VCR.use_cassette('signup/guest_facebook') do
      visit root_path
      expect(page).to have_content("Mamajamas")

      take_quiz

      click_link "Done"

      add_manual_item "Bath Tub", "http://google.com"

      click_link "Share your list"
      page.has_selector?('#create-account-email', visible: true)

      mock_facebook_omniauth('9993883', "guestfacebook@example.com")
      page.execute_script("Mamajamas.Context.LoginSession.saveSession(true);")

      expect(page).to have_content("Follow Friends")
      current_path.should == friends_path
    end
  end
end
