module Features
  module SessionHelpers
    def sign_up_with(username, email, password)
      visit root_path

      # signup dialog
      click_link "signup-link"

      # email signup
      click_link "bt-account-email"

      # fill out signup form
      fill_in "Username", with: username
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Confirm password", with: password

      click_button "Create Account"
    end

    def sign_up_with_and_logout(username, email, password)
      sign_up_with username, email, password
      expect(page).to have_content("confirmation link")
      click_link "logout"
    end

    def sign_in_with(username, email, password, with = :username)
      # signup and logout
      sign_up_with_and_logout username, email, password

      # go to the home page
      visit root_path
      expect(page).to have_content("Mamajamas")

      # login dialog
      click_link "login-link"

      # email login
      login = with == :username ? username : email
      fill_in "Username or email", with: login
      fill_in "Password", with: password

      click_button "Log in"
    end
  end
end
