class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :access_token, :access_token_expires_at, :provider, :uid

  scope :facebook, lambda { where(provider: "facebook") }
  scope :google, lambda { where(provider: "google") }

  def access_token_expired?
    Time.now.utc > access_token_expires_at
  end
end
