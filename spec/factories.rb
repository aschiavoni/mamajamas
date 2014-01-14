FactoryGirl.define do
  sequence :username do |n|
    "user#{n}"
  end

  factory :user do
    username { FactoryGirl.generate(:username) }
    email { |u| "#{u.username || FactoryGirl.generate(:username)}@factory.com" }
    password "foobar"
    password_confirmation { |u| u.password }
    guest false
    country_code "US"
    quiz_taken_at { Time.now.utc }
  end

  factory :category do
    sequence(:name) { |n| "Category #{n}" }
  end

  factory :product_type do
    category
    sequence(:name) { |n| "Product Type #{n}" }
    plural_name { "#{name}.pluralize" }
    age_range
    priority 2
    active true
  end

  factory :product_type_query do
    product_type
    sequence(:query) { |n| "query #{n}" }
  end

  factory :list do
    sequence(:title) { |n| "List #{n}" }
    user
    privacy List::PRIVACY_PRIVATE
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
    product_type_name "Bath Tub"
    placeholder false
  end

  factory :product do
    vendor "fakeamazon"
    sequence(:vendor_id) { |n| "fakeamazon#{n}" }
    name "some product name"
    url { |p| "http://#{p.vendor}.com/#{p.vendor_id}" }
    rating nil
    image_url { |p| "http://images.#{p.vendor}.com/#{p.vendor_id}" }
    medium_image_url { |p| "http://images.#{p.vendor}.com/m#{p.vendor_id}" }
    large_image_url { |p| "http://images.#{p.vendor}.com/l#{p.vendor_id}" }
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
    image "some_image.png"
  end

  factory :product_rating do
    vendor "amazon"
    vendor_id "B00083HK0M"
    rating 3.0
  end

  factory :answer, class: "Quiz::Answer" do
    question "feeding"
    answers [ "Breast Feed", "Pump" ]
  end

  factory :invite do
    user
    provider "mamajamas"
    email "user@example.com"
    name "Stu Redmond"
    from "John Doe"
    message "check this out"
  end

  factory :authentication do
    user
    provider "facebook"
    uid "999999"
    access_token "kjdkk"
    access_token_expires_at { 30.days.from_now }
  end

  factory :social_friends do
    user
    provider "facebook"
    friends []
  end

  factory :recommended_product do
    product_type
    name "Sample Product Name"
    link "http://amazon.com"
    vendor "amazon"
    vendor_id "12345"
    image_url "http://amazon.com/image"
    tag "eco"
  end
end
