# FactoryGirl.define do
#   factory :user do
#     sequence(:username) { |n| "user#{n}" }
#     email { |u| "#{u.username}@factory.com" }
#     password "foobar"
#     password_confirmation { |u| u.password }
#   end
# 
#   factory :category do
#     sequence(:name) { |n| "Category #{n}" }
#   end
# 
#   factory :product_type do
#     category
#     sequence(:name) { |n| "Product Type #{n}" }
#     when_to_buy "Pre-birth"
#     priority 2
#   end
# 
#   factory :list do
#     sequence(:title) { |n| "List #{n}" }
#     user
#   end
# end
