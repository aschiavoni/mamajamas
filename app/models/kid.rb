class Kid < ActiveRecord::Base
  belongs_to :age_range
  belongs_to :user

  attr_accessible :birthday, :gender, :name
end
