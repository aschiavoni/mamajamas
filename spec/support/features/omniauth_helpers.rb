module Features
  module OmniauthHelpers
    def mock_omniauth(uid = '12345')
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        "provider"  => "facebook",
        "uid"       => uid,
        "info" => {
          "email" => "#{uid}@email.com",
          "nickname" => "john",
          "first_name" => "John",
          "last_name"  => "Doe",
          "name"       => "John Doe"
        },
        "credentials" => {
          "token" => "12345",
          "expires_at" => 11111,
          "expires" => true
        },
        "extra" => {
          "raw_info" => {
            "username" => "john",
            "first_name" => "John",
            "last_name" => "Doe"
          }
        }
      })
    end
  end
end
