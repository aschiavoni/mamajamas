class Invite < ActiveRecord::Base
  belongs_to :user
  belongs_to :list

  attr_accessible :user_id, :email, :invite_sent_at, :name, :list_id,
                  :picture_url, :provider, :uid, :from, :message, :subject

  validates :user_id, presence: true
  validates :name, presence: true, length: { maximum: 255 }
  validates :provider, presence: true,
    inclusion: { in: %w(facebook google mamajamas mamajamas_share) }

  validates :email, presence: true, unless: Proc.new { |i| i.provider == "facebook" }
  validates :email, format: { with: Devise.email_regexp }, if: Proc.new { |i| i.email.present? }
end
