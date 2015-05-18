module Features
  module OmniauthHelpers
    def mock_facebook_omniauth(uid = '12345', email = nil, first_name = nil, last_name = nil)
      fname = first_name || "John"
      lname = last_name || "Doe"
      username = fname.downcase

      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        "provider"  => "facebook",
        "uid"       => uid,
        "info" => {
          "email" => (email.blank? ? "#{uid}@email.com" : email),
          "nickname" => username,
          "first_name" => fname,
          "last_name" => lname,
          "name" => "#{fname} #{lname}"
        },
        "credentials" => {
          "token" => uid,
          "expires_at" => 11111,
          "expires" => true
        },
        "extra" => {
          "raw_info" => {
            "username" => username,
            "first_name" => fname,
            "last_name" => lname
          }
        }
      })
    end

    def mock_google_omniauth(uid = '12345', email = nil, first_name = nil, last_name = nil)
      fname = first_name || "John"
      lname = last_name || "Doe"
      email_addr = email || "#{uid}@example.com"

      OmniAuth.config.mock_auth[:google] = OmniAuth::AuthHash.new({
        :provider => "google",
        :uid => uid,
        :info => {
          :name => "#{first_name} #{last_name}",
          :email => email_addr,
          :first_name => fname,
          :last_name => lname,
          :image => "https://lh3.googleusercontent.com/url/photo.jpg"
        },
        :credentials => {
          :token => "token",
          :refresh_token => "another_token",
          :expires_at => 1354920555,
          :expires => true
        },
        :extra => {
          :raw_info => {
            :id => uid,
            :email => email_addr,
            :verified_email => true,
            :name => "#{first_name} #{last_name}",
            :given_name => fname,
            :family_name => lname,
            :link => "https://plus.google.com/123456789",
            :picture => "https://lh3.googleusercontent.com/url/photo.jpg",
            :gender => "male",
            :birthday => "0000-06-25",
            :locale => "en",
            :hd => "example.com"
          }
        }
      })
    end
  end
end
