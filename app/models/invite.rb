class Invite < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user_id, :email, :invite_sent_at, :name,
    :picture_url, :provider, :uid

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :provider, presence: true,
    inclusion: { in: %w(facebook gmail mamajamas) }
end
