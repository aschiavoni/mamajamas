class MigrateFacebookCredentialsToAuthentications < ActiveRecord::Migration
  def up
    User.where(provider: "facebook").each do |user|
      adder = AddsAuthentication.new(user)
      adder.add(user.provider, {
        uid: user.uid,
        access_token: user.access_token,
        access_token_expires_at: user.access_token_expires_at
      })
    end
  end

  def down
    Authentication.where(provider: "facebook").destroy_all
  end
end
