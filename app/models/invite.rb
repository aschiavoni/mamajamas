class Invite < ActiveRecord::Base
  attr_accessible :email, :invite_sent_at, :name, :picture_url, :provider, :uid
end
