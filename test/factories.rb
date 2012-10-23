FactoryGirl.define do
  factory :user do
    sequence(:username) { |n| "user#{n}" }
    email { |u| "#{u.username}@factory.com" }
    password "foobar"
    password_confirmation { |u| u.password }
  end
end
