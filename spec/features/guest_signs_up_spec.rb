require 'spec_helper'

feature "guest visitor", js: true do

  scenario "takes quiz and signs up with email" do
    VCR.use_cassette('guest/signs_up_email') do
      visit root_path
      expect(page).to have_content("Mamajamas")

      take_quiz

      click_link "Close"

      click_link "Done"

      page.execute_script("$.cookies.set('no_show_added', true, {path: '/'});")
      add_manual_item "Bath Tub", "http://google.com"

      # HACK: force there to be an item
      page.execute_script("Mamajamas.Context.List.set('item_count', 1)")
      click_link "Save"
      sleep_maybe
      expect(page).to have_selector("#signup-modal", visible: true)

      find("#signup-collapsible").click
      expect(page).to have_selector("#user_email", visible: true)

      # fill out signup form
      fill_in "First and last name", with: "Guest UserSignup"
      sleep_maybe
      fill_in "Email", with: "guestsignup@example.com"
      sleep_maybe
      fill_in "Password", with: "test12345!"
      sleep_maybe
      fill_in "Confirm password", with: "test12345!"
      sleep_maybe

      expect(page).to have_selector("#bt-create-account", visible: true)
      click_button "bt-create-account"

      sleep_maybe
      expect(page).to have_content("Registry")
      expect(current_path).to eq(registry_path)
    end
  end

  scenario "takes quiz and signs up with facebook" do
    VCR.use_cassette('signup/guest_facebook') do
      visit root_path
      expect(page).to have_content("Mamajamas")

      take_quiz

      click_link "Done"

      click_link "close-drag"

      page.execute_script("$.cookies.set('no_show_added', true, {path: '/'});")
      add_manual_item "Bath Tub", "http://google.com"

      click_link "Save"
      page.has_selector?('#create-account-email', visible: true)

      mock_facebook_omniauth('9993883', "guestfacebook@example.com")
      page.execute_script("Mamajamas.Context.LoginSession.saveSession(true);")

      expect(page).to have_content("Registry")
      expect(current_path).to eq(registry_path)
    end
  end
end
