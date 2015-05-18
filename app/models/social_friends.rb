class SocialFriends < ActiveRecord::Base
  belongs_to :user
  serialize :friends, Array
  attr_accessible :friends, :provider

  scope :facebook, lambda { where(provider: "facebook") }
  scope :google, lambda { where(provider: "google") }
end
