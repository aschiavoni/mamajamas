FactoryGirl.define do
  sequence :username do |n|
    "user#{n}"
  end

  factory :user do
    username { FactoryGirl.generate(:username) }
    email { |u| "#{u.username}@factory.com" }
    password "foobar"
    password_confirmation { |u| u.password }
  end

  factory :category do
    sequence(:name) { |n| "Category #{n}" }
  end

  factory :product_type do
    category
    sequence(:name) { |n| "Product Type #{n}" }
    when_to_buy_suggestion
    priority 2
  end

  factory :list do
    sequence(:title) { |n| "List #{n}" }
    user
  end

  factory :list_item do
    list
    product_type
    category
    sequence(:name) { |n| "List Item #{n}" }
    owned false
    link "http://somedomain.com/somelistitem"
    rating 5
    when_to_buy "Pre-birth"
    priority 2
    notes nil
    image_url "http://somedomain.com/somelistitem"
  end

  factory :product do
    vendor "fakeamazon"
    sequence(:vendor_id) { |n| "fakeamazon#{n}" }
    name "some product name"
    product_type
    url { |p| "http://#{p.vendor}.com/#{p.vendor_id}" }
    rating nil
    image_url { |p| "http://images.#{p.vendor}.com/#{p.vendor_id}" }
  end

  factory :when_to_buy_suggestion do
    sequence(:name) { |m| "#{n} mo" }
    sequence(:position) { |n| n }
  end
end
