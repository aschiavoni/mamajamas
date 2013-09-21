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
  end
end
