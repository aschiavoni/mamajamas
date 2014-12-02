class Gift < ActiveRecord::Base
  belongs_to :user
  belongs_to :list_item

  attr_accessible(:list_item, :list_item_id, :user_id, :full_name, :email,
                  :purchased, :quantity)

  validates :full_name, presence: true
  validates :email, presence: true, format: { with: Devise.email_regexp }

  after_save :update_list_item_gifted_count
  after_destroy :update_list_item_gifted_count

  def update_list_item_gifted_count
    list_item = ListItem.find_by(id: self.list_item_id)
    if list_item.present?
      existing_gift_count =
        Gift.where(list_item_id: list_item.id, purchased: true).sum(:quantity)

      list_item.gifted_quantity = existing_gift_count
      list_item.save!
    end
  end
end
