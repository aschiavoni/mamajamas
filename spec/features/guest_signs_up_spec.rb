require 'spec_helper'

feature "guest visitor", js: true do

  scenario "takes quiz and signs up with email" do
    VCR.use_cassette('guest/signs_up_email') do
      visit root_path
      expect(page).to have_content("Mamajamas")

      take_quiz

      click_link "Done"

      add_manual_item "Bath Tub", "http://google.com"

      # HACK: force there to be an item
      page.execute_script("Mamajamas.Context.List.set('item_count', 1)")
      click_link "Save"
      sleep 0.5
      page.should have_selector("#signup-modal", visible: true)

      find("#signup-collapsible").click
      page.should have_selector("#user_email", visible: true)

      # fill out signup form
      fill_in "First and last name", with: "Guest UserSignup"
      sleep 0.5
      fill_in "Email", with: "guestsignup@example.com"
      sleep 0.5
      fill_in "Password", with: "test12345!"
      sleep 0.5
      fill_in "Confirm password", with: "test12345!"
      sleep 0.5

      page.should have_selector("#bt-create-account", visible: true)
      click_button "bt-create-account"

      expect(page).to have_content("Create my profile")
      current_path.should == profile_path
    end
  end

  scenario "takes quiz and signs up with facebook" do
    VCR.use_cassette('signup/guest_facebook') do
      visit root_path
      expect(page).to have_content("Mamajamas")

      take_quiz

      click_link "Done"

      add_manual_item "Bath Tub", "http://google.com"

      click_link "Save"
      page.has_selector?('#create-account-email', visible: true)

      mock_facebook_omniauth('9993883', "guestfacebook@example.com")
      page.execute_script("Mamajamas.Context.LoginSession.saveSession(true);")

      expect(page).to have_content("Create my profile")
      current_path.should == profile_path
    end
  end
end
