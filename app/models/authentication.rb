class Authentication < ActiveRecord::Base
  belongs_to :user
  attr_accessible :access_token, :access_token_expires_at, :provider, :uid
end
