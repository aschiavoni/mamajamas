describe AddsAuthentication, :type => :model do

  let (:user) { double(authentications: double) }

  context "oauth" do

    it "adds an oauth authentication" do
      allow(user.authentications).to receive_messages(where: [])
      expect(user.authentications).to receive(:create!)
      oauth = OmniauthHashParser.new(mock_google_omniauth)
      AddsAuthentication.new(user).from_oauth(oauth)
    end

    it "updates an existing oauth authentication" do
      authentication = double
      allow(user.authentications).to receive_messages(where: [ authentication ])
      expect(authentication).to receive(:update_attributes!)
      oauth = OmniauthHashParser.new(mock_google_omniauth)
      AddsAuthentication.new(user).from_oauth(oauth)
    end

  end

  context "add" do

    it "adds an oauth authentication" do
      allow(user.authentications).to receive_messages(where: [])
      expect(user.authentications).to receive(:create!)
      AddsAuthentication.new(user).add("facebook", {
        uid: "12345",
        access_token: "99999",
        access_token_expires_at: 5.days.from_now.to_i.to_s
      })
    end

    it "updates an existing oauth authentication" do
      authentication = double
      allow(user.authentications).to receive_messages(where: [ authentication ])
      expect(authentication).to receive(:update_attributes!)
      AddsAuthentication.new(user).add("facebook", {
        uid: "12345",
        access_token: "99999",
        access_token_expires_at: 5.days.from_now.to_i.to_s
      })
    end

  end

end
