class Gift < ActiveRecord::Base
  belongs_to :user
  belongs_to :list_item

  attr_accessible(:list_item, :list_item_id, :user_id, :full_name, :email,
                  :purchased, :quantity)

  validates :full_name, presence: true
  validates :email, presence: true, format: { with: Devise.email_regexp }
end
