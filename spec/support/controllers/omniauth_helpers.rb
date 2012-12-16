module Controllers
  module OmniauthHelpers
    def mock_omniauth
      OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
        "provider"  => "facebook",
        "uid"       => '12345',
        "info" => {
          "email" => "email@email.com",
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
