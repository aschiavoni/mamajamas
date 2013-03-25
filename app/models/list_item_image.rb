class ListItemImage < ActiveRecord::Base
  attr_accessible :image, :image_cache

  belongs_to :user

  mount_uploader :image, ListItemImageUploader
end
