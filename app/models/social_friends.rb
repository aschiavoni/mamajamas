class SocialFriends < ActiveRecord::Base
  belongs_to :user
  serialize :friends, Array
  attr_accessible :friends
end
