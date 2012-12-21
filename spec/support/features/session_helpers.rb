module Features
  module SessionHelpers
    def sign_up_with(username, email, password)
      visit root_path

      # signup dialog
      click_link "signup-link"

      # expand email signup form
      find(".collapsible").click
      page.should have_selector("#user_username", visible: true)

      # fill out signup form
      fill_in "Username", with: username
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Confirm password", with: password
      # i don't like this but I think the collapsible is interfering otherwise
      sleep 0.5

      page.should have_selector("#bt-create-account", visible: true)
      click_button "bt-create-account"
    end

    def sign_up_with_and_logout(username, email, password)
      sign_up_with username, email, password
      page.should have_selector("#logout", visible: true)
      click_link "Logout"
      expect(page).to have_content("Signed out")
    end

    def sign_in_with(username, email, password, with = :username)
      # go to the home page
      visit root_path
      expect(page).to have_content("Welcome to Mamajamas")

      # login dialog
      click_link "login-link"
      page.should have_selector("#login-window", visible: true)

      # email login
      login = with == :username ? username : email
      fill_in "Username or email", with: login
      fill_in "Password", with: password

      click_button "Log in"
    end
  end
end
