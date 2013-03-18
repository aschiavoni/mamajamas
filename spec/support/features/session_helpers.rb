module Features
  module SessionHelpers
    TEST_USER_NAME = "test_user"
    TEST_USER_NAME_WITH_LIST = "test_user_list"
    TEST_USER_PASSWORD = "test12345!"

    def self.create_test_user
      User.create!({
        username: TEST_USER_NAME,
        email: "#{TEST_USER_NAME}@test.com",
        password: TEST_USER_PASSWORD,
        password_confirmation: TEST_USER_PASSWORD
      })
    end

    def self.create_test_user_with_list
      user = User.create!({
        username: TEST_USER_NAME_WITH_LIST,
        email: "#{TEST_USER_NAME_WITH_LIST}@test.com",
        password: TEST_USER_PASSWORD,
        password_confirmation: TEST_USER_PASSWORD
      })
      user.build_list!
    end

    def test_user
      user = User.find_by_username(TEST_USER_NAME)
      user = create_test_user if user.blank?
      user
    end

    def test_user_with_list
      user = User.find_by_username(TEST_USER_NAME_WITH_LIST)
      user = create_test_user_with_list if user.blank?
      user
    end

    def sign_up_with(email, password)
      visit root_path

      # signup dialog
      click_link "signup-link"

      # expand email signup form
      find(".collapsible").click
      page.should have_selector("#user_email", visible: true)

      # fill out signup form
      fill_in "Email", with: email
      fill_in "Password", with: password
      fill_in "Confirm password", with: password
      # i don't like this but I think the collapsible is interfering otherwise
      sleep 0.5

      page.should have_selector("#bt-create-account", visible: true)
      click_button "bt-create-account"
    end

    def sign_up_with_and_logout(email, password)
      sign_up_with email, password
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
