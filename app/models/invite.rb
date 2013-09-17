class Invite < ActiveRecord::Base
  belongs_to :user

  attr_accessible :user_id, :email, :invite_sent_at, :name,
    :picture_url, :provider, :uid, :from, :message

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :provider, presence: true,
    inclusion: { in: %w(facebook gmail mamajamas) }

  validates :email, presence: true, unless: Proc.new { |i| i.provider == "facebook" }
  validates :email, format: { with: Devise.email_regexp }
end
