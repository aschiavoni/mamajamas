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

    def sign_in
      user = create(:user)
      visit new_user_session_path
      fill_in "Username or email", with: user.username
      fill_in "Password", with: user.password
      click_button "Log in"
    end
  end
end
