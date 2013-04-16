FactoryGirl.define do
  sequence :username do |n|
    "user#{n}"
  end

  factory :user do
    username { FactoryGirl.generate(:username) }
    email { |u| "#{u.username}@factory.com" }
    password "foobar"
    password_confirmation { |u| u.password }
    guest false
    country_code "US"
  end

  factory :category do
    sequence(:name) { |n| "Category #{n}" }
  end

  factory :product_type do
    category
    sequence(:name) { |n| "Product Type #{n}" }
    age_range
    priority 2
  end

  factory :product_type_query do
    product_type
    sequence(:query) { |n| "query #{n}" }
  end

  factory :list do
    sequence(:title) { |n| "List #{n}" }
    user
    public false
  end

  factory :list_item do
    list
    product_type
    category
    sequence(:name) { |n| "List Item #{n}" }
    owned false
    link "http://somedomain.com/somelistitem"
    rating 5
    age_range
    priority 2
    notes nil
    image_url "http://somedomain.com/somelistitem"
    placeholder false
  end

  factory :product do
    vendor "fakeamazon"
    sequence(:vendor_id) { |n| "fakeamazon#{n}" }
    name "some product name"
    url { |p| "http://#{p.vendor}.com/#{p.vendor_id}" }
    rating nil
    image_url { |p| "http://images.#{p.vendor}.com/#{p.vendor_id}" }
  end

  factory :age_range do
    sequence(:name) { |m| "#{n} mo" }
    sequence(:position) { |n| n }
  end

  factory :kid do
    sequence(:name) { |n| "kid#{n}" }
    gender "m"
    age_range
  end

  factory :list_item_image do
    user user
    image "/assets/some_image.png"
  end
end
